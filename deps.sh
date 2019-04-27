#/usr/bin/env sh
mkdir ~/prefix
mkdir ~/src
export PATH="$HOME/prefix/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/prefix/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$HOME/prefix/lib/pkgconfig:$PKG_CONFIG_PATH"
export TARGET_HOST=x86_64-w64-mingw32

cd ~/src
wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.lz
tar xf gmp-6.1.2.tar.lz
cd gmp-6.1.2
./configure --host=$TARGET_HOST --prefix="$HOME/prefix" --disable-static --enable-shared --enable-fat
make
make install

cd ~/src
wget https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz
tar xf nettle-3.4.1.tar.gz
cd nettle-3.4.1
./configure --host=$TARGET_HOST --prefix="$HOME/prefix" --enable-shared --disable-static --enable-fat LDFLAGS="-L$HOME/prefix/lib" CPPFLAGS="-I$HOME/prefix/include"
make
make install


cd ~/src
wget https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.6.tar.xz
tar xvf gnutls-3.6.6.tar.xz
cd gnutls-3.6.6
./configure --host=$TARGET_HOST --prefix="$HOME/prefix" --enable-shared --disable-static --with-included-libtasn1 --without-p11-kit --disable-doc --enable-local-libopts --with-included-unistring GMP_LIBS="-L$HOME/prefix/lib -lgmp" GMP_CFLAGS="-I$HOME/prefix/include"
make
make install


cd ~/src
wget https://sqlite.org/2019/sqlite-autoconf-3280000.tar.gz
tar xvzf sqlite-autoconf-3280000.tar.gz
cd sqlite-autoconf-3280000
./configure --host=$TARGET_HOST --prefix="$HOME/prefix" --enable-shared --disable-static --disable-dynamic-extensions
make
make install

cd ~/src
git clone --branch WX_3_0_BRANCH --single-branch https://github.com/wxWidgets/wxWidgets.git wx3
cd wx3
./configure --host=$TARGET_HOST --prefix="$HOME/prefix" --enable-shared --disable-static
make
make install


cd ~/src
svn co https://svn.filezilla-project.org/svn/libfilezilla/tags/0.15.1 lfz
cd lfz
autoreconf -i
./configure --host=$TARGET_HOST --prefix="$HOME/prefix" --enable-shared --disable-static 
make
make install
cp $HOME/prefix/lib/wx*.dll $HOME/prefix/bin

