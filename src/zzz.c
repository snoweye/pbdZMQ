#include <R.h>
#include <R_ext/Rdynload.h>

#include "R_zmq.h"

static const R_CallMethodDef callMethods[] = {
	/* In file "R_zmq_context.c". */
	{"R_zmq_ctx_new", (DL_FUNC) &R_zmq_ctx_new, 0},
	{"R_zmq_ctx_destroy", (DL_FUNC) &R_zmq_ctx_destroy, 1},

	/* In file "R_zmq_socket.c". */
	{"R_zmq_socket", (DL_FUNC) &R_zmq_socket, 2},
	{"R_zmq_close", (DL_FUNC) &R_zmq_close, 1},
	{"R_zmq_bind", (DL_FUNC) &R_zmq_bind, 2},
	{"R_zmq_connect", (DL_FUNC) &R_zmq_connect, 2},
	{"R_zmq_setsockopt", (DL_FUNC) &R_zmq_setsockopt, 4},
	{"R_zmq_getsockopt", (DL_FUNC) &R_zmq_getsockopt, 4},

	/* In file "R_zmq_message.c". */
	{"R_zmq_msg_init", (DL_FUNC) &R_zmq_msg_init, 0},
	{"R_zmq_msg_close", (DL_FUNC) &R_zmq_msg_close, 1},
	{"R_zmq_msg_send", (DL_FUNC) &R_zmq_msg_send, 3},
	{"R_zmq_msg_recv", (DL_FUNC) &R_zmq_msg_recv, 2},

	/* In file "R_zmq_sendrecv.c". */
	{"R_zmq_send_char", (DL_FUNC) &R_zmq_send_char, 4},
	{"R_zmq_send_raw", (DL_FUNC) &R_zmq_send_raw, 4},
	{"R_zmq_recv_char", (DL_FUNC) &R_zmq_recv_char, 3},
	{"R_zmq_recv_raw", (DL_FUNC) &R_zmq_recv_raw, 3},

	/* In file "R_zmq_utility.c". */
	{"R_zmq_strerror", (DL_FUNC) &R_zmq_strerror, 1},
	{"R_zmq_version", (DL_FUNC) &R_zmq_version, 0},

	/* In file "shellexec_wcc.c". */
	{"shellexec_wcc", (DL_FUNC) &shellexec_wcc, 2},

	/* In file "R_zmq_poll.c". */
	{"R_zmq_poll", (DL_FUNC) &R_zmq_poll, 4},
	{"R_zmq_poll_free", (DL_FUNC) &R_zmq_poll_free, 0},
	{"R_zmq_poll_length", (DL_FUNC) &R_zmq_poll_length, 0},
	{"R_zmq_poll_get_revents", (DL_FUNC) &R_zmq_poll_get_revents, 1},

	/* Finish R_CallMethodDef. */
	{NULL, NULL, 0}
};
/* End of the callMethods[]. */


void R_init_pbdZMQ(DllInfo *info){
	R_registerRoutines(info, NULL, callMethods, NULL, NULL);
	R_useDynamicSymbols(info, FALSE);
	// R_forceSymbols(info, TRUE);
} /* End of R_init_pbdZMQ(). */
