
FROM registry.redhat.io/rhel9/php-81@sha256:f3486e8b190dcfd05fe3c55055188fa5d867c7b0a48081b2b430470e77b2d8ca

USER root
LABEL maintainer="ARCS StuWeb09"
# Update image
RUN yum update --disableplugin=subscription-manager -y && rm -rf /var/cache/yum
RUN yum install --disableplugin=subscription-manager httpd -y && rm -rf /var/cache/yum
# Add default Web page and expose port
RUN echo "The Web Server is Running" > /var/www/html/index.html
# Get EPEL installed on the system
# Install supporting software for Composer
RUN yum install php-cli php-zip wget unzip



EXPOSE 80
# Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]

## Next steps
# consumes php-81, get composer present, add drupal either as part of image or as discrete storage

# Older sites might need to be php-74 (storage-based, drupal side stuff)

# 
