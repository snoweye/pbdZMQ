#ifndef __R_ZMQ__
#define __R_ZMQ__

#include <R.h>
#include <Rinternals.h>
#include "zmq.h"

/* Obtain character pointers. */
#define CHARPT(x,i)	((char*)CHAR(STRING_ELT(x,i)))

/* Context related. */
// static void ctx_Finalizer(SEXP R_context);
SEXP R_zmq_ctx_new();
SEXP R_zmq_ctx_destroy(SEXP R_context);

/* Socket related. */
// static void socket_Finalizer(SEXP R_socket);
SEXP R_zmq_socket(SEXP R_context, SEXP type);
SEXP R_zmq_close(SEXP R_socket);
SEXP R_zmq_bind(SEXP R_socket, SEXP R_endpoint);
SEXP R_zmq_connect(SEXP R_socket, SEXP R_endpoint);
SEXP R_zmq_disconnect(SEXP R_socket, SEXP R_endpoint);
SEXP R_zmq_setsockopt(SEXP R_socket, SEXP R_option_name, SEXP R_option_value,
	SEXP R_option_type);
SEXP R_zmq_getsockopt(SEXP R_socket, SEXP R_option_name, SEXP R_option_value,
	SEXP R_option_type);

/* Message related. */
// static void msg_Finalizer(SEXP R_msg_t);
SEXP R_zmq_msg_init();
SEXP R_zmq_msg_close(SEXP R_msg_t);
SEXP R_zmq_msg_send(SEXP R_rmsg, SEXP R_socket, SEXP R_flags);
SEXP R_zmq_msg_recv(SEXP R_socket, SEXP R_flags);

/* Send and receive related. */
SEXP R_zmq_send(SEXP R_socket, void *C_buf, SEXP R_len, SEXP R_flags);
SEXP R_zmq_send_char(SEXP R_socket, SEXP R_buf, SEXP R_len, SEXP R_flags);
SEXP R_zmq_send_raw(SEXP R_socket, SEXP R_buf, SEXP R_len, SEXP R_flags);
int R_zmq_recv(SEXP R_socket, void *C_buf, SEXP R_len, SEXP R_flags);
SEXP R_zmq_recv_char(SEXP R_socket, SEXP R_len, SEXP R_flags);
SEXP R_zmq_recv_raw(SEXP R_socket, SEXP R_len, SEXP R_flags);

/* Utility related. */
SEXP AsInt(int x);
SEXP R_zmq_strerror();
SEXP R_zmq_version();

/* shellexec. */
SEXP shellexec_wcc(SEXP R_file, SEXP R_SW_cmd);

/* Poll related. */
SEXP R_zmq_poll(SEXP R_socket, SEXP R_type, SEXP R_timeout, SEXP R_check_eintr);
SEXP R_zmq_poll_free();
SEXP R_zmq_poll_length();
SEXP R_zmq_poll_get_revents(SEXP R_index);

#endif
