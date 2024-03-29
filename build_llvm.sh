#!/usr/bin/env bash
#主要地址修改此处本机设备的NDK路径
NDK_HOME=/Users/zhenio/Library/Android/sdk/ndk/21.3.6528147
#输出目录
PREFIX=android-build
HOST_PLATFORM=darwin-x86_64
#最低支持版本
PLATFORM=android-18
#64位支持版本
PLATFORM_64=android-21

#日志输出目录
CONFIG_LOG_PATH=${PREFIX}/log
COMMON_OPTIONS=
CONFIGURATION=

build(){
    APP_ABI=$1
    echo "======== > Start build $APP_ABI"
    case ${APP_ABI} in
    armeabi )
        ARCH="arm"
        CPU="armv6"
        MARCH="armv6"
        TOOLCHAINS="$NDK_HOME/toolchains/llvm/prebuilt/$HOST_PLATFORM"
        CROSS_PREFIX="$TOOLCHAINS/bin/arm-linux-androideabi-"
        SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-arm"
        EXTRA_CFLAGS="-march=$MARCH"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -mfloat-abi=softfp -mfpu=vfp"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/arm-linux-androideabi"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
        EXTRA_LDFLAGS="-lc -lm -ldl -llog"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib"
        EXTRA_OPTIONS="--disable-x86asm"
    ;;
    armeabi-v7a )
        ARCH="arm"
        CPU="armv7-a"
        MARCH="armv7-a"
         TOOLCHAINS="$NDK_HOME/toolchains/llvm/prebuilt/$HOST_PLATFORM"
        CROSS_PREFIX="$TOOLCHAINS/bin/arm-linux-androideabi-"
        SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-arm"
        EXTRA_CFLAGS="-march=$MARCH"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -mfloat-abi=softfp -mfpu=vfpv3-d16"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/arm-linux-androideabi"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
        EXTRA_LDFLAGS="-lc -lm -ldl -llog"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,--fix-cortex-a8"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib"
        EXTRA_OPTIONS="--enable-neon --disable-x86asm"
    ;;
    arm64-v8a )
        ARCH="aarch64"
        CPU="armv8-a"
        MARCH="armv8-a"
         TOOLCHAINS="$NDK_HOME/toolchains/llvm/prebuilt/$HOST_PLATFORM"
        CROSS_PREFIX="$TOOLCHAINS/bin/aarch64-linux-android-"
        SYSROOT="$NDK_HOME/platforms/$PLATFORM_64/arch-arm64"
        EXTRA_CFLAGS="-march=$MARCH"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/aarch64-linux-android"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
        EXTRA_LDFLAGS="-lc -lm -ldl -llog"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib"
        EXTRA_OPTIONS="--enable-neon --disable-x86asm"
    ;;
    x86 )
        ARCH="x86"
        CPU="i686"
        MARCH="i686"
        TOOLCHAINS="$NDK_HOME/toolchains/llvm/prebuilt/$HOST_PLATFORM"
        CROSS_PREFIX="$TOOLCHAINS/bin/i686-linux-android-"
        SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-x86"
        EXTRA_CFLAGS="-march=$MARCH"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -mtune=intel -mssse3 -mfpmath=sse -m32"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/i686-linux-android"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
        EXTRA_LDFLAGS="-lc -lm -ldl -llog"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib"
        EXTRA_OPTIONS="--disable-asm"
    ;;
    x86_64 )
        ARCH="x86_64"
        CPU="x86_64"
        MARCH="x86-64"
          TOOLCHAINS="$NDK_HOME/toolchains/llvm/prebuilt/$HOST_PLATFORM"
        CROSS_PREFIX="$TOOLCHAINS/bin/x86_64-linux-android-"
        SYSROOT="$NDK_HOME/platforms/$PLATFORM_64/arch-x86_64"
        EXTRA_CFLAGS="-march=$MARCH"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -mtune=intel -msse4.2 -mpopcnt -m64"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_HOME/sysroot/usr/include/x86_64-linux-android"
        EXTRA_CFLAGS="$EXTRA_CFLAGS -isysroot $NDK_HOME/sysroot"
        EXTRA_LDFLAGS="-lc -lm -ldl -llog"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,-rpath-link=$SYSROOT/usr/lib64 -L$SYSROOT/usr/lib64"
        EXTRA_OPTIONS="--disable-asm"
    ;;
    esac

    echo "-------- > Start clean workspace"
    make clean

    echo "-------- > Start build configuration"
    CONFIGURATION="$COMMON_OPTIONS"
    CONFIGURATION="$CONFIGURATION --logfile=$CONFIG_LOG_PATH/config_$APP_ABI.log"
    CONFIGURATION="$CONFIGURATION --prefix=$PREFIX"
    CONFIGURATION="$CONFIGURATION --libdir=$PREFIX/libs/$APP_ABI"
    CONFIGURATION="$CONFIGURATION --incdir=$PREFIX/includes/$APP_ABI"
    CONFIGURATION="$CONFIGURATION --pkgconfigdir=$PREFIX/pkgconfig/$APP_ABI"
    CONFIGURATION="$CONFIGURATION --arch=$ARCH"
    CONFIGURATION="$CONFIGURATION --cpu=$CPU"
    CONFIGURATION="$CONFIGURATION --cross-prefix=$CROSS_PREFIX"
    CONFIGURATION="$CONFIGURATION --sysroot=$SYSROOT"
    CONFIGURATION="$CONFIGURATION --extra-ldexeflags=-pie"
    CONFIGURATION="$CONFIGURATION $EXTRA_OPTIONS"

    echo "-------- > Start config makefile with $CONFIGURATION --extra-cflags="${EXTRA_CFLAGS}" --extra-ldflags="${EXTRA_LDFLAGS}""
    ./configure ${CONFIGURATION} \
        --extra-cflags="$EXTRA_CFLAGS" \
        --extra-ldflags="$EXTRA_LDFLAGS" 

    echo "-------- > Start make $APP_ABI with -j8"
    make -j8

    echo "-------- > Start install $APP_ABI"
    make install
    echo "++++++++ > make and install $APP_ABI complete."

}

build_all(){

    COMMON_OPTIONS="$COMMON_OPTIONS --target-os=android"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-static"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-shared"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-protocols"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-cross-compile"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-openssl"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-runtime-cpudetect"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-optimizations"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-debug"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-small"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-doc"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-programs"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffmpeg"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffplay"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffprobe"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-symver"
    COMMON_OPTIONS="$COMMON_OPTIONS --disable-network"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-pthreads"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-mediacodec"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-jni"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-zlib"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-pic"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-avresample"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=h264"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=mpeg4"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=mjpeg"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=png"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=vorbis"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=opus"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=flac"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-postproc"
    COMMON_OPTIONS="$COMMON_OPTIONS --enable-gpl"

    echo "COMMON_OPTIONS=$COMMON_OPTIONS"
    echo "PREFIX=$PREFIX"
    echo "CONFIG_LOG_PATH=$CONFIG_LOG_PATH"

    mkdir -p ${CONFIG_LOG_PATH}

    #  build $app_abi
     build "armeabi"
     build "armeabi-v7a"
     build "arm64-v8a"
     build "x86"
     build "x86_64"
}

echo "-------- Start --------"

build_all
echo "-------- End --------"
