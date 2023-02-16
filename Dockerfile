FROM ubuntu:latest
MAINTAINER Deebendu Kumar <deebendu.kumar@zestc.io>

# Install Nginx
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install --no-install-recommends --no-install-suggests gnupg1 apt-transport-https ca-certificates
RUN apt-get -yqq --no-install-recommends install nginx wget tar curl \
            && mkdir tmp && chmod 777 tmp \
            && rm -rf /var/lib/apt/lists/* \
            && rm -f /etc/nginx/sites-enabled/default
RUN apt-get -y install curl vim
RUN apt-get -y install openssl
RUN apt-get update -y
RUN apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y

RUN echo "We can create a self-signed key and certificate pair with OpenSSL in a single command"
RUN openssl req \
        -newkey rsa:4096 \
        -x509 \
        -nodes \
        -keyout /etc/ssl/private/nginx.key \
        -days 3650 \
        -out /etc/ssl/certs/nginx.crt \
        -subj "/C=US/ST=WA/L=Seattle/CN=example.com/emailAddress=deebendu.kumar@zestic.in"

RUN openssl dhparam \
      -out /etc/ssl/certs/nginx.pem 2048

# Copy the Nginx config
COPY ./html /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./mime.types /etc/nginx/mime.types
COPY ./conf.d /etc/nginx/conf.d
COPY ./site.conf.d /etc/nginx/site.conf.d
COPY ./sites.d /etc/nginx/sites.d
COPY ./default.conf /etc/nginx/sites-available/default.conf
COPY ./certificates.conf /etc/nginx/certificates.conf
COPY ./ssl-params.conf /etc/nginx/ssl-params.conf

# Expose the port for access
EXPOSE 80 443

CMD nginx -g 'daemon off;' 