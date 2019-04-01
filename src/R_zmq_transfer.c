#include "R_zmq.h"
#include <stdint.h>

// 200 KiB
#define BUFLEN 2// 204800

#define PROGRESS_BARLEN 30
#define PROGRESS_SCALE 1024
static const char *memnames[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"};

typedef struct file_t
{
  char *filename;
  FILE *file;
  double filesize;
  int verbose;
} file_t;


static inline int progress_init(const int verbose, double total)
{
  int i;
  int ind = 0;
  
  if (!verbose) return -1;
  
  while (total >= PROGRESS_SCALE)
  {
    total /= (double) PROGRESS_SCALE;
    ind++;
  }
  
  Rprintf("[");
  for (i=0; i<PROGRESS_BARLEN; i++)
    Rprintf("-");
  
  Rprintf("] 0 / %.3f %s", total, memnames[ind]);
  return ind;
}



static inline void progress_update(const int verbose, const double current, const double total, const int ind)
{
  int i;
  int len = (int) PROGRESS_BARLEN*(current/total);
  double divby = 1./pow(PROGRESS_SCALE, ind);
  
  if (!verbose) return;
  
  Rprintf("\r[");
  for (i=0; i<len; i++)
    Rprintf("#");
  for (i=len+1; i<PROGRESS_BARLEN; i++)
    Rprintf("-");
  
  Rprintf("] %.2f / %.2f %s", current*divby, total*divby, memnames[ind]);
}



static inline void transfer_check(int info, char *kind, void *buf, FILE *infile)
{
  if (info == -1)
  {
    free(buf);
    fclose(infile);
    int C_errno = zmq_errno();
    error("could not %s data:  %d strerror: %s\n", kind, C_errno, zmq_strerror(C_errno));
  }
}



// ----------------------------------------------------------------------------
// Send
// ----------------------------------------------------------------------------

static inline void send_file(file_t *f, void *C_socket, void *buf, int C_flags)
{
  uint64_t total_size = 0;
  size_t size;
  
  int ind = progress_init(f->verbose, f->filesize);
  
  do
  {
    size = fread(buf, 1, BUFLEN, f->file);
    total_size += size;
    
    if (size < BUFLEN && !feof(f->file))
      error("Error reading from file: %s", f->filename);
    
    int info = zmq_send(C_socket, buf, size, C_flags);
    transfer_check(info, "send", buf, f->file);
    progress_update(f->verbose, (double) total_size, f->filesize, ind);
    
  } while (size == BUFLEN);
}



SEXP R_zmq_send_file(SEXP R_socket, SEXP R_filename, SEXP verbose,
  SEXP filesize, SEXP R_flags, SEXP R_forcebin, SEXP type_)
{
  SEXP ret;
  int C_flags = INTEGER(R_flags)[0];
  void *C_socket = R_ExternalPtrAddr(R_socket);
  char *filename = CHARPT(R_filename, 0);
  int type = INTEGER(type_)[0];
  
  void *buf = malloc(BUFLEN);
  if (buf == NULL)
    error("Could not allocate temporary buffer");
  
  char *mode = (INTEGER(R_forcebin)[0] == 0) ? "r" : "r+b";
  FILE *infile = fopen(filename, mode);
  if (infile == NULL)
  {
    free(buf);
    error("Could not open file: %s", filename);
  }
  
  file_t f;
  f.filename = filename;
  f.file = infile;
  f.filesize = REAL(filesize)[0];
  f.verbose = INTEGER(verbose)[0];
  
  if (type == ZMQ_PUSH)
    send_file(&f, C_socket, buf, C_flags);
  else if (type == ZMQ_REQ)
  {
    send_file(&f, C_socket, buf, C_flags | ZMQ_SNDMORE);
    zmq_recv(C_socket, buf, 1, C_flags);
  }
  
  free(buf);
  fclose(infile);
  if (f.verbose)
    Rprintf("\n");
  
  PROTECT(ret = allocVector(INTSXP, 1));
  INTEGER(ret)[0] = 0;
  UNPROTECT(1);
  return ret;
}




// ----------------------------------------------------------------------------
// Receive
// ----------------------------------------------------------------------------

static inline void recv_file(file_t *f, void *C_socket, void *buf, int C_flags)
{
  uint64_t total_size = 0;
  size_t size;
  
  int ind = progress_init(f->verbose, f->filesize);
  
  do
  {
    int expected_size = zmq_recv(C_socket, buf, BUFLEN, C_flags | ZMQ_SNDMORE);
    transfer_check(expected_size, "receive", buf, f->file);
    size = (size_t) expected_size;
    
    if (size > BUFLEN) /* Truncated data. Error? */
      size = BUFLEN;
    
    total_size += size;
    
    size = fwrite(buf, 1, size, f->file);
    
    if (expected_size < 0 || size < (size_t)expected_size)
    {
      free(buf);
      fclose(f->file);
      error("Could not write to file: %s", f->filename);
    }
    
    progress_update(f->verbose, (double) total_size, f->filesize, ind);
    
  } while (size == BUFLEN);
}



SEXP R_zmq_recv_file(SEXP R_socket, SEXP R_filename, SEXP verbose,
  SEXP filesize_, SEXP R_flags, SEXP R_forcebin, SEXP type_)
{
  SEXP ret;
  int C_flags = INTEGER(R_flags)[0];
  void *C_socket = R_ExternalPtrAddr(R_socket);
  char *filename = CHARPT(R_filename, 0);
  int type = INTEGER(type_)[0];
  
  void *buf = malloc(BUFLEN);
  if (buf == NULL)
    error("Could not allocate temporary buffer");
  
  char *mode = (INTEGER(R_forcebin)[0] == 0) ? "w" : "w+b";
  FILE *outfile = fopen(filename, mode);
  if (outfile == NULL)
  {
    free(buf);
    error("Could not open file: %s", CHARPT(R_filename, 0));
  }
  
  file_t f;
  f.filename = filename;
  f.file = outfile;
  f.filesize = REAL(filesize_)[0];
  f.verbose = INTEGER(verbose)[0];
  
  recv_file(&f, C_socket, buf, C_flags);
  if (type == ZMQ_REP)
    zmq_send(C_socket, buf, 1, C_flags);
  
  free(buf);
  fclose(outfile);
  if (f.verbose)
    Rprintf("\n");
  
  PROTECT(ret = allocVector(INTSXP, 1));
  INTEGER(ret)[0] = 0;
  UNPROTECT(1);
  return ret;
}
