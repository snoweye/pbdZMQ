### This file contains steps that pre-build ZeroMQ 4.2.2 rc1 source for windows.
### The pre-build ZeroMQ source is only for CRAN and tested under Rtools31.
###
### Wei-Chen Chen 12/22/2017

### Install R-devel
### Install Rtool34 which should have Rtools\mingw_32 and Rtools\mingw_64
# SET RHOME=C:\Program Files\R\R-devel
# SET RTOOLS=C:\Rtools\bin\
# IF NOT DEFINED PATH_ORG SET PATH_ORG=%PATH%
# SET PATH=%RHOME%;%RTOOLS%;%PATH_ORG%

### tar and gzip are available from Rtools34.
tar zxvf zeromq-4.2.2.tar.gz

### Copy to pbdZMQ
rm -rf C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.mingw*
mkdir C:\Users\snoweye\Desktop\DESKTOP-MY\R_Packages\13_pbdZMQ\pbdZMQ\src\zmqsrc.mingw
cp -Rf zeromq-4.2.2/builds/mingw32 C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.win
cd C:/Users/snoweye/Desktop/DESKTOP-MY/R_Packages/13_pbdZMQ/pbdZMQ/src/zmqsrc.win
mv Makefile.mingw32 Makefile

### Change Makefile
sed -i "1 s/^/include ..\/Makeconf\n\n/" Makefile
sed -i "s/CC=gcc/CC=\$(MY_CC)/" Makefile
sed -i "s/ -g / /" Makefile
sed -i "s/ -lsodium/ # -lsodium/" Makefile
sed -i "s/%.o: ..\/..\//%.o: ..\/zmqsrc\//" Makefile
sed -i "s/g++ -shared -static /\$(MY_CXX) -shared /" Makefile
sed -i "s/ -Wl,--out-implib,\$@.a / /" Makefile

### Change platform.hpp
sed -i "s/#define ZMQ_USE_LIBSODIUM/\/\/ #define ZMQ_USE_LIBSODIUM/" platform.hpp
