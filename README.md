# compile-ffmpeg-with-openssl
A bunch of script you can use to compile ffmpeg with openssl

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
	→ build.sh (the main compilation script for both ffmpeg and openssl)
	→ _build_ffmpeg.sh (ffmpeg compilation script)
	→ _build_openssl.sh (openssl compilation script)
	→ _old_build_ffmpeg.sh (ffmpeg compilation script for only armeabi architecture)
	→ _old_build_openssl.sh (openssl 1.0.0a compilation script)
	→ Setenv-android.sh (set up environment (variables, etc) for openssl compilation, runs inside _build_openssl.sh)
	→ patches
		→ patch_fix_ffmpeg_lib_name.txt (the patch file to fix ffmpeg libs name suffix)
	→ src
		→ ffmpeg-android (ffmpeg sources)
		→ openssl-android (openssl sources)
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
5. https://github.com/WritingMinds/ffmpeg-android-java (Wrapper around FFMPEG(.so) and calling ffmpeg through the terminal)
6. https://github.com/WritingMinds/ffmpeg-android (Another one compilation build script for ffmpeg with a lot of additional libs)
7. https://github.com/OnlyInAmerica/FFmpeg-Android (Deprecated, but useful)
8. https://github.com/appunite/AndroidFFmpeg (Compile with sample)
9. https://github.com/havlenapetr/FFMpeg (Sample ffmpeg for android - wrapper for all ffmpeg classes)

# P.S.
The status of compilation - at begin of MAY 2017 with using NDK version r14b FFMPEG compilation fails for `x86_64, mips, arm64-v8a ABI`, and OPENSSL fails for `x86_64`.


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

