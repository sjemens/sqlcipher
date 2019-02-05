#! /usr/bin/env bash

# === NO CHANGES NEEDED BELOW THIS POINT ===
source vars

(mkdir -p build-android && cd build-android;

 if [ ! ${ANDROID_SDK_VERSION} ]; then
     echo "ANDROID_SDK_VERSION was not provided, include and rerun"
     exit 1
 fi

 if [ ! ${ANDROID_64_BIT_SDK_VERSION} ]; then
     echo "ANDROID_64_BIT_SDK_VERSION was not provided, include and rerun"
     exit 1
 fi

 if [ ! ${ANDROID_NDK_ROOT} ]; then
     echo "ANDROID_NDK_ROOT environment variable not set, set and rerun"
     exit 1
 fi

 SQLCIPHER_CONFIGURE_OPTIONS="\
  --disable-amalgamation \
  --disable-tcl \
  --enable-tempstore \
  --enable-json1 \
  --enable-fts4 \
  --enable-fts5 \
  --enable-rtree \
  --enable-session \
  --with-crypto-lib=openssl \
  --with-pic=yes"

 HOST_INFO=`uname -a`
 case ${HOST_INFO} in
     Darwin*)
         TOOLCHAIN_SYSTEM=darwin-x86_64
         ;;
     Linux*)
         if [[ "${HOST_INFO}" == *i686* ]]
         then
             TOOLCHAIN_SYSTEM=linux-x86
         else
             TOOLCHAIN_SYSTEM=linux-x86_64
         fi
         ;;
     *)
         echo "Toolchain unknown for host system"
         exit 1
         ;;
 esac

 TOOLCHAIN_DIR=${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/${TOOLCHAIN_SYSTEM}/bin

 for SQLCIPHER_TARGET_PLATFORM in ${TARGET_PLATFORMS}
 do
     echo "Building libsqlcipher.a for ${SQLCIPHER_TARGET_PLATFORM}"
     case "${SQLCIPHER_TARGET_PLATFORM}" in
         armeabi)
             TOOLCHAIN_PREFIX=arm-linux-androideabi
             ANDROID_API_VERSION=${ANDROID_SDK_VERSION}
             ;;
         armeabi-v7a)
             TOOLCHAIN_PREFIX=armv7a-linux-androideabi
             ANDROID_API_VERSION=${ANDROID_SDK_VERSION}
             ;;
         x86)
             TOOLCHAIN_PREFIX=i686-linux-android
             ANDROID_API_VERSION=${ANDROID_SDK_VERSION}
             ;;
         x86_64)
             TOOLCHAIN_PREFIX=x86_64-linux-android
             ANDROID_API_VERSION=${ANDROID_64_BIT_SDK_VERSION}
             ;;
         arm64-v8a)
             TOOLCHAIN_PREFIX=aarch64-linux-android
             ANDROID_API_VERSION=${ANDROID_64_BIT_SDK_VERSION}
             ;;
         *)
             echo "Unsupported build platform:${SQLCIPHER_TARGET_PLATFORM}"
             exit 1
     esac
     mkdir -p "${SQLCIPHER_TARGET_PLATFORM}"


     PATH=${TOOLCHAIN_DIR}:${PATH} \
         ../configure --host=${TOOLCHAIN_PREFIX} \
             --with-sysroot=${ANDROID_NDK_ROOT}/sysroot \
             ${SQLCIPHER_CONFIGURE_OPTIONS} \
             "CFLAGS=-DSQLITE_HAS_CODEC -DSQLCIPHER_CRYPTO_OPENSSL -DSQLITE_ENABLE_COLUMN_METADATA -I${OPENSSL}/include" \
             "LDFLAGS=${DEST_DIR}/${SQLCIPHER_TARGET_PLATFORM}/libcrypto.a" \
             CC=${TOOLCHAIN_PREFIX}${ANDROID_API_VERSION}-clang

     if [ $? -ne 0 ]; then
         echo "Error executing:configure for sqlcipher"
         exit 1
     fi

     make clean
     PATH=${TOOLCHAIN_DIR}:${PATH} \
       make sqlite3.h libsqlcipher.la

     if [ $? -ne 0 ]; then
         echo "Error executing make for platform:${SQLCIPHER_TARGET_PLATFORM}"
         exit 1
     fi

    /usr/bin/install -m 644 ./.libs/libsqlcipher.a ${DEST_DIR}/${SQLCIPHER_TARGET_PLATFORM}
    /usr/bin/install -m 644 ./sqlite3.h            ${DEST_DIR}/${SQLCIPHER_TARGET_PLATFORM}
    /usr/bin/install -m 644 ../src/sqlite3ext.h    ${DEST_DIR}/${SQLCIPHER_TARGET_PLATFORM}
 done
)
