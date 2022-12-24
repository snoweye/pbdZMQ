#include "R_zmq.h"

/* Internal. */
SEXP AsInt(int C_x){
	SEXP R_x;

	PROTECT(R_x = allocVector(INTSXP, 1));
	INTEGER(R_x)[0] = C_x;
	UNPROTECT(1);
	return(R_x);
} /* End of AsInt(). */


/* Error related. */
SEXP R_zmq_strerror(SEXP R_errno){
	SEXP R_strerror;

	PROTECT(R_strerror = allocVector(STRSXP, 1));
	SET_STRING_ELT(R_strerror, 0, mkChar(zmq_strerror(INTEGER(R_errno)[0])));
	UNPROTECT(1);
	return(R_strerror);
} /* End of R_zmq_strerror(). */


/* Version. */
SEXP R_zmq_version(void){
	int major, minor, patch;
	/* (10 bytes for int + 1 byte for sign) * 3 + 2 dots + 1 NUL */
	// char ver[36];
	// int chars;
	SEXP ret;

	zmq_version(&major, &minor, &patch);
	//Rprintf("Current ZeroMQ version is %d.%d.%d\n", major, minor, patch);

        /* R-devel on around Dec. 24, 2022 starting to warn the line below. */
	// chars = sprintf(ver, "%d.%d.%d", major, minor, patch);

	// ret = PROTECT(allocVector(STRSXP, 1));
	// SET_STRING_ELT(ret, 0, mkCharLen(ver, chars));
	ret = PROTECT(allocVector(INTSXP, 3));
	INTEGER(ret)[0] = major;
	INTEGER(ret)[1] = minor;
	INTEGER(ret)[2] = patch;
	UNPROTECT(1);
	return(ret);
} /* End of R_zmq_version(). */
