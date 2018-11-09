/* This file partially modifies from
 *
 *   R-devel\src\include\Defn.h
 *   R-devel\src\main\sysutils.c
 *   R-devel\src\main\names.c
 *   R-devel\src\gnuwin32\extra.c
 *
 * WCC: The default shell.exec did not have any option. The application is
 *	always active in a normal window. This modification is trying to add
 *      options such that the application can be in a minimized window or an
 *      invisible window or a background running window. The application should
 *      not block the R GUI in any case.
 */

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Riconv.h>

#include <wchar.h>

#ifdef WIN
#include <windows.h>
#endif

#define UNUSED(x) (void)(x)


/* From R-devel\src\include\Defn.h */
#define BYTES_MASK (1<<1)
#define LATIN1_MASK (1<<2)
#define UTF8_MASK (1<<3)
#define IS_BYTES(x) (LEVELS(x) & BYTES_MASK)
#define IS_LATIN1(x) (LEVELS(x) & LATIN1_MASK)
#define IS_UTF8(x) (LEVELS(x) & UTF8_MASK)


/* From R-devel\src\main\sysutils.c */
#define BSIZE 100000 
wchar_t *filenameToWchar_wcc(const SEXP fn, const Rboolean expand){
	static wchar_t filename[BSIZE + 1];
	void *obj;
	const char *from = "", *inbuf;
	char *outbuf;
	size_t inb, outb, res;

	if(!strlen(CHAR(fn))){
		wcscpy(filename, L"");
		return filename;
	}

	if(IS_LATIN1(fn)) from = "latin1";
	if(IS_UTF8(fn)) from = "UTF-8";
	if(IS_BYTES(fn)) warning("encoding of a filename cannot be 'bytes'");

	obj = Riconv_open("UCS-2LE", from);
	if(obj == (void *)(-1))
		warning("unsupported conversion from '%s' in shellexec_wcc.c",
			  from);

	if(expand) inbuf = R_ExpandFileName(CHAR(fn)); else inbuf = CHAR(fn);

	inb = strlen(inbuf)+1; outb = 2*BSIZE;
	outbuf = (char *) filename;
	res = Riconv(obj, &inbuf , &inb, &outbuf, &outb);
	Riconv_close(obj);
	if(inb > 0) warning("file name conversion problem -- name too long?");
	if(res == -1) warning("file name conversion problem");

	return filename;
} /* End of filenameToWchar_wcc(). */


/* From R-devel\src\gnuwin32\extra.c */
#ifdef WIN
static inline void internal_shellexecW_wcc(const wchar_t * file, Rboolean rhome,
		int C_SW_cmd){
	const wchar_t *home;
	wchar_t home2[10000], *p;
	uintptr_t ret;

	if(rhome){
		home = _wgetenv(L"R_HOME");
		if(home == NULL) warning("R_HOME not set");
		wcsncpy(home2, home, 10000);
		for(p = home2; *p; p++) if(*p == L'/') *p = L'\\';
		home = home2;
	} else{
		home = NULL;
	}
   
	ret = (uintptr_t) ShellExecuteW(NULL, L"open", file, NULL, home,
			C_SW_cmd);
	if(ret <= 32){ /* an error condition */
		if(ret == ERROR_FILE_NOT_FOUND || ret == ERROR_PATH_NOT_FOUND
		   || ret == SE_ERR_FNF || ret == SE_ERR_PNF)
			warning("'%ls' not found", file);
		if(ret == SE_ERR_ASSOCINCOMPLETE || ret == SE_ERR_NOASSOC)
			warning("file association for '%ls' not available or invalid",
				file);
		if(ret == SE_ERR_ACCESSDENIED || ret == SE_ERR_SHARE)
			warning("access to '%ls' denied", file);
		warning("problem in displaying '%ls'", file);
	}
} /* End of internal_shellexecW_wcc().*/
#endif


/* From R-devel\src\main\names.c and R-devel\src\gnuwin32\extra.c */
SEXP shellexec_wcc(SEXP R_file, SEXP R_SW_cmd){
	/* Possible values of R_SW_cmd, see MS website for details.
	 * https://msdn.microsoft.com/en-us/library/windows/desktop/bb762153%28v=vs.85%29.aspx
	 *
	 * SW_SHOW (5)
	 *     Activates the window and displays it in its current size
	 *     and position.
	 *
	 * SW_SHOWMINIMIZED (2)
	 *     Activates the window and displays it as a minimized window.
	 *
	 * SW_SHOWMINNOACTIVE (7)
	 *     Displays the window as a minimized window.
	 *     The active window remains active.
	 *
	 * SW_SHOWNA (8)
	 *     Displays the window in its current state.
	 *     The active window remains active.
	 */

#ifdef WIN
	internal_shellexecW_wcc(
		filenameToWchar_wcc(STRING_ELT(R_file, 0), FALSE),
		FALSE, INTEGER(R_SW_cmd)[0]);
#else
	UNUSED(R_file);
	UNUSED(R_SW_cmd);
#endif

	return(R_NilValue);
} /* End of shellexec_wcc(). */
