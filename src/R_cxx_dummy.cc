/* Empty file to have C++ runtime library loaded and to avoid clang++
 * linking problem in MacOS ARM64.
 * */
#include <R.h>
extern "C" {
void R_cxx_dummy() {
	Rprintf("From R_cxx_dummy().\n");
}
}
