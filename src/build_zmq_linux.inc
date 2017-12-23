### This file contains steps that pre-build ZeroMQ 4.2.2 source for linux.
### The pre-build ZeroMQ source is only for CRAN and tested under xubuntu.
###
### Wei-Chen Chen 12/21/2017

# rm -rf zeromq-4.2.2
tar zxvf zeromq-4.2.2.tar.gz
cd zeromq-4.2.2

### Disable all
sed -i "/doc\/Makefile/i \]\)" configure.ac
sed -i "689,691 s/^/# /" configure.ac
sed -i "s/SUBDIRS = .*/SUBDIRS = /" Makefile.in
sed -i "s/SUBDIRS = .*/SUBDIRS = /" Makefile.am

### Reconfigure
autoconf
sed -i "s/^am__api_version='1.14'/am__api_version='1.15'/" configure
rm -rf autom4te.cache
rm -rf AUTHORS ChangeLog CMakeLists.txt COPYING* foreign INSTALL
rm -rf MAINTAINERS NEWS perf tools tests FindSodium.cmake
rm -rf doc builds
rm -rf /home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/src/zmqsrc
cp -R ./ /home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/src/zmqsrc

### Test
./configure \
   --prefix=/home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/zmq \
   --enable-static=no \
   --enable-shared=yes \
   --without-docs \
   --without-documentation \
   --disable-pedantic \
   --disable-eventfd \
   --disable-perf \
   --disable-curve-keygen \
   --disable-curve
# make -j 4
# make install
# make distclean
# cd ../
