#!/bin/bash

set -e

# Set your own NDK here
NDK=~/Android/Sdk/ndk-bundle

#export NDK=`grep ndk.dir $PROPS | cut -d'=' -f2`

if [ "$NDK" = "" ] || [ ! -d $NDK ]; then
    echo "NDK variable not set or path to NDK is invalid, exiting..."
    exit 1
fi

export TARGET=$1

ARM_PLATFORM=$NDK/platforms/android-9/arch-arm/
ARM_PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64

ARM64_PLATFORM=$NDK/platforms/android-21/arch-arm64/
ARM64_PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

X86_PLATFORM=$NDK/platforms/android-9/arch-x86/
X86_PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64

X86_64_PLATFORM=$NDK/platforms/android-21/arch-x86_64/
X86_64_PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/linux-x86_64

MIPS_PLATFORM=$NDK/platforms/android-9/arch-mips/
MIPS_PREBUILT=$NDK/toolchains/mipsel-linux-android-4.9/prebuilt/linux-x86_64

BUILD_DIR=`pwd`/libs
OPENSSL_BUILD_DIR=${BUILD_DIR}/lib
OPENSSL_SRC_DIR=`pwd`/src/openssl-android

FFMPEG_VERSION="3.3"
#FFMPEG_VERSION="3.0.1"

if [ ! -e "ffmpeg-${FFMPEG_VERSION}.tar.bz2" ]; then
    echo "Downloading ffmpeg-${FFMPEG_VERSION}.tar.bz2"
    curl -LO http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2
else
    echo "Using ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi

tar -xvf ffmpeg-${FFMPEG_VERSION}.tar.bz2

for i in `find diffs -type f`; do
    (cd ffmpeg-${FFMPEG_VERSION} && patch -p1 < ../$i)
done

######################################################
############### START die ############################
######################################################

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

######################################################
############### START die ############################
######################################################

######################################################
############### START build_one ######################
######################################################

function build_one
{
if [ $ARCH == "arm" ]
then
    PLATFORM=$ARM_PLATFORM
    PREBUILT=$ARM_PREBUILT
    HOST=arm-linux-androideabi
#added by alexvas
elif [ $ARCH == "arm64" ]
then
    PLATFORM=$ARM64_PLATFORM
    PREBUILT=$ARM64_PREBUILT
    HOST=aarch64-linux-android
elif [ $ARCH == "mips" ]
then
    PLATFORM=$MIPS_PLATFORM
    PREBUILT=$MIPS_PREBUILT
    HOST=mipsel-linux-android
#alexvas
elif [ $ARCH == "x86_64" ]
then
    PLATFORM=$X86_64_PLATFORM
    PREBUILT=$X86_64_PREBUILT
    HOST=x86_64-linux-android
else
    PLATFORM=$X86_PLATFORM
    PREBUILT=$X86_PREBUILT
    HOST=i686-linux-android
fi

top_root=$(pwd)
patch_root=${top_root}/patches
configuration_log=${top_root}/configuration.log

# patch the configure script to use an Android-friendly versioning scheme
patch -u configure ${patch_root}/ffmpeg-configure.patch || die "Couldn't patch ffmpeg configure script!"

export PKG_CONFIG_PATH="${OPENSSL_SRC_DIR}"
echo "pkg-config path = ${PKG_CONFIG_PATH}"

openssl_addi_ldflags=""

#    --prefix=$PREFIX \

#--incdir=$BUILD_DIR/include \
#--libdir=$BUILD_DIR/lib/$CPU \

#    --extra-cflags="-fvisibility=hidden -fdata-sections -ffunction-sections -Os -fPIC -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
#    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \

# TODO Adding aac decoder brings "libnative.so has text relocations. This is wasting memory and prevents security hardening. Please fix." message in Android.
pushd ffmpeg-$FFMPEG_VERSION
./configure \
    --target-os=linux \
    --incdir=$BUILD_DIR/include/$TARGET \
    --libdir=$BUILD_DIR/lib/$TARGET \
    --enable-cross-compile \
    --extra-libs="-lgcc" \
    --arch=$ARCH \
    --cc=$PREBUILT/bin/$HOST-gcc \
    --cross-prefix=$PREBUILT/bin/$HOST- \
    --nm=$PREBUILT/bin/$HOST-nm \
    --sysroot=$PLATFORM \
    --extra-cflags="$OPTIMIZE_CFLAGS " \
    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog -L${OPENSSL_BUILD_DIR}/${ABI}  ${openssl_addi_ldflags}" \
    --disable-static \
    --disable-ffplay \
    --disable-ffmpeg \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-doc \
    --disable-postproc \
    --disable-gpl \
    --disable-encoders \
    --disable-muxers \
    --disable-bsfs \
    --disable-protocols \
    --disable-indevs \
    --disable-outdevs \
    --disable-devices \
    --enable-shared \
    --enable-small \
    --enable-openssl \
    --enable-encoder=png \
    --enable-protocol=file,ftp,http,https,httpproxy,hls,mmsh,mmst,pipe,rtmp,rtmps,rtmpt,rtmpts,rtp,sctp,srtp,tcp,udp \
    --pkg-config=$(which pkg-config) \
    $ADDITIONAL_CONFIGURE_FLAG >> ${configuration_log} 2>&1 || die "Couldn't configure ffmpeg!"

make clean
make -j8 install V=1
$PREBUILT/bin/$HOST-ar d libavcodec/libavcodec.a inverse.o
#$PREBUILT/bin/$HOST-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -shared -nostdlib  -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/$HOST/4.6/libgcc.a
popd

# copy the binaries
mkdir -p $PREFIX
cp -r $BUILD_DIR/$TARGET/* $PREFIX
}

######################################################
############### END build_one ########################
######################################################

if [ $TARGET == 'arm-v5te' ]; then
    #arm v5te
    ABI=armeabi
    CPU=armv5te
    ARCH=arm
    OPTIMIZE_CFLAGS="-marm -march=$CPU"
    PREFIX=$BUILD_DIR/$CPU
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'arm-v6' ]; then
    #arm v6
    ABI=armeabi
    CPU=armv6
    ARCH=arm
    OPTIMIZE_CFLAGS="-marm -march=$CPU"
    PREFIX=`pwd`/ffmpeg-android/$CPU
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'arm-v7vfpv3' ]; then
    #arm v7vfpv3
    ABI=armeabi-v7a
    CPU=armv7-a
    ARCH=arm
    OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
    PREFIX=$BUILD_DIR/$CPU
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'arm-v7vfp' ]; then
    #arm v7vfp
    ABI=armeabi-v7a
    CPU=armv7-a
    ARCH=arm
    OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
    PREFIX=`pwd`/ffmpeg-android/$CPU-vfp
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'arm-v7n' ]; then
    #arm v7n
    ABI=armeabi-v7a
    CPU=armv7-a
    ARCH=arm
    OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
    PREFIX=`pwd`/ffmpeg-android/$CPU
    ADDITIONAL_CONFIGURE_FLAG=--enable-neon
    build_one
fi

if [ $TARGET == 'arm-v6+vfp' ]; then
    #arm v6+vfp
    ABI=armeabi
    CPU=armv6
    ARCH=arm
    OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
    PREFIX=`pwd`/ffmpeg-android/${CPU}_vfp
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'arm64-v8a' ]; then
    #arm64-v8a
    ABI=arm64-v8a
    CPU=arm64-v8a
    ARCH=arm64
    OPTIMIZE_CFLAGS=
    PREFIX=$BUILD_DIR/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/arm64-v8a
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'x86_64' ]; then
    #x86_64
    ABI=x86_64
    CPU=x86_64
    ARCH=x86_64
    OPTIMIZE_CFLAGS="-fomit-frame-pointer"
    #PREFIX=$BUILD_DIR/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/x86_64
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'i686' ]; then
    #x86
    ABI=x86
    CPU=i686
    ARCH=i686
    OPTIMIZE_CFLAGS="-fomit-frame-pointer"
    #PREFIX=$BUILD_DIR/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/x86
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'mips' ]; then
    #mips
    ABI=mips
    CPU=mips
    ARCH=mips
    OPTIMIZE_CFLAGS="-std=c99 -O3 -Wall -pipe -fpic -fasm \
-ftree-vectorize -ffunction-sections -funwind-tables -fomit-frame-pointer -funswitch-loops \
-finline-limit=300 -finline-functions -fpredictive-commoning -fgcse-after-reload -fipa-cp-clone \
-Wno-psabi -Wa,--noexecstack"
    #PREFIX=$BUILD_DIR/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/mips
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'armv7-a' ]; then
    #arm armv7-a
    ABI=armeabi-v7a
    CPU=armv7-a
    ARCH=arm
    OPTIMIZE_CFLAGS="-mfloat-abi=softfp -marm -march=$CPU "
    #PREFIX=`pwd`/ffmpeg-android/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/armeabi-v7a
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'arm' ]; then
    #arm arm
    ABI=armeabi
    CPU=arm
    ARCH=arm
    OPTIMIZE_CFLAGS=""
    #PREFIX=`pwd`/ffmpeg-android/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/armeabi
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi
