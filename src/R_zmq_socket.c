#include "R_zmq.h"


/* Socket related. */
/* Use R level reg.finalizer to handle this and avoid seg. fault. */

SEXP R_zmq_socket(SEXP R_context, SEXP R_type){
	SEXP R_socket = R_NilValue;
	int C_type = INTEGER(R_type)[0];
	void *C_context = R_ExternalPtrAddr(R_context);
	void *C_socket;

	if(C_context != NULL){
		C_socket = zmq_socket(C_context, C_type);

		if(C_socket != NULL){
			PROTECT(R_socket = R_MakeExternalPtr(C_socket, R_NilValue, R_NilValue));
			// R_RegisterCFinalizerEx(R_socket, socket_Finalizer, TRUE);
			UNPROTECT(1);
		} else{
			warning("R_zmq_socket: R_socket is not available.\n");
		}
	} else{
		warning("R_zmq_socket: C_context is not available.\n");
	}
	return(R_socket);
} /* End of R_zmq_socket(). */

SEXP R_zmq_close(SEXP R_socket){
	int C_ret = -1, C_errno;
	void *C_socket = R_ExternalPtrAddr(R_socket);

	if(C_socket == NULL){
		return(R_NilValue);
	}

	C_ret = zmq_close(C_socket);
	if(C_ret == -1){
		C_errno = zmq_errno();
		warning("R_zmq_socket_close errno: %d strerror: %s\n",
			C_errno, zmq_strerror(C_errno));
	}
	return(AsInt(C_ret));
} /* End of R_zmq_close(). */

SEXP R_zmq_bind(SEXP R_socket, SEXP R_endpoint){
	int C_ret = -1, C_errno;
	void *C_socket = R_ExternalPtrAddr(R_socket);
	const char *C_endpoint = CHARPT(R_endpoint, 0);

	if(C_socket != NULL){
		C_ret = zmq_bind(C_socket, C_endpoint);
		if(C_ret == -1){
			C_errno = zmq_errno();
			warning("R_zmq_bind errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_bind: C_socket is not available.\n");
	}
	return(AsInt(C_ret));
} /* End of R_zmq_bind(). */

SEXP R_zmq_connect(SEXP R_socket, SEXP R_endpoint){
	int C_ret = -1, C_errno;
	void *C_socket = R_ExternalPtrAddr(R_socket);
	const char *C_endpoint = CHARPT(R_endpoint, 0);

	if(C_socket != NULL){
		C_ret = zmq_connect(C_socket, C_endpoint);
		if(C_ret == -1){
			C_errno = zmq_errno();
			warning("R_zmq_connect errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_connect: C_socket is not available.\n");
	}
	return(AsInt(C_ret));
} /* End of R_zmq_connect(). */

SEXP R_zmq_disconnect(SEXP R_socket, SEXP R_endpoint){
	int C_ret = -1, C_errno;
	void *C_socket = R_ExternalPtrAddr(R_socket);
	const char *C_endpoint = CHARPT(R_endpoint, 0);

	if(C_socket != NULL){
		C_ret = zmq_disconnect(C_socket, C_endpoint);
		if(C_ret == -1){
			C_errno = zmq_errno();
			warning("R_zmq_disconnect errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_disconnect: C_socket is not available.\n");
	}
	return(AsInt(C_ret));
} /* End of R_zmq_disconnect(). */

SEXP R_zmq_setsockopt(SEXP R_socket, SEXP R_option_name, SEXP R_option_value,
		SEXP R_option_type){
	int C_ret = -1, C_errno;
	int C_option_name = INTEGER(R_option_name)[0];
	int C_option_type = INTEGER(R_option_type)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	void *C_option_value;
	size_t C_option_len;

	if(C_socket != NULL){
		switch(C_option_type){
			case 0:
				C_option_value = (void *) CHARPT(R_option_value, 0);
				C_option_len = strlen(C_option_value);
				break;
			case 1:
				C_option_value = (void *) INTEGER(R_option_value);
				C_option_len = sizeof(int);
				break;
			default:
				warning("C_option_type: %d is not implemented.\n",
					C_option_type);
		} // End of switch().

		C_ret = zmq_setsockopt(C_socket, C_option_name,
				C_option_value, C_option_len);
		if(C_ret == -1){
			C_errno = zmq_errno();
			warning("R_zmq_setsockopt errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_setsockopt: C_socket is not available.\n");
	}
	return(AsInt(C_ret));
} /* End of R_zmq_setsockopt(). */

SEXP R_zmq_getsockopt(SEXP R_socket, SEXP R_option_name, SEXP R_option_value,
		SEXP R_option_type){
	int C_ret = -1, C_errno;
	int C_option_name = INTEGER(R_option_name)[0];
	int C_option_type = INTEGER(R_option_type)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	void *C_option_value;
	size_t C_option_len;

	if(C_socket != NULL){
		switch(C_option_type){
			case 0:
				C_option_value = (void *) CHARPT(R_option_value, 0);
				C_option_len = strlen(C_option_value);
				break;
			case 1:
				C_option_value = (void *) INTEGER(R_option_value);
				C_option_len = sizeof(int);
				break;
			default:
				warning("C_option_type: %d is not implemented.\n",
					C_option_type);
		} // End of switch().

		C_ret = zmq_getsockopt(C_socket, C_option_name,
				C_option_value, &C_option_len);
		if(C_ret == -1){
			C_errno = zmq_errno();
			warning("R_zmq_getsockopt errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_getsockopt: C_socket is not available.\n");
	}
	return(AsInt(C_ret));
} /* End of R_zmq_getsockopt(). */

