#include "R_zmq.h"
#include <stdint.h>

// 200 KiB
#define BUFLEN 204800

#define BARLEN 30
#define SCALE 1024
static const char *memnames[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"};

static inline int progress_init(const int verbose, double total)
{
  int i;
  int ind = 0;
  
  if (!verbose) return -1;
  
  while (total >= SCALE)
  {
    total /= (double) SCALE;
    ind++;
  }
  
  Rprintf("[");
  for (i=0; i<BARLEN; i++)
    Rprintf("-");
  
  Rprintf("] 0 / %.3f %s", total, memnames[ind]);
  return ind;
}

static inline void progress_update(const int verbose, const double current, const double total, const int ind)
{
  int i;
  int len = (int) BARLEN*(current/total);
  double divby = 1./pow(SCALE, ind);
  
  if (!verbose) return;
  
  Rprintf("\r[");
  for (i=0; i<len; i++)
    Rprintf("#");
  for (i=len+1; i<BARLEN; i++)
    Rprintf("-");
  
  Rprintf("] %.2f / %.2f %s", current*divby, total*divby, memnames[ind]);
}

static inline void progress_fin(const int verbose, double total, const int ind)
{
  int i;
  
  double divby = 1./pow(SCALE, ind);
  
  if (!verbose) return;
  
  Rprintf("\r[");
  for (i=0; i<BARLEN; i++)
    Rprintf("#");
  
  Rprintf("] %.2f / %.2f %s\n", total*divby, total*divby, memnames[ind]);
  return ind;
}



SEXP R_zmq_send_file(SEXP R_socket, SEXP R_filename, SEXP verbose_, SEXP filesize_, SEXP R_flags){
  SEXP ret;
  int ind;
  const int verbose = INTEGER(verbose_)[0];
  const double filesize = REAL(filesize_)[0];
  size_t size;
  uint64_t total_size = 0;
  int info = -1, C_errno;
  int C_flags = INTEGER(R_flags)[0];
  void *C_socket = R_ExternalPtrAddr(R_socket);
  FILE *infile = fopen(CHARPT(R_filename, 0), "r");
  void *buf = malloc(BUFLEN);
  
  if (infile == NULL)
    error("Could not open file: %s", CHARPT(R_filename, 0));
  
  if (buf == NULL)
    error("Could not allocate temporary buffer");
  
  ind = progress_init(verbose, filesize);
  
  do
  {
    size = fread(buf, 1, BUFLEN, infile);
    total_size += size;
    
    if (size < BUFLEN && !feof(infile))
      error("Error reading from file: %s", CHARPT(R_filename, 0));
    
    info = zmq_send(C_socket, buf, size, C_flags);
    if (info == -1){
      C_errno = zmq_errno();
      error("could not send data:  %d strerror: %s\n", C_errno, zmq_strerror(C_errno));
    }
    
    progress_update(verbose, (double) total_size, filesize, ind);
    
  } while (size == BUFLEN);
  
cleanup:
  free(buf);
  fclose(infile);
  progress_fin(verbose, total_size, ind);
  
  PROTECT(ret = allocVector(INTSXP, 1));
  INTEGER(ret)[0] = 0;
  UNPROTECT(1);
  return ret;
}



SEXP R_zmq_recv_file(SEXP R_socket, SEXP R_filename, SEXP verbose_, SEXP filesize_, SEXP R_flags)
{
  SEXP ret;
  int ind;
  const int verbose = INTEGER(verbose_)[0];
  const double filesize = REAL(filesize_)[0];
  size_t expected_size, size;
  uint64_t total_size = 0;
  int info = -1, C_errno;
  int C_flags = INTEGER(R_flags)[0];
  void *C_socket = R_ExternalPtrAddr(R_socket);
  FILE *outfile = fopen(CHARPT(R_filename, 0), "w");
  void *buf = malloc(BUFLEN);
  
  if (outfile == NULL)
    error("Could not open file: %s", CHARPT(R_filename, 0));
  
  if (buf == NULL)
    error("Could not allocate temporary buffer");
  
  ind = progress_init(verbose, filesize);
  
  do
  {
    size = zmq_recv(C_socket, buf, BUFLEN, C_flags);
    if(size == -1){
      C_errno = zmq_errno();
      error("could not send data:  %d strerror: %s\n", C_errno, zmq_strerror(C_errno));
    }
    
    if (size > BUFLEN) /* Truncated data. Error? */
      size = BUFLEN;
    
    total_size += size;
    expected_size=size;
    
    size = fwrite(buf, 1, size, outfile);
    
    if (size < expected_size)
      error("Could not write to file: %s", CHARPT(R_filename, 0));
    
    progress_update(verbose, (double) total_size, filesize, ind);
    
  } while (size == BUFLEN);
  
cleanup:
  free(buf);
  fclose(outfile);
  progress_fin(verbose, total_size, ind);
  
  PROTECT(ret = allocVector(INTSXP, 1));
  INTEGER(ret)[0] = 0;
  UNPROTECT(1);
  return ret;
}
