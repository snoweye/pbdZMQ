#include "R_zmq.h"


// 100 KiB
#define BUFLEN 102400

SEXP R_zmq_send_file(SEXP R_socket, SEXP R_filename, SEXP R_flags){
	SEXP ret;
	size_t size, total_size = 0;
	int info = -1, C_errno;
	int C_flags = INTEGER(R_flags)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	FILE *infile = fopen(CHARPT(R_filename, 0), "r");
	void *buf = malloc(BUFLEN);

	if(infile == NULL)
		error("Could not open file: %s", CHARPT(R_filename, 0));

	if(buf == NULL)
		error("Could not allocate temporary buffer");

	do{
		size = fread(buf, 1, BUFLEN, infile);
		total_size += size;

		if(size < BUFLEN && !feof(infile))
			error("Error reading from file: %s", CHARPT(R_filename, 0));

		info = zmq_send(C_socket, buf, size, C_flags);
		if(info == -1){
			C_errno = zmq_errno();
			error("could not send data:  %d strerror: %s\n", C_errno, zmq_strerror(C_errno));
		}

	}while(size == BUFLEN);

cleanup:
	free(buf);
	fclose(infile);

	PROTECT(ret = allocVector(INTSXP, 1));
	INTEGER(ret)[0] = 0;
	UNPROTECT(1);
	return ret;
}



SEXP R_zmq_recv_file(SEXP R_socket, SEXP R_filename, SEXP R_flags){
	SEXP ret;
	size_t expected_size, size, total_size = 0;
	int info = -1, C_errno;
	int C_flags = INTEGER(R_flags)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	FILE *outfile = fopen(CHARPT(R_filename, 0), "w");
	void *buf = malloc(BUFLEN);

	if(outfile == NULL)
		error("Could not open file: %s", CHARPT(R_filename, 0));

	if (buf == NULL)
		error("Could not allocate temporary buffer");

	do{
		size = zmq_recv(C_socket, buf, BUFLEN, C_flags);
		if(size == -1){
			C_errno = zmq_errno();
			error("could not send data:  %d strerror: %s\n", C_errno, zmq_strerror(C_errno));
		}

		if(size > BUFLEN) /* Truncated data. Error? */
			size = BUFLEN;

		total_size += size;
		expected_size=size;

		size = fwrite(buf, 1, size, outfile);

		if(size < expected_size)
			error("Could not write to file: %s", CHARPT(R_filename, 0));

	}while(size == BUFLEN);

cleanup:
	free(buf);
	fclose(outfile);

	PROTECT(ret = allocVector(INTSXP, 1));
	INTEGER(ret)[0] = 0;
	UNPROTECT(1);
	return ret;
}
