FROM ubuntu
MAINTAINER Deebendu Kumar <deebendu.kumar@zestc.io>

# Install Nginx
RUN apt-get -y update && apt-get -y install nginx
RUN apt-get -y install --no-install-recommends --no-install-suggests gnupg1 apt-transport-https ca-certificates
RUN apt-get -y install wget tar curl
RUN apt-get -y install openssl
RUN chmod 777 tmp
RUN rm -rf /var/lib/apt/lists/*

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
COPY ./html /var/www/html
#COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./mime.types /etc/nginx/mime.types
COPY ./default.conf /etc/nginx/sites-available/default.conf
COPY ./certificates.conf /etc/nginx/certificates.conf
COPY ./ssl-params.conf /etc/nginx/ssl-params.conf

# Expose the port for access
EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["/usr/sbin/nginx","-g","daemon off;"]