#include "R_zmq.h"


/* Context related. */
/* Use R level reg.finalizer to handle this and avoid seg. fault. */

SEXP R_zmq_ctx_new(){
	SEXP R_context = R_NilValue;
	void *C_context = zmq_ctx_new();

	if(C_context != NULL){
		PROTECT(R_context = R_MakeExternalPtr(C_context, R_NilValue, R_NilValue));
		// R_RegisterCFinalizerEx(R_context, ctx_Finalizer, TRUE);
		UNPROTECT(1);
	} else{
		warning("R_zmq_ctx_new: R_context is not available.\n");
	}
	return(R_context);
} /* End of Rzmq_ctx_new(). */

SEXP R_zmq_ctx_destroy(SEXP R_context){
	int C_ret = -1, C_errno;
	void *C_context = R_ExternalPtrAddr(R_context);

	if(C_context == NULL){
		return(R_NilValue);
	}

	C_ret = zmq_ctx_destroy(C_context);
	if(C_ret == -1){
		C_errno = zmq_errno();
		warning("R_zmq_ctx_destroy errno: %d strerror: %s\n",
			C_errno, zmq_strerror(C_errno));
	}
	return(AsInt(C_ret));
} /* End of R_zmq_ctx_destroy(). */
