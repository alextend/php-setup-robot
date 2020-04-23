#!/bin/sh

installCheck() {
    if [ $? -ne 0 ];then
        echo "###################"
        echo "# Install Failed. #"
        echo "###################"
        exit 1
    fi

    echo "######################"
    echo "# Install Successed. #"
    echo "######################"
}

setupCheck(){
    if [ $? -eq 0 ];then
        echo "#####################"
        echo "#  Setup Completed  #"
        echo "#####################"
    fi
}

if [ -f /etc/init.d/php73-fpm ];then
	mv /etc/init.d/php73-fpm /etc/init.d/php73-fpm.bak
fi

yum install -y centos-release-scl
yum install -y devtoolset-6-gcc-c++
mv /usr/bin/gcc /usr/bin/gcc-4.4.7
mv /usr/bin/g++ /usr/bin/g++-4.4.7
mv /usr/bin/c++ /usr/bin/c++-4.4.7
ln -s /opt/rh/devtoolset-6/root/usr/bin/gcc /usr/bin/gcc
ln -s /opt/rh/devtoolset-6/root/usr/bin/c++ /usr/bin/c++
ln -s /opt/rh/devtoolset-6/root/usr/bin/g++ /usr/bin/g++

yum -y install vim wget gettext-devel libpng-devel gcc gcc-c++ libxml2-devel flex perl-DBI \
    ncurses-devel mysql-devel openssl openssl-devel libtool-ltdl* libtool unzip \
    libXpm-devel readline-devel libedit-devel freetype-devel 


[ ! -f /etc/pki/tls/cert.pem ] && \
    wget http://curl.haxx.se/ca/cacert.pem -O /etc/pki/tls/cert.pem --no-check-certificate

yum upgrade -y


###########curl#########
tar xf curl-7.67.0.tar.gz
cd curl-7.67.0
./configure --prefix=/usr/local/curl/7.67.0
make && make install
installCheck
cd ../


########## lib iconv ##########
tar xf libiconv-1.16.tar.gz
cd libiconv-1.16
./configure --prefix=/usr/local/libiconv/1.16
make && make install
installCheck
cd ../


########## lib jpeg ##########
tar xf jpegsrc.v9c.tar.gz
cd jpeg-9c
/bin/cp /usr/share/libtool/config/config.sub .
/bin/cp /usr/share/libtool/config/config.guess .
./configure --prefix=/usr/local/libjpeg/9c --enable-static --enable-shared
make && make install
installCheck
cd ../


########## lib png ##########
tar xf libpng-1.6.37.tar.gz
cd libpng-1.6.37
./configure --prefix=/usr/local/libpng/1.6.37
make && make install
installCheck
cd ../


########## lib zib ##########
tar xf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=/usr/local/zlib/1.2.11
make && make install
installCheck
cd ../

########## gettext ##########
tar xf gettext-0.20.1.tar.gz
cd gettext-0.20.1
./configure --prefix=/usr/local/gettext/0.20.1
make && make install
installCheck
cd ../


########## lib freetype ##########
tar xf freetype-2.6.3.tar.gz
cd freetype-2.6.3
./configure --prefix=/usr/local/freetype/2.6.3
make && make install
make clean
cd ../


########## gd ##########
tar xf libgd-2.1.1.tar.gz
cd libgd-2.1.1
./configure --prefix=/usr/local/libgd/2.1.1 --with-freetype=/usr/local/freetype/2.6.3 --with-jpeg=/usr/local/libjpeg/9c --with-png=/usr/local/libpng/1.6.37
make && make install
installCheck
cd ../


######libmemcached##########
tar zxvf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure --prefix=/usr/local/libmemcached/1.0.18
make && make install
installCheck
cd ../


######PHP 7.3.13###########
tar zxf php-7.3.13.tar.gz
cd php-7.3.13
# mcrypt已弃用
./configure \
    --prefix=/usr/local/php/7.3.13 \
    --enable-fpm --with-config-file-path=/usr/local/etc/php73 \
    --enable-wddx --enable-ftp --enable-sockets --enable-mbstring \
    --enable-bcmath --enable-soap --enable-json --enable-zip \
    --with-mysqli --with-pdo-mysql \
    --with-readline --with-libedit --with-openssl --enable-pcntl --enable-exif \
    --with-curl=/usr/local/curl/7.67.0/ \
    --with-iconv=/usr/local/libiconv/1.16 \
    --with-jpeg-dir=/usr/local/libjpeg/9c \
    --with-png-dir=/usr/local/libpng/1.6.37 \
    --with-zlib-dir=/usr/local/zlib/1.2.11 \
    --with-gettext=/usr/local/gettext/0.20.1 \
    --with-freetype-dir=/usr/local/freetype/2.6.3 \
    --with-gd=/usr/local/libgd/2.1.1

make && make install
installCheck
cd ../


#########zip#########
# cd php-7.3.13/ext/zip/
# /usr/local/php/7.3.13/bin/phpize
# ./configure --with-php-config=/usr/local/php/7.3.13/bin/php-config
# make && make install
# installCheck
# cd ../../../


#######autoconf#####
rpm -e --nodeps autoconf-2.63
tar -zxvf autoconf-2.69.tar.gz
cd autoconf-2.69
mkdir -p /usr/local/autoconf
./configure && make && make install
installCheck
cd ../


#######memcached#####
tar zxf php-memcached-3.1.5.tar.gz
cd php-memcached-3.1.5
/usr/local/php/7.3.13/bin/phpize
./configure --with-php-config=/usr/local/php/7.3.13/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached/1.0.18 --disable-memcached-sasl
make && make install
installCheck
cd ../


#########redis#########
tar zxf phpredis-5.1.1.tar.gz
cd phpredis-5.1.1
/usr/local/php/7.3.13/bin/phpize
./configure --with-php-config=/usr/local/php/7.3.13/bin/php-config
make && make install
installCheck
cd ../



#########rabbitmq-c######################
tar zxf rabbitmq-c-0.8.0.tar.gz
cd rabbitmq-c-0.8.0
./configure --prefix=/usr/local/rabbitmq-c/0.8.0
make && make install
installCheck
cd ../


#########amqp##########
tar zxf amqp-1.9.4.tgz
cd amqp-1.9.4
/usr/local/php/7.3.13/bin/phpize
./configure --with-php-config=/usr/local/php/7.3.13/bin/php-config --with-amqp --with-librabbitmq-dir=/usr/local/rabbitmq-c/0.8.0
make && make install
installCheck
cd ../

#########pdo_pgsql#########
yum install postgresql-devel -y
cd php-7.3.13/ext/pdo_pgsql/
/usr/local/php/7.3.13/bin/phpize
./configure --with-php-config=/usr/local/php/7.3.13/bin/php-config
make && make install
installCheck
cd ../../../


#############swoole###########
/usr/local/php/7.3.13/bin/pecl clear-cache
/usr/local/php/7.3.13/bin/pecl channel-upgrade

tar zxf swoole-src-4.4.12.tar.gz
cd swoole-src-4.4.12
/usr/local/php/7.3.13/bin/phpize
./configure --with-php-config=/usr/local/php/7.3.13/bin/php-config
make && make install
installCheck
cd ../

############libart_lgpl##############
tar zxf libart_lgpl-2.3.17.tar.gz
cd libart_lgpl-2.3.17
./configure --prefix=/usr/local/libart_lgpl/2.3.17
make && make install
installCheck
cd ../


ln -s /usr/local/lib/libpcre.so.1 /lib64/libpcre.so.1 
[ ! -d /data/logs/php ] && mkdir /data/logs/php -p
[ ! -d /data/logs/php73 ] && mkdir /data/logs/php73 -p
[ ! -d /data/logs/www ] && mkdir /data/logs/www -p

if [ -d /usr/local/etc/php73 ];then
	mv /usr/local/etc/php73 /usr/local/etc/php73.bak
fi
\cp -r conf/php_conf /usr/local/etc/php73
\cp init.d/php-fpm /etc/init.d/php73-fpm
\cp /usr/local/php/7.3.13/bin/php /usr/bin/php73
chmod +x /etc/init.d/php73-fpm

# /etc/init.d/php73-fpm start

setupCheck

