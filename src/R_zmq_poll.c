#include "R_zmq.h"

zmq_pollitem_t *PBD_POLLITEM = NULL;
int PBD_POLLITEM_LENGTH = 0;
int PBD_POLLITEM_MAXSIZE = 10;

/* Poll related. */
SEXP R_zmq_poll(SEXP R_socket, SEXP R_type, SEXP R_timeout){
	int C_ret = -1, i;

	PBD_POLLITEM_LENGTH = LENGTH(R_socket);
	if(PBD_POLLITEM_LENGTH > PBD_POLLITEM_MAXSIZE){
		REprintf("Too many sockets (%d) are asked.\n", PBD_POLLITEM_LENGTH);
	}

	PBD_POLLITEM = (zmq_pollitem_t *) malloc(PBD_POLLITEM_LENGTH * sizeof(zmq_pollitem_t));
	for(i = 0; i < PBD_POLLITEM_LENGTH; i++){
		PBD_POLLITEM[i].socket = R_ExternalPtrAddr(VECTOR_ELT(R_socket, i));
		PBD_POLLITEM[i].events = (short) INTEGER(R_type)[i];
	}

	C_ret = zmq_poll(PBD_POLLITEM, PBD_POLLITEM_LENGTH, (long) INTEGER(R_timeout)[0]);
	if(C_ret == -1){
		C_errno = zmq_errno();
		Rprintf("R_zmq_poll: %d strerror: %s\n",
			C_errno, zmq_strerror(C_errno));
	}
	return(AsInt(C_ret));
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

