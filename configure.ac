dnl Process this file with autoconf to produce a configure script
AC_INIT(DESCRIPTION)

dnl Check chmod
chmod +x ./src/zmqsrc/autogen.sh
chmod +x ./src/zmqsrc/configure
chmod +x ./src/zmqsrc/version.sh
chmod +x ./src/zmqsrc/config/compile
chmod +x ./src/zmqsrc/config/config.guess
chmod +x ./src/zmqsrc/config/config.sub
chmod +x ./src/zmqsrc/config/depcomp
chmod +x ./src/zmqsrc/config/install-sh
chmod +x ./src/zmqsrc/config/missing

dnl Determine R_HOME.
: ${R_HOME=‘R RHOME‘}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
R_SCMD="${R_HOME}/bin/Rscript -e"

dnl Check if force enable internal ZeroMQ.
AC_ARG_ENABLE(internal-zmq,
  AC_HELP_STRING([--enable-internal-zmq], [Enable internal ZeroMQ, default no.]),
  [ENABLE_INTERNAL_ZMQ="yes"], [ENABLE_INTERNAL_ZMQ="no"])

dnl Check system ZMQ with pkg-config
GET_PKG_CONFIG="no"
GET_SYSTEM_ZMQ="no"
m4_include([src/pkg.m4])
PKG_PROG_PKG_CONFIG([0.25])
if test "X$PKG_CONFIG" != "X" ; then
  GET_PKG_CONFIG="yes"
  PKG_CHECK_MODULES([zmq], [libzmq >= 4.0.4],
                    GET_SYSTEM_ZMQ="yes", GET_SYSTEM_ZMQ="no")
fi

dnl Find system ZMQ header and share library.
SYSTEM_ZMQ_INCLUDEDIR=""
SYSTEM_ZMQ_LIBDIR=""
if test "X$GET_PKG_CONFIG" = "Xyes" -a "X$GET_SYSTEM_ZMQ" = "Xyes" -a "X$ENABLE_INTERNAL_ZMQ" = "Xno" ; then
  SYSTEM_ZMQ_INCLUDEDIR=`$PKG_CONFIG --variable=includedir libzmq`
  SYSTEM_ZMQ_LIBDIR=`$PKG_CONFIG --variable=libdir libzmq`
fi

dnl Check internal ZMQ (default).
INTERNAL_ZMQ_INCLUDEDIR="./zmqsrc/include"
INTERNAL_ZMQ_LIBDIR="./"

dnl Check external ZMQ.
AC_ARG_VAR(ZMQ_INCLUDE, [], [ "-I/path_to_zmq_include/" ])
AS_VAR_SET_IF(ZMQ_INCLUDE, [], [ AS_VAR_SET(ZMQ_INCLUDE, "") ])
EXTERNAL_ZMQ_INCLUDE="${ZMQ_INCLUDE}"
AC_ARG_VAR(ZMQ_LDFLAGS, [], [ "-L/path_to_zmq_lib/ -lzmq" ])
AS_VAR_SET_IF(ZMQ_LDFLAGS, [], [ AS_VAR_SET(ZMQ_LDFLAGS, "") ])
EXTERNAL_ZMQ_LDFLAGS="${ZMQ_LDFLAGS}"

dnl I decide to the order: system, internal, external.
dnl However, I need to test the order in backward.
ZMQ_INCLUDE=""
ZMQ_LDFLAGS=""
if test "X$EXTERNAL_ZMQ_INCLUDE" != "X" -a "X$EXTERNAL_ZMQ_LDFLAGS" != "X" ; then
  ZMQ_INCLUDE="${EXTERNAL_ZMQ_INCLUDE}"
  ZMQ_LDFLAGS="${EXTERNAL_ZMQ_LDFLAGS}"
else
  if test "X$ENABLE_INTERNAL_ZMQ" = "Xyes" ; then
    ZMQ_INCLUDE="-I${INTERNAL_ZMQ_INCLUDEDIR}"
    ZMQ_LDFLAGS="-L${INTERNAL_ZMQ_LIBDIR} -lzmq"
  else
    if test "X$SYSTEM_ZMQ_INCLUDEDIR" != "X" -a "X$SYSTEM_ZMQ_LIBDIR" != "X" ; then
      ZMQ_INCLUDE="-I${SYSTEM_ZMQ_INCLUDEDIR}"
      ZMQ_LDFLAGS="-L${SYSTEM_ZMQ_LIBDIR} -lzmq"
    else
      ZMQ_INCLUDE="-I${INTERNAL_ZMQ_INCLUDEDIR}"
      ZMQ_LDFLAGS="-L${INTERNAL_ZMQ_LIBDIR} -lzmq"
    fi
  fi
fi

dnl Set EXT_LIBS if external ZeroMQ library is provided.
if test "$ZMQ_INCLUDE" != "-I./zmqsrc/include" -a "$ZMQ_LDFLAGS" != "-L./ -lzmq" ; then
  EXT_LIBS=""
else
  EXT_LIBS="\$(R_ZMQ)"
fi

dnl Set ZMQ pollig system.
AC_ARG_VAR(ZMQ_POLLER, [select],
  [ polling system: autodetect, kqueue, epoll, devpoll, poll, or select ])
AS_VAR_SET_IF(ZMQ_POLLER, [], [ AS_VAR_SET(ZMQ_POLLER, "") ])
if test "X$ZMQ_POLLER" = "X" ; then
  ZMQ_POLLER="select"
fi

dnl Report
echo " "
echo "****************** Results of pbdZMQ package configure *****************"
echo " "
echo ">> GET_PKG_CONFIG = ${GET_PKG_CONFIG}"
echo ">> GET_SYSTEM_ZMQ = ${GET_SYSTEM_ZMQ}"
echo ">> PKG_CONFIG = ${PKG_CONFIG}"
echo ">> SYSTEM_ZMQ_INCLUDEDIR = ${SYSTEM_ZMQ_INCLUDEDIR}"
echo ">> SYSTEM_ZMQ_LIBDIR = ${SYSTEM_ZMQ_LIBDIR}"
echo ">> ENABLE_INTERNAL_ZMQ = ${ENABLE_INTERNAL_ZMQ}"
echo ">> INTERNAL_ZMQ_INCLUDEDIR = ${INTERNAL_ZMQ_INCLUDEDIR}"
echo ">> INTERNAL_ZMQ_LIBDIR = ${INTERNAL_ZMQ_LIBDIR}"
echo ">> EXTERNAL_ZMQ_INCLUDE = ${EXTERNAL_ZMQ_INCLUDE}"
echo ">> EXTERNAL_ZMQ_LDFLAGS = ${EXTERNAL_ZMQ_LDFLAGS}"
echo ">> ZMQ_INCLUDE = ${ZMQ_INCLUDE}"
echo ">> ZMQ_LDFLAGS = ${ZMQ_LDFLAGS}"
echo ">> EXT_LIBS = ${EXT_LIBS}"
echo ">> ZMQ_POLLER = ${ZMQ_POLLER}"
echo " "
echo "************************************************************************"
echo " "

dnl Start to substitute templates
AC_SUBST(GET_PKG_CONFIG)
AC_SUBST(GET_SYSTEM_ZMQ)
AC_SUBST(PKG_CONFIG)
AC_SUBST(SYSTEM_ZMQ_INCLUDEDIR)
AC_SUBST(SYSTEM_ZMQ_LIBDIR)
AC_SUBST(ENABLE_INTERNAL_ZMQ)
AC_SUBST(INTERNAL_ZMQ_INCLUDEDIR)
AC_SUBST(INTERNAL_ZMQ_LIBDIR)
AC_SUBST(EXTERNAL_ZMQ_INCLUDE)
AC_SUBST(EXTERNAL_ZMQ_LDFLAGS)
AC_SUBST(ZMQ_INCLUDE)
AC_SUBST(ZMQ_LDFLAGS)
AC_SUBST(EXT_LIBS)
AC_SUBST(ZMQ_POLLER)
AC_OUTPUT(src/Makevars)
AC_OUTPUT(src/build_zmq)
AC_OUTPUT(R/zzz.r)
