#include "R_zmq.h"


/* Send related. */
SEXP R_zmq_send(SEXP R_socket, void *C_buf, SEXP R_len, SEXP R_flags){
	int C_ret = -1, C_errno, C_flags = INTEGER(R_flags)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	size_t C_len = (size_t) INTEGER(R_len)[0];

	if(C_socket != NULL){
		C_ret = zmq_send(C_socket, C_buf, C_len, C_flags);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_send errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_send: C_socket is not available.\n");
	}
	return(AsInt(C_ret));
} /* End of R_zmq_send(). */

SEXP R_zmq_send_char(SEXP R_socket, SEXP R_buf, SEXP R_len, SEXP R_flags){
	return(R_zmq_send(R_socket, (void *) CHARPT(R_buf, 0), R_len, R_flags));
} /* End of R_zmq_send_char(). */

SEXP R_zmq_send_raw(SEXP R_socket, SEXP R_buf, SEXP R_len, SEXP R_flags){
	return(R_zmq_send(R_socket, (void *) RAW(R_buf), R_len, R_flags));
} /* End of R_zmq_send_raw(). */


/* Recv related. */
int R_zmq_recv(SEXP R_socket, void *C_buf, SEXP R_len, SEXP R_flags){
	int C_ret = -1, C_errno, C_flags = INTEGER(R_flags)[0];
	void *C_socket = R_ExternalPtrAddr(R_socket);
	size_t C_len = (size_t) INTEGER(R_len)[0];

	if(C_socket != NULL){
		C_ret = zmq_recv(C_socket, C_buf, C_len, C_flags);
		if(C_ret == -1){
			C_errno = zmq_errno();
			Rprintf("R_zmq_recv errno: %d strerror: %s\n",
				C_errno, zmq_strerror(C_errno));
		}
	} else{
		warning("R_zmq_recv: C_socket is not available.\n");
	}
	return(C_ret);
} /* End of R_zmq_recv(). */

SEXP R_zmq_recv_char(SEXP R_socket, SEXP R_len, SEXP R_flags){
	SEXP R_ret, R_buf, R_recv_len, R_ret_names;
	char *names_R_ret[] = {"buf", "len"};
	void *C_buf;

	/* Allocate and protect storages. */
	PROTECT(R_ret = allocVector(VECSXP, 2));
	PROTECT(R_ret_names = allocVector(STRSXP, 2));
	PROTECT(R_buf = allocVector(STRSXP, 1));
	PROTECT(R_recv_len = allocVector(INTSXP, 1));

	/* Receive buffer. */
	C_buf = (void *) R_Calloc(INTEGER(R_len)[0], char);
	INTEGER(R_recv_len)[0] = R_zmq_recv(R_socket, C_buf, R_len, R_flags);
	SET_STRING_ELT(R_buf, 0, mkChar(C_buf));

	/* Set the elements and names. */
	SET_VECTOR_ELT(R_ret, 0, R_buf);
	SET_VECTOR_ELT(R_ret, 1, R_recv_len);
	SET_STRING_ELT(R_ret_names, 0, mkChar(names_R_ret[0]));
	SET_STRING_ELT(R_ret_names, 1, mkChar(names_R_ret[1]));
	setAttrib(R_ret, R_NamesSymbol, R_ret_names);

	/* Return. */
	UNPROTECT(4);
	R_Free(C_buf);
	return(R_ret);
} /* End of R_zmq_recv_char(). */

SEXP R_zmq_recv_raw(SEXP R_socket, SEXP R_len, SEXP R_flags){
	SEXP R_ret, R_buf, R_recv_len, R_ret_names;
	char *names_R_ret[] = {"buf", "len"};

	/* Allocate and protect storages. */
	PROTECT(R_ret = allocVector(VECSXP, 2));
	PROTECT(R_ret_names = allocVector(STRSXP, 2));
	PROTECT(R_buf = allocVector(RAWSXP, INTEGER(R_len)[0]));
	PROTECT(R_recv_len = allocVector(INTSXP, 1));

	/* Receive buffer. */
	INTEGER(R_recv_len)[0] = R_zmq_recv(R_socket, (void *) RAW(R_buf), R_len, R_flags);

	/* Set the elements and names. */
	SET_VECTOR_ELT(R_ret, 0, R_buf);
	SET_VECTOR_ELT(R_ret, 1, R_recv_len);
	SET_STRING_ELT(R_ret_names, 0, mkChar(names_R_ret[0]));
	SET_STRING_ELT(R_ret_names, 1, mkChar(names_R_ret[1]));
	setAttrib(R_ret, R_NamesSymbol, R_ret_names);

	/* Return. */
	UNPROTECT(4);
	return(R_ret);
} /* End of R_zmq_recv_raw(). */
