#include "R_zmq.h"

/* Poll related. */
SEXP R_zmq_poll2(SEXP R_socket, SEXP R_type, SEXP R_timeout){
	SEXP R_ret, R_pollret, R_pollitem, R_ret_names;
	char *names_R_ret[] = {"pollret", "pollitem"};
	int C_ret = -1, C_errno, i;
	zmq_pollitem_t *C_pollitem = NULL;
	int C_pollitem_length = 0;

	C_pollitem_length = LENGTH(R_socket);
	C_pollitem = (zmq_pollitem_t *) malloc(C_pollitem_length * sizeof(zmq_pollitem_t));
	PROTECT(R_pollitem = R_MakeExternalPtr(C_pollitem, R_NilValue, R_NilValue));
	for(i = 0; i < C_pollitem_length; i++){
		C_pollitem[i].socket = R_ExternalPtrAddr(VECTOR_ELT(R_socket, i));
		C_pollitem[i].events = (short) INTEGER(R_type)[i];
	}

	C_ret = zmq_poll(C_pollitem, C_pollitem_length, (long) INTEGER(R_timeout)[0]);
	C_errno = zmq_errno();

	/* Bring both C_ret and C_errno back to R. */
	PROTECT(R_pollret = allocVector(INTSXP, 3));
	INTEGER(R_pollret)[0] = C_ret;
	INTEGER(R_pollret)[1] = C_errno;
	INTEGER(R_pollret)[2] = C_pollitem_length;

	/* For return. */
	PROTECT(R_ret = allocVector(VECSXP, 2));
	PROTECT(R_ret_names = allocVector(STRSXP, 2));
	SET_VECTOR_ELT(R_ret, 0, R_pollret);
	SET_VECTOR_ELT(R_ret, 1, R_pollitem);
        SET_STRING_ELT(R_ret_names, 0, mkChar(names_R_ret[0]));
        SET_STRING_ELT(R_ret_names, 1, mkChar(names_R_ret[1]));
        setAttrib(R_ret, R_NamesSymbol, R_ret_names);

	UNPROTECT(4);
	return(R_ret);
} /* End of R_zmq_poll2(). */

SEXP R_zmq_poll2_get_revents(SEXP R_index, SEXP R_pollitem){
	int C_ret, C_index = INTEGER(R_index)[0];
	zmq_pollitem_t *C_pollitem = NULL;

	C_pollitem = R_ExternalPtrAddr(R_pollitem);
	C_ret = (int) C_pollitem[C_index].revents;

	return(AsInt(C_ret));
} /* End of R_zmq_poll2_get_revents(). */

