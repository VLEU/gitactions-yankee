FROM registry.access.redhat.com/ubi9/php-81@sha256:f3486e8b190dcfd05fe3c55055188fa5d867c7b0a48081b2b430470e77b2d8ca

USER root
ENV SMDEV_CONTAINER_OFF=1
LABEL maintainer="ARCS StuWeb05"
# Update image
RUN yum update --disableplugin=subscription-manager -y && rm -rf /var/cache/yum
RUN yum install --disableplugin=subscription-manager httpd -y && rm -rf /var/cache/yum
# Add default Web page and expose port
RUN echo "The Web Server is Running" > /var/www/html/index.html

RUN ARCH=$( /bin/arch )
# RUN subscription-manager repos --enable "codeready-builder-for-rhel-9-${ARCH}-rpms"

RUN dnf install -y https://satellite.az.gatech.edu/pub/katello-ca-consumer-latest.noarch.rpm
RUN subscription-manager register --org central --activationkey=cos-rhel9
# Install stuff
# Get EPEL installed on the system
# Install supporting software for Composer
RUN yum install php-cli php-zip wget unzip
# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/bin/composer
RUN composer --version
# # Latest release
# COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
RUN subscription-manager unregister

EXPOSE 80
# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
