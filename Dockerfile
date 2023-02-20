FROM nginx
MAINTAINER Deebendu Kumar <deebendu.kumar@zestc.io>

RUN rm /etc/nginx/conf.d/default.conf

# Install Nginx
#RUN apt-get -y update
#                    && apt-get -y install nginx

RUN apt-get -y update
RUN apt-get -y install \
                    wget \
                    tar \
                    curl

RUN apt-get -y install \
                    openssl

RUN apt-get -y install \
                    apt-transport-https \
                    ca-certificates

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
COPY ./mime.types /etc/nginx/mime.types
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./ssl-params.conf /etc/nginx/ssl-params.conf

# Expose the port for access
EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/nginx","-g","daemon off;"]