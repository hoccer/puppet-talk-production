#! /bin/sh
cd /root/nginx-install

echo "---- Building"
dpkg-source -x nginx_1.4.1-1.dsc
cd nginx-1.4.1/
patch -p1  < ../nginx-1.3.14-no_buffer-v7.patch
fakeroot debian/rules build
fakeroot debian/rules binary

echo "---- Installing"
cd ..
dpkg --install nginx_1.4.1-1_all.deb nginx-common_1.4.1-1_all.deb nginx-doc_1.4.1-1_all.deb nginx-full_1.4.1-1_amd64.deb

