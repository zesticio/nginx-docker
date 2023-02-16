FROM ubuntu
MAINTAINER Deebendu Kumar <deebendu.kumar@zestc.io>

# Install Nginx
RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN apt-get -y install --no-install-recommends --no-install-suggests gnupg1 apt-transport-https ca-certificates
#RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
#RUN echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list
#RUN apt-get install --no-install-recommends --no-install-suggests -y \
#                                                nginx-module-xslt \
#                                                nginx-module-geoip \
#                                                nginx-module-image-filter \
#                                                nginx-module-njs \
#                                                gettext-base\
RUN apt-get -y install nginx curl vim
RUN apt-get -y install openssl
RUN apt-get update -y
#RUN rm /etc/nginx/conf.d/default.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

RUN echo "We can create a self-signed key and certificate pair with OpenSSL in a single command"
RUN sudo openssl req \
        -newkey rsa:4096 \
        -x509 \
        -nodes \
        -keyout /etc/ssl/private/nginx.key \
        -days 3650 \
        -out /etc/ssl/certs/nginx.crt \
        -subj "/C=US/ST=WA/L=Seattle/CN=example.com/emailAddress=deebendu.kumar@zestic.in"

RUN sudo openssl dhparam \
      -out /etc/ssl/certs/nginx.pem 2048

# Copy the Nginx config
ADD ./html.zip /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./mime.types /etc/nginx/mime.types
COPY ./conf.d /etc/nginx/conf.d
COPY ./site.conf.d /etc/nginx/site.conf.d
COPY ./sites.d /etc/nginx/sites.d
COPY ./default.conf /etc/nginx/sites-available/default.conf
COPY ./certificates.conf /etc/nginx/certificates.conf
COPY ./ssl-params.conf /etc/nginx/ssl-params.conf

# Expose the port for access
EXPOSE 80/tcp
EXPOSE 443/tcp

# Run the Nginx server
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]