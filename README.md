## SQLCipher

SQLCipher extends the [SQLite](https://www.sqlite.org) database library to add security enhancements that make it more suitable for encrypted local data storage such as on-the-fly encryption, tamper evidence, and key derivation. Based on SQLite, SQLCipher closely tracks SQLite and periodically integrates stable SQLite release features.

SQLCipher is maintained by Zetetic, LLC, and additional information and documentation is available on the official [SQLCipher site](https://www.zetetic.net/sqlcipher/).

This branch has just a different **Makefile.msc** to build with msvc. Compile flags included by default are 
```
ENABLE_COLUMN_METADATA
ENABLE_DBSTAT_VTAB
ENABLE_FTS3
ENABLE_GEOPOLY
ENABLE_JSON1
ENABLE_RTREE
ENABLE_STMTVTAB
HAS_CODEC
MAX_TRIGGER_DEPTH=100
TEMP_STORE=2
THREADSAFE=1
```

## How to build

Needs a working tcl. See [Tcl Binary installers](http://www.tcl.tk/software/tcltk/bindist.html).
This branch is tested with binaries from [Thomas Perschak](https://bitbucket.org/tombert/tcltk/downloads/) inside the compat directory.

For OpenSSL I prefer the [vcpkg library manager](https://github.com/microsoft/vcpkg) installation.

Either set TCLDIR and/or OPENSSLDIR in'Makefile.msc' and then run nmake
```
nmake -f Makefile.msc
```
or set them on the command line
```
nmake -f Makefile.msc TCLDIR=\tcl OPENSSLDIR=\vcpkg\installed\x64-windows
```

## Original License

Copyright (c) 2016, ZETETIC LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the ZETETIC LLC nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
