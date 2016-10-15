FROM centos:5
MAINTAINER OKUMURA Takahiro <hfm.garden@gmail.com>

RUN yum -y -q install gcc \
      patch \
      make \
      bzip2 \
      libxml2-devel \
      libxslt-devel \
      openssl-devel \
      curl-devel \
      libmcrypt-devel \
      readline-devel \
      libjpeg-devel \
      libvpx-devel \
      libpng-devel \
      freetype-devel \
      libtidy-devel \
      libtool \
      libtool-ltdl-devel \
      mysql-devel \
      httpd \
      httpd-devel \
      epel-release
RUN yum -y -q install git

RUN git clone --depth 1 git://github.com/php-build/php-build.git /usr/local/src/php-build
RUN sh /usr/local/src/php-build/install.sh
RUN rm -rf /usr/local/src/php-build
RUN echo --with-apxs2 >> /usr/local/share/php-build/default_configure_options
RUN php-build 5.2.17 /usr/local

RUN echo -e "<FilesMatch \\.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>" > /etc/httpd/conf.d/php.conf

VOLUME /var/www/html

EXPOSE 80 443

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
