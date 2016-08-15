#include "R_zmq.h"

/* Message related. */
/* Use R level reg.finalizer to handle this and avoid seg. fault.
static void msg_Finalizer(SEXP R_msg_t){
}*/ /* End of msg_Finalizer(). */

SEXP R_zmq_msg_init(){
	SEXP R_msg_t = R_NilValue;
	int C_ret = -1, C_errno;
	zmq_msg_t C_msg_t;

	C_ret = zmq_msg_init(&C_msg_t);
	if(C_ret != -1){
		PROTECT(R_msg_t = R_MakeExternalPtr((void *) &C_msg_t, R_NilValue, R_NilValue));
		// R_Register(R_msg_t, msg_Finalizer, TRUE);
		UNPROTECT(1);
	} else{
		C_errno = zmq_errno();
		Rprintf("R_zmq_msg_init errno: %d strerror: %s\n",
			C_errno, zmq_strerror(C_errno));
	}
	return(R_msg_t);
} /* End of R_zmq_init(). */

SEXP R_zmq_msg_close(SEXP R_msg_t){
	int C_ret = -1, C_errno;
	zmq_msg_t *C_msg_t = R_ExternalPtrAddr(R_msg_t);

	if(C_msg_t == NULL){
		return(R_NilValue);
	}

	C_ret = zmq_msg_close(C_msg_t);
	if(C_ret == -1){
		C_errno = zmq_errno();
		Rprintf("R_zmq_msg_close errno: %d stderror: %s\n",
			C_errno, zmq_strerror(C_errno));
	}
	return(AsInt(C_ret));
} /* End of R_zmq_msg_close(). */

SEXP R_zmq_msg_send(SEXP R_rmsg, SEXP R_socket, SEXP R_flags){
	int C_rmsg_length = LENGTH(R_rmsg);
	int C_ret = -1, C_errno, C_flags = INTEGER(R_flags)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	zmq_msg_t msg;

	if(C_socket != NULL){
		C_ret = zmq_msg_init_size(&msg, C_rmsg_length);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_msg_init_size errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
		memcpy(zmq_msg_data(&msg), RAW(R_rmsg), C_rmsg_length);

		C_ret = zmq_msg_send(&msg, C_socket, C_flags);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_msg_send errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}

		C_ret = zmq_msg_close(&msg);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_msg_close errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_send: C_socket is not available.\n");
	}

	return(R_NilValue);
} /* End of R_zmq_msg_send(). */

SEXP R_zmq_msg_recv(SEXP R_socket, SEXP R_flags){
	SEXP R_rmsg = R_NilValue;
	int C_rmsg_length;
	int C_ret = -1, C_errno, C_flags = INTEGER(R_flags)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	zmq_msg_t msg;

	if(C_socket != NULL){
		C_ret = zmq_msg_init(&msg);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_msg_init errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}

		C_ret = zmq_msg_recv(&msg, C_socket, C_flags);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_msg_recv errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
		C_rmsg_length = zmq_msg_size(&msg);
		PROTECT(R_rmsg = allocVector(RAWSXP, C_rmsg_length));
		memcpy(RAW(R_rmsg), zmq_msg_data(&msg), C_rmsg_length);

		C_ret = zmq_msg_close(&msg);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_msg_close errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}

		UNPROTECT(1);
		return(R_rmsg);
	} else{
		warning("R_zmq_send: C_socket is not available.\n");
	}

	return(R_rmsg);
} /* End of R_zmq_msg_recv(). */
