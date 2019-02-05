#! /usr/bin/env bash

# This is a modified version of build-openssl-libraries.sh found in
# https://github.com/sqlcipher/android-database-sqlcipher/blob/master/android-database-sqlcipher/build-openssl-libraries.sh
# LICENCE:
# https://github.com/sqlcipher/android-database-sqlcipher/blob/master/android-database-sqlcipher/SQLCIPHER_LICENSE

# No changes should be needed in this file. Set the desired values in vars
source vars

(cd ${OPENSSL};

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

 OPENSSL_CONFIGURE_OPTIONS="-fPIC no-idea no-camellia \
 no-seed no-bf no-cast no-rc2 no-rc4 no-rc5 no-md2 \
 no-md4 no-ecdh no-sock no-ssl3 \
 no-dsa no-dh no-ec no-ecdsa no-tls1 \
 no-rfc3779 no-whirlpool no-srp \
 no-mdc2 no-ecdh no-engine \
 no-srtp"

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
     echo "Building libcrypto.a for ${SQLCIPHER_TARGET_PLATFORM}"
     case "${SQLCIPHER_TARGET_PLATFORM}" in
         armeabi)
             CONFIGURE_ARCH=android-arm
             ANDROID_API_VERSION=${ANDROID_SDK_VERSION}
             ;;
         armeabi-v7a)
             TOOLCHAIN_PREFIX=armv7a-linux-androideabi
             CONFIGURE_ARCH="android-arm -march=armv7-a"
             ANDROID_API_VERSION=${ANDROID_SDK_VERSION}
             ;;
         x86)
             TOOLCHAIN_PREFIX=i686-linux-android
             CONFIGURE_ARCH=android-x86
             ANDROID_API_VERSION=${ANDROID_SDK_VERSION}
             ;;
         x86_64)
             TOOLCHAIN_PREFIX=x86_64-linux-android
             CONFIGURE_ARCH=android64-x86_64
             ANDROID_API_VERSION=${ANDROID_64_BIT_SDK_VERSION}
             ;;
         arm64-v8a)
             TOOLCHAIN_PREFIX=aarch64-linux-android
             TOOLCHAIN_FOLDER=aarch64-linux-android
             CONFIGURE_ARCH=android-arm64
             ANDROID_API_VERSION=${ANDROID_64_BIT_SDK_VERSION}
             ;;
         *)
             echo "Unsupported build platform:${SQLCIPHER_TARGET_PLATFORM}"
             exit 1
     esac
     mkdir -p "${DEST_DIR}/${SQLCIPHER_TARGET_PLATFORM}"

     ANDROID_NDK=${ANDROID_NDK_ROOT} \
     CC=${TOOLCHAIN_PREFIX}${ANDROID_API_VERSION}-clang \
     PATH=${TOOLCHAIN_DIR}:${PATH} \
         ./Configure ${CONFIGURE_ARCH} \
             -D__ANDROID_API__=${ANDROID_API_VERSION} \
             ${OPENSSL_CONFIGURE_OPTIONS}

     if [ $? -ne 0 ]; then
         echo "Error executing:./Configure ${CONFIGURE_ARCH} ${OPENSSL_CONFIGURE_OPTIONS}"
         exit 1
     fi

     make clean
     ANDROID_NDK=${ANDROID_NDK_ROOT} \
     CC=${TOOLCHAIN_PREFIX}${ANDROID_API_VERSION}-clang \
     PATH=${TOOLCHAIN_DIR}:${PATH} \
         make build_libs

     if [ $? -ne 0 ]; then
         echo "Error executing make for platform:${SQLCIPHER_TARGET_PLATFORM}"
         exit 1
     fi
     /usr/bin/install -m 644 libcrypto.a ${DEST_DIR}/${SQLCIPHER_TARGET_PLATFORM}
 done
)
