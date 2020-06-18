FFmpeg README
=============

FFmpeg is a collection of libraries and tools to process multimedia content
such as audio, video, subtitles and related metadata.

## Libraries

* `libavcodec` provides implementation of a wider range of codecs.
* `libavformat` implements streaming protocols, container formats and basic I/O access.
* `libavutil` includes hashers, decompressors and miscellaneous utility functions.
* `libavfilter` provides a mean to alter decoded Audio and Video through chain of filters.
* `libavdevice` provides an abstraction to access capture and playback devices.
* `libswresample` implements audio mixing and resampling routines.
* `libswscale` implements color conversion and scaling routines.

## Tools

* [ffmpeg](https://ffmpeg.org/ffmpeg.html) is a command line toolbox to
  manipulate, convert and stream multimedia content.
* [ffplay](https://ffmpeg.org/ffplay.html) is a minimalistic multimedia player.
* [ffprobe](https://ffmpeg.org/ffprobe.html) is a simple analysis tool to inspect
  multimedia content.
* Additional small tools such as `aviocat`, `ismindex` and `qt-faststart`.

## Documentation

The offline documentation is available in the **doc/** directory.

The online documentation is available in the main [website](https://ffmpeg.org)
and in the [wiki](https://trac.ffmpeg.org).

### Examples

Coding examples are available in the **doc/examples** directory.

## License

FFmpeg codebase is mainly LGPL-licensed with optional components licensed under
GPL. Please refer to the LICENSE file for detailed information.

## Contributing

Patches should be submitted to the ffmpeg-devel mailing list using
`git format-patch` or `git send-email`. Github pull requests should be
avoided because they are not part of our review process and will be ignored.


# Android-ffmpeg
### 1.开始编译之前：
```
./configure --disable-x86asm
```
> 用于生成配置文件：ffbuild目录下的文件
```
arch.mak
comon.mak
config.fate
config.log
config.mak
config.sh
library.mak
等文件
```
#### 2.开始编译之前还需要安装安装yasm （汇编编译器）和 nasm
[yasm前往下载](http://www.tortall.net/)
> yasm
```
1、运行
./configure
//configure脚本会寻找最合适的C编译器，并生成相应的makefile文件
2、编译文件
make
3、安装软件
sudo make install
```
[nasm前往下载](https://www.nasm.us/)
> 安装方法同上
----- 
### 3.编译脚本:android_build.sh::不要着急开始执行---往下看



```
#!/usr/bin/env bash
#主要地址修改此处本机设备的NDK路径
NDK_HOME=/Users/zhenio/locks/android-ndk-r20
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
        TOOLCHAINS="$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/$HOST_PLATFORM"
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
        TOOLCHAINS="$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/$HOST_PLATFORM"
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
        TOOLCHAINS="$NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/$HOST_PLATFORM"
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
        TOOLCHAINS="$NDK_HOME/toolchains/x86-4.9/prebuilt/$HOST_PLATFORM"
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
        TOOLCHAINS="$NDK_HOME/toolchains/x86_64-4.9/prebuilt/$HOST_PLATFORM"
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
```


#### 需要修改configure文件：
>将如下内容注释掉：否则是无法生成so问题--具体什么原因，咱也不知道。总之注释掉就对了

``` 
# set_default target_os
# if test "$target_os" = android; then
#     cc_default="clang"
# fi
```
#### 修改输出类型:
> 修改如下：
```
# 注释
# SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'
# LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"'
# SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'
# SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)'

SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'
LIB_INSTALL_EXTRA_CMD='$$(RANLIB)"$(LIBDIR)/$(LIBNAME)"'
SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'
SLIB_INSTALL_LINKS='$(SLIBNAME)'

```
## 为编译脚本添加可执行权限：
 
```
chmod 777 build_android.sh
```
> 功能定制：自行修改build_all处的参数：
```
查看所有编译配置选项：./configure --help
查看支持的解码器：./configure --list-decoders
查看支持的编码器：./configure --list-encoders
查看支持的硬件加速：./configure --list-hwaccels
```



### 完成以上操作就可以开始执行编译脚本了

```
 sudo ./build_android.sh
 注意：这里推荐使用sudo执行
```
等待最终结束so文件输出即可。。。

# 当前库所在目录为：android-build文件目录下libs对应CPU架构目录下



