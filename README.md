# About
A bunch of script you can use to compile FFmpeg with OpenSSL

# Environment
1. Linux (At that time I used Linux Mint 18.1 Serena MATE 64-bit)
2. Android NDK r14b
3. Internet

# How to run it
1. Copy the repository
2. cd into it
3. Call in console `./build.sh`
4. Wait for a while
5. Congratulations!

# Output folder structure
```
~/AndroidStudioProjects/compile-ffmpeg-and-openssl/
	→ build.sh (the main compilation script for both FFmpeg and OpenSSL)
	→ _build_ffmpeg.sh (FFmpeg compilation script)
	→ _build_openssl.sh (OpenSSL compilation script)
	→ _old_build_ffmpeg.sh (FFmpeg compilation script for only armeabi architecture)
	→ _old_build_openssl.sh (OpenSSL 1.0.0a compilation script)
	→ Setenv-android.sh (set up environment (variables, etc) for OpenSSL compilation, runs inside _build_openssl.sh)
	→ patches
		→ patch_fix_ffmpeg_lib_name.txt (the patch file to fix FFmpeg libs name suffix)
	→ src
		→ ffmpeg-android (FFmpeg sources)
		→ openssl-android (OpenSSL sources)
		→ ffmpeg-3.3tar.bz2
		→ openssl-1.0.2j.tar.gz
	→ libs (folder with compiled libs)
		→ ffmpeg
			→ include
				→ armeabi-v7a
					→ libavcodec
					→ libavdevice
					→ libavfilter
					→ libavformat
					→ libavutil
					→ libswresample
					→ libswscale
				→ x86
					→ (Like inside armeabi-v7a folder)
				→ armeabi
					→ (Like inside armeabi-v7a folder)
				→ arm64-v8a
					→ (Like inside armeabi-v7a folder)
			→ binaries
				→ armeabi-v7a
					→  libavcodec-57.so
					→  libavcodec.so -> libavcodec-57.so
					→  libavdevice-57.so
					→  libavdevice.so -> libavdevice-57.so
					→  libavfilter-6.so
					→ libavfilter.so -> libavfilter-6.so
					→ libavformat-57.so
					→ libavformat.so -> libavformat-57.so
					→ libavutil-55.so
					→ libavutil.so -> libavutil-55.so
				→ x86
					→ (Like inside armeabi-v7a folder)
				→ armeabi
					→ (Like inside armeabi-v7a folder)
				→ arm64-v8a
					→ (Like inside armeabi-v7a folder)
			→ lib
				→ libavcodec
					→ armeabi-v7a 
						→  libavcodec-57.so
						→  libavcodec.so -> libavcodec-57.so
					→ x86
						→ (Like inside armeabi-v7a folder)
					→ armeabi
						→ (Like inside armeabi-v7a folder)
					→ arm64-v8a
						→ (Like inside armeabi-v7a folder)
				→ libavdevice
					→ armeabi-v7a 
						→  libavdevice-57.so
						→  libavdevice.so -> libavdevice-57.so
					→ x86
						→ (Like inside armeabi-v7a folder)
					→ armeabi
						→ (Like inside armeabi-v7a folder)
					→ arm64-v8a
						→ (Like inside armeabi-v7a folder)

				→ libavfilter
					→ armeabi-v7a
						→  libavfilter-6.so
						→ libavfilter.so -> libavfilter-6.so
					→ x86
						→ (Like inside armeabi-v7a folder)
					→ armeabi
						→ (Like inside armeabi-v7a folder)
					→ arm64-v8a
						→ (Like inside armeabi-v7a folder)
				→ libavformat
					→ armeabi-v7a
						→ libavformat-57.so
						→ libavformat.so -> libavformat-57.so
					→ x86
						→ (Like inside armeabi-v7a folder)
					→ armeabi
						→ (Like inside armeabi-v7a folder)
					→ arm64-v8a
						→ (Like inside armeabi-v7a folder)
				→ libavutil
					→ armeabi-v7a
						→ libavutil-55.so
						→ libavutil.so -> libavutil-55.so
					→ x86
						→ (Like inside armeabi-v7a folder)
					→ armeabi
						→ (Like inside armeabi-v7a folder)
					→ arm64-v8a
						→ (Like inside armeabi-v7a folder)
				→ libswresample
					→ armeabi-v7a
						→ libswresample-2.so
						→ libswresample.so -> libswresample-2.so
					→ x86
						→ (Like inside armeabi-v7a folder)
					→ armeabi
						→ (Like inside armeabi-v7a folder)
					→ arm64-v8a
						→ (Like inside armeabi-v7a folder)
				→ libswscale
					→ armeabi-v7a
						→ libswscale-4.so
						→ libswscale.so -> libswscale-4.so
					→ x86
						→ (Like inside armeabi-v7a folder)
					→ armeabi
						→ (Like inside armeabi-v7a folder)
					→ arm64-v8a
						→ (Like inside armeabi-v7a folder)
		→ openssl (libs/openssl)
			→ build
				→ armeabi-v7a
					→ bin
					→ certs
					→ include
						→ openssl
					→ lib
						→ engines
						→ libcrypto.a
						→ libscrypto.so
						→ libssl.a
						→ libssl.so
						→ link_shared
						→ pkg-config
					→ misc
					→ private
					→ openssl.cnf
				→ x86
					→ (Like inside armeabi-v7a folder)
				→ armeabi
					→ (Like inside armeabi-v7a folder)
				→ arm64-v8a
					→ (Like inside armeabi-v7a folder)
			→ include
				→ armeabi-v7a
					→ openssl
 				→ x86
					→ (Like inside armeabi-v7a folder)
				→ armeabi
					→ (Like inside armeabi-v7a folder)
				→ arm64-v8a
					→ (Like inside armeabi-v7a folder)
			→ lib
				→ armeabi-v7a
					→ libssl.so
					→ libcrypto.so
 				→ x86
					→ (Like inside armeabi-v7a folder)
				→ armeabi
					→ (Like inside armeabi-v7a folder)
				→ arm64-v8a
					→ (Like inside armeabi-v7a folder)

```

# Resources that I used
1. https://github.com/wseemann/FFmpegMediaMetadataRetriever (forked from)
2. https://github.com/wseemann/FFmpegMediaPlayer (old version of 1-st point)
3. https://github.com/wseemann/ServeStream
4. https://github.com/cine-io/android-ffmpeg-with-rtmp (It was my first target to compile, but this script compile only to armeabi-v7a)
5. https://github.com/WritingMinds/ffmpeg-android-java (A wrapper around FFmpeg(.so) and calling FFmpeg through the terminal)
6. https://github.com/WritingMinds/ffmpeg-android (Another one compilation script for FFmpeg with a lot of additional libs)
7. https://github.com/OnlyInAmerica/FFmpeg-Android (deprecated, but useful)
8. https://github.com/appunite/AndroidFFmpeg (a compilation script with sample)
9. https://github.com/havlenapetr/FFMpeg (A sample FFmpeg for android - wrapper for all FFmpeg classes)

# P.S.
The status of compilation - at begin of MAY 2017 with using NDK version r14b FFmpeg compilation fails for `x86_64, mips, arm64-v8a`, and OpenSSL fails for `x86_64`. 
As we all know for mass production **is enough** to have *armeabi-v7a* (the most polular architecture, other arm-based processors can work with it) and x86 (around 2 percent of all android devices). So I don't stuck with other architectures, and I guess that using older one version of NDK, for example, one of NDK r12 can fix the problem for some architectures.

**Summary**

As `build.sh` script I *can*:
 - FFmpeg for armeabi, armeabi-v7a, x86;
 - OpenSSL for armeabi, armeabi-v7a, arm64-v8a, mips, x86;

As `build.sh` script I *can't* (but I tried):
 - FFmpeg for arm64-v8a, x86_64, mips;
 - OpenSSL for x86_64 and other;

# License FFmpeg

Check [LICENSE.GPLv3](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html) and make sure to follow the licensing terms and conditions of the project and the software used to build the project.

# License OpenSSL

Check [license](https://www.openssl.org/source/license.html) and make sure to follow the licensing terms and conditions of the project and the software used to build the project.

# License

```
MIT License

Copyright (c) 2017 Victor Ponomarenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

