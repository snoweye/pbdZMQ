#include "R_zmq.h"

int C_errno;

/* Internal. */
SEXP AsInt(int C_x){
	SEXP R_x;

	PROTECT(R_x = allocVector(INTSXP, 1));
	INTEGER(R_x)[0] = C_x;
	UNPROTECT(1);
	return(R_x);
} /* End of AsInt().


/* Error related. */
SEXP R_zmq_strerror(SEXP R_errno){
	SEXP R_strerror;

	PROTECT(R_strerror = allocVector(STRSXP, 1));
	SET_STRING_ELT(R_strerror, 0, mkChar(zmq_strerror(INTEGER(R_errno)[0])));
	UNPROTECT(1);
	return(R_strerror);
} /* End of R_zmq_strerror(). */

SEXP R_zmq_errno(){
	// C_errno = zmq_errno();
	Rprintf("errno: %d strerror: %s\n", C_errno, zmq_strerror(C_errno));
	return(AsInt(C_errno));
} /* End of R_zmq_errno(). */


/* Version. */
SEXP R_zmq_version(){
	int major, minor, patch;
	char ver[5];
	SEXP ret;
	
	zmq_version(&major, &minor, &patch);
	//Rprintf("Current ZeroMQ version is %d.%d.%d\n", major, minor, patch);
	
	sprintf(ver, "%d.%d.%d", major, minor, patch);
	
	ret = PROTECT(allocVector(STRSXP, 1));
	SET_STRING_ELT(ret, 0, mkCharLen(ver, 5));
	
	UNPROTECT(1);
	return(ret);
} /* End of R_zmq_version(). */

