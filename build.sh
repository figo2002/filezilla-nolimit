#/usr/bin/env sh

cd filezilla-nolimit
autoreconf -i
./configure --host=$TARGET_HOST --prefix="$HOME/prefix" --enable-shared 
--disable-static --with-pugixml=builtin
make
# strip debug symbols
$TARGET_HOST-strip src/interface/.libs/filezilla.exe
$TARGET_HOST-strip src/putty/.libs/fzsftp.exe
$TARGET_HOST-strip src/putty/.libs/fzputtygen.exe
$TARGET_HOST-strip src/fzshellext/64/.libs/libfzshellext-0.dll
$TARGET_HOST-strip src/fzshellext/32/.libs/libfzshellext-0.dll
$TARGET_HOST-strip data/dlls/*.dll
cd data
