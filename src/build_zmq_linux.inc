### This file contains steps that pre-build ZeroMQ 4.1.0 rc1 source for linux.
### The pre-build ZeroMQ source is only for CRAN and tested under xubuntu.
###
### Wei-Chen Chen 02/07/2015

# rm -rf zeromq-4.1.0
tar zxvf zeromq-4.1.0-rc1.tar.gz
cd zeromq-4.1.0
mv config/lt_obsolete.m4 config/lt_obsolete.m4
grep -rl "lt_obsolete" * | xargs sed -i "s/lt_obsolete/lt_obsolete/g"

# Disable all
sed -i "/doc\/Makefile/i \]\)" configure.ac
sed -i "569,575 s/^/# /" configure.ac
sed -i "s/SUBDIRS = .*/SUBDIRS = src/" Makefile.in

# Reconfigure
autoconf
rm -rf autom4te.cache
rm -rf AUTHORS builds ChangeLog CMakeLists.txt COPYING* foreign doc INSTALL \
       MAINTAINERS NEWS perf tools tests
rm -rf /home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/src/zmqsrc
cp -R zeromq-4.1.0 /home/snoweye/work-my/tmp_pbd/pbdZMQ/pbdZMQ/src/zmqsrc

# Test
# ./configure \
#    --prefix=/home/snoweye/work-my/tmp_pbd/pbdZMQ/zmq \
#    --enable-static=yes \
#    --enable-shared=no \
#    --without-documentation
# make -j 4
# make install
# make distclean
# cd ../
