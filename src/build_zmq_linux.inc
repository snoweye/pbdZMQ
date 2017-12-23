### This file contains steps that pre-build ZeroMQ 4.2.2 source for linux.
### The pre-build ZeroMQ source is only for CRAN and tested under xubuntu.
###
### Wei-Chen Chen 12/23/2017

rm -rf zeromq-4.2.2
tar zxvf zeromq-4.2.2.tar.gz
cd zeromq-4.2.2

### Remove
rm -rf AUTHORS ChangeLog CMakeLists.txt COPYING* foreign INSTALL
rm -rf MAINTAINERS NEWS perf tools tests FindSodium.cmake
rm -rf doc builds
cp ../zzz.cpp ./src

### Disable all
sed -i "/doc\/Makefile/i \]\)" configure.ac
sed -i "689,691 s/^/# /" configure.ac
sed -i "s/SUBDIRS = .*/SUBDIRS = /" Makefile.am
sed -i "/src\/zmq_draft.h/ s/$/ \\\/" Makefile.am
sed -i "/src\/zmq_draft.h/ s/$/\n\tsrc\/zzz.cpp/" Makefile.am
sed -i "s/config\/lt\~obsolete.m4/config\/lt_obsolete.m4/" aclocal.m4
mv ./config/lt~obsolete.m4 ./config/lt_obsolete.m4

### Reconfigure
aclocal
autoconf
automake
rm -rf autom4te.cache
rm -rf /home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/src/zmqsrc
cp -R ./ /home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/src/zmqsrc

### Test
./configure \
   --prefix=/home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/src/zmq \
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
