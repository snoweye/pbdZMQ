#include "R_zmq.h"

zmq_pollitem_t *PBD_POLLITEM = NULL;
int PBD_POLLITEM_LENGTH = 0;
// int PBD_POLLITEM_MAXSIZE = 10;

/* Poll related. */
SEXP R_zmq_poll(SEXP R_socket, SEXP R_type, SEXP R_timeout){
	SEXP R_x;
	int C_ret = -1, i;

	PBD_POLLITEM_LENGTH = LENGTH(R_socket);
/*
	if(PBD_POLLITEM_LENGTH > PBD_POLLITEM_MAXSIZE){
		REprintf("Too many sockets (%d) are asked.\n", PBD_POLLITEM_LENGTH);
	}
*/

	PBD_POLLITEM = (zmq_pollitem_t *) malloc(PBD_POLLITEM_LENGTH * sizeof(zmq_pollitem_t));
	for(i = 0; i < PBD_POLLITEM_LENGTH; i++){
		PBD_POLLITEM[i].socket = R_ExternalPtrAddr(VECTOR_ELT(R_socket, i));
		PBD_POLLITEM[i].events = (short) INTEGER(R_type)[i];
	}

	C_ret = zmq_poll(PBD_POLLITEM, PBD_POLLITEM_LENGTH, (long) INTEGER(R_timeout)[0]);

	/* WCC: This does not work for some signals or events.
		Ctrl+C will set C_ret = -1 and C_errno = 4 (EINT).
	if(C_ret == -1){
		C_errno = zmq_errno();
		Rprintf("R_zmq_poll: %d strerror: %s\n",
			C_errno, zmq_strerror(C_errno));
	}
	*/
	C_errno = zmq_errno();

	/* Bring both C_ret and C_errno back to R. */
	PROTECT(R_x = allocVector(INTSXP, 2));
	INTEGER(R_x)[0] = C_ret;
	INTEGER(R_x)[1] = C_errno;
	UNPROTECT(2);

	return(R_x);
} /* End of R_zmq_poll(). */

SEXP R_zmq_poll_free(){
	int i;
	if(PBD_POLLITEM_LENGTH != 0){
		free(PBD_POLLITEM);
	}
	return(R_NilValue);
} /* End of R_zmq_poll_free(). */

SEXP R_zmq_poll_length(){
	return(AsInt(PBD_POLLITEM_LENGTH));
} /* End of R_zmq_poll_length(). */

SEXP R_zmq_poll_get_revents(SEXP R_index){
	int C_ret, C_index = INTEGER(R_index)[0];
	C_ret = (int) PBD_POLLITEM[C_index].revents;
	return(AsInt(C_ret));
} /* End of R_zmq_poll_get_revents(). */

