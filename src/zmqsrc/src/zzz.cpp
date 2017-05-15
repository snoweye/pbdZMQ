#include <R.h>
#include <R_ext/Rdynload.h>

void R_init_libzmq(DllInfo *info){
	R_registerRoutines(info, NULL, NULL, NULL, NULL);
	R_useDynamicSymbols(info, FALSE);
} /* End of R_init_libzmq(). */
