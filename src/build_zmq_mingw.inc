### This file contains steps that pre-build ZeroMQ 4.1.0 rc1 source for windows.
### The pre-build ZeroMQ source is only for CRAN and tested under Rtools31.
###
### Wei-Chen Chen 02/07/2015

### Install DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe to c:/devkit-mingw32
### Install DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe to c:/devkit-mingw64

### Change 32 to 64 accordingly if x64 version is expected.

### In "set_devkit_mingw32.bat", set next.
# SET DEVKIT=C:\devkit_mingw32\bin\
# SET MINGW=C:\devkit_mingw32\mingw\bin\
# IF NOT DEFINED PATH_ORG SET PATH_ORG=%PATH%
# SET PATH=%DEVKIT%;%MINGW%;%PATH_ORG%
### In "set_devkit_mingw64.bat", set next.
# SET DEVKIT=C:\devkit_mingw64\bin\
# SET MINGW=C:\devkit_mingw64\mingw\bin\
# IF NOT DEFINED PATH_ORG SET PATH_ORG=%PATH%
# SET PATH=%DEVKIT%;%MINGW%;%PATH_ORG%

### tar and gzip are available from Rtools31.
tar zxvf zeromq-4.1.0.tar.gz

### Copy to pbdZMQ
rm -rf C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.mingw
mkdir C:\Users\snoweye\Desktop\DESKTOP-MY\R_Packages\13_pbdZMQ\pbdZMQ\src\zmqsrc.mingw
cp -Rf zeromq-4.1.0/include C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.mingw
cp -Rf zeromq-4.1.0/src C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.mingw

### Configure
cd zeromq-4.1.0
sh configure --prefix=c:/zmq --with-poller=select --without-documentation

### Change -m32 to -m64 accordingly if x64 version is expected.
sed -i "s/ = gcc/ = gcc -m32/" src/Makefile
sed -i "s/ = g++/ = g++ -m32/" src/Makefile
# sed -i "s/ = gcc/ = gcc -m64/" src/Makefile
# sed -i "s/ = g++/ = g++ -m64/" src/Makefile

### Copy pre-built configure and make information
rm -rf C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.win
mkdir C:\Users\snoweye\Desktop\DESKTOP-MY\R_Packages\13_pbdZMQ\pbdZMQ\src\zmqsrc.win
cp include/zmq.h C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.win/include_zmq.h
cp src/Makefile C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.win/src_Makefile
cp src/platform.hpp C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.win/src_platform.hpp
cp -R src/.deps C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.win/src_deps

### Change directory to pbdZMQ
cd C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/
cd zmqsrc.win

### Replace zmq.h
sed -i "s/define ZMQ_EXPORT __declspec.*/define ZMQ_EXPORT/" include_zmq.h

### Replace src/Makefile
sed -i "s#c:/zmq#./#" src_Makefile
sed -i "s#/c/Users/snoweye/Desktop/zeromq-4.1.0#.#" src_Makefile
sed -i "s/^LD = .*/LD = ld.exe/" src_Makefile
sed -i "s/^Makefile: /Makefile_org: /" src_Makefile
sed -i "/^Makefile_org: /i Makefile: " src_Makefile
sed -i "s/^platform.hpp: /platform.hpp_org: /" src_Makefile
sed -i "/^platform.hpp_org: /i platform.hpp: " src_Makefile
sed -i "s/^libzmq.pc: /libzmq.pc_org: /" src_Makefile
sed -i "/^libzmq.pc_org: /i libzmq.pc: " src_Makefile

### LIBTOOL
sed -i "s/^\t$(AM_V_CXX)$(LIBTOOL) $(AM_V_lt) --tag=CXX $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=compile /\t/" src_Makefile

### Change shared to static
sed -i "s/^libzmq.la: /libzmq.la_org: /" src_Makefile
sed -i "/^libzmq.la_org: /i libzmq.la: $(libzmq_la_OBJECTS) $(libzmq_la_DEPENDENCIES) $(EXTRA_libzmq_la_DEPENDENCIES)" src_Makefile

sed -i "s/^libzmq.la: /libzmq.la_static: /" src_Makefile
sed -i "/^libzmq.la_static: /a \\\t$(AR) crs ..\/..\/libzmq.a $(libzmq_la_OBJECTS) $(libzmq_la_LIBADD)" src_Makefile

sed -i "/^libzmq.la: /a \\\t$(CXXLD) $(libzmq_la_CXXFLAGS) \\\\\n\\t  $(CXXFLAGS) -shared $(LDFLAGS) -o ..\/..\/libzmq.dll \\\\\n\\t  $(libzmq_la_OBJECTS) $(libzmq_la_LIBADD) \\\\\n\\t  $(PKG_LIBS_ZMQ)" src_Makefile
sed -i "/^libzmq.la: /i include ..\/..\/Makeconf" src_Makefile

### Rename to win32 or win64
cd ../
mv zmqsrc.win zmqsrc.win32
# mv zmqsrc.win zmqsrc.win64

### zmqsrc.mingw will be replaced later by zmqsrc pre-built under linux.

