#!/bin/bash

# use extended globbing features
shopt -s extglob

#-- error function
function die {
  code=-1
  err="Unknown error!"
  test "$1" && err=$1
  cd ${top_root}
  echo "$err"
  echo "Check the build log: ${build_log}"
  exit -1
}

export NDK=/home/davinctor/Android/Sdk/ndk-bundle

# environment variables
top_root=$PWD
src_root=${top_root}/src
patch_root=${top_root}/patches
dist_root=${top_root}/libs/openssl
dist_bin_root=${dist_root}/bin
dist_include_root=${dist_root}/include
dist_lib_root=${dist_root}/lib
build_log=${top_root}/openssl_build.log

# create our folder structure
cd ${top_root}
test -d ${src_root} || mkdir -p ${src_root}
test -d ${dist_root} || mkdir -p ${dist_root}
test -d ${dist_bin_root} || mkdir -p ${dist_bin_root}
test -d ${dist_include_root} || mkdir -p ${dist_include_root}
test -d ${dist_lib_root} || mkdir -p ${dist_lib_root}
touch ${build_log}

rm -f ${build_log}

echo "Building openssl-android ..."

test -d ${src_root}/openssl-android || \
    git clone https://github.com/guardianproject/openssl-android.git ${src_root}/openssl-android >> ${build_log} 2>&1 || \
    die "Couldn't clone openssl-android repository!"
cd ${src_root}/openssl-android

${NDK}/ndk-build >> ${build_log} 2>&1 || die "Couldn't build openssl-android!"

# copy the versioned libraries
#cp -r ${src_root}/openssl-android/libs/armeabi/lib*.so --parents ${dist_lib_root}/.
rsync -a --include '*/' --include '*.so' --exclude '*' ${src_root}/openssl-android/libs/ ${dist_lib_root}/
# copy the executables
#cp -r ${src_root}/openssl-android/libs/armeabi/openssl ${dist_bin_root}/. # work only for one abi folder
rsync -a --include '*/openssl' --exclude '*.so' ${src_root}/openssl-android/libs/ ${dist_bin_root}/
#cp -r ${src_root}/openssl-android/libs/armeabi/ssltest ${dist_bin_root}/. # work only for one abi folder
rsync -a --include '*/ssltest' --exclude '*.so' ${src_root}/openssl-android/libs/ ${dist_bin_root}/
# copy the headers
cp -r ${src_root}/openssl-android/include/* ${dist_include_root}/.

cd ${top_root}

