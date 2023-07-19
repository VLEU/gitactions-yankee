
FROM registry.access.redhat.com/ubi8/ubi@sha256:8fea2399f44a9dfdfa18eec4e3e5d2e1d71f0a865dd1d5c66215a6d68ccafa8a

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
