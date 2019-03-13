## SQLCipher for Android

**WARNING**:warning: In this branch there are just some helper scripts to help cross compiling for android platforms. This is not a Java Native Interface (JNI). No jar or aar files are produced like in the https://github.com/sqlcipher/android-database-sqlcipher

### Why

My use case is to build the Qt5 sqldriver plugin for SQLCipher [qsqlcipher-qt5](https://github.com/sjemens/qsqlcipher-qt5) which depends on the libsqlcipher.a and libcrypto.a .

## Assumptions and Requirements

 - Helper programs like tcl and make are already installed.
 - Android SDK and android NDK are already installed.
 - Android NDK version is at least r19. [Site](https://developer.android.com/ndk/downloads/)
 - OpenSSL library sources are already downloaded. [Site](https://www.openssl.org/source/)
 
## Building process

```bash
# The android branch is all that is needed and it is faster without the commit history
git clone -b android --single-branch --depth=1 https://github.com/sjemens/sqlcipher.git

# All configuration happens in the 'vars' file. Edit it to set the values that make sense to your development enviroment.
cd sqlcipher
vi vars # or whatever $EDITOR you like

# Run the helper scripts in order. This will take some time.
./build-openssl-libraries.sh
./build-sqlcipher.sh
```

The resulting libraries and header files are in the DEST_DIR folder as set in the 'vars' file.

## Licences

The helper scripts are under the MIT License.

The original sqlcipher [license](https://github.com/sqlcipher/sqlcipher/blob/master/LICENSE).
