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

dnl Set ZMQ include.
AC_ARG_VAR(ZMQ_INCLUDE, [], [ "-I/path_to_zmq_include/" ])
AS_VAR_SET_IF(ZMQ_INCLUDE, [], [ AS_VAR_SET(ZMQ_INCLUDE, "") ])
if test "X$ZMQ_INCLUDE" = "X" ; then
  ZMQ_INCLUDE="-I./zmqsrc/include"
fi

dnl Set ZMQ LDFLAGS.
AC_ARG_VAR(ZMQ_LDFLAGS, [], [ "-L/path_to_zmq_lib/ -lzmq" ])
AS_VAR_SET_IF(ZMQ_LDFLAGS, [], [ AS_VAR_SET(ZMQ_LDFLAGS, "") ])
if test "X$ZMQ_LDFLAGS" = "X" ; then
  ZMQ_LDFLAGS="-L./ -lzmq"
fi

dnl Set EXT_LIBS if external ZeroMQ library is provided.
if test "$ZMQ_INCLUDE" != "-I./zmqsrc/include" -a "$ZMQ_LDFLAGS" != "-L./ -lzmq" ; then
  EXT_LIBS=""
else
  EXT_LIBS="\$(R_ZMQ)"
fi

dnl Set ZMQ pollig system.
AC_ARG_VAR(ZMQ_POLLER, [select], [ polling system: autodetect, kqueue, epoll, devpoll, poll, or select ])
AS_VAR_SET_IF(ZMQ_POLLER, [], [ AS_VAR_SET(ZMQ_POLLER, "") ])
if test "X$ZMQ_POLLER" = "X" ; then
  ZMQ_POLLER="select"
fi

dnl Report
echo " "
echo "****************** Results of pbdZMQ package configure *****************"
echo " "
echo ">> ZMQ_INCLUDE = ${ZMQ_INCLUDE}"
echo ">> ZMQ_LDFLAGS = ${ZMQ_LDFLAGS}"
echo ">> ZMQ_POLLER = ${ZMQ_POLLER}"
echo ">> EXT_LIBS = ${EXT_LIBS}"
echo " "
echo "************************************************************************"
echo " "

dnl Start to substitute templates
AC_SUBST(ZMQ_INCLUDE)
AC_SUBST(ZMQ_LDFLAGS)
AC_SUBST(ZMQ_POLLER)
AC_SUBST(EXT_LIBS)
AC_OUTPUT(src/Makevars)
AC_OUTPUT(src/build_zmq)
AC_OUTPUT(R/zzz.r)
