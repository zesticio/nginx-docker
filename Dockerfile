FROM alpine
MAINTAINER Deebendu Kumar <deebendu.kumar@zestc.io>

# Install Nginx
#RUN apt-get -y update
#                    && apt-get -y install nginx

RUN apt-get -y update
RUN apt-get -y install \
                    wget \
                    tar \
                    curl
RUN apt-get -y install openssl

RUN apt-get -y install \
                    git \
                    gcc \
                    make \
                    libpcre3-dev \
                    zlib1g-dev \
                    libldap2-dev \
                    libssl-dev

RUN apt-get -y install \
                    apt-transport-https \
                    ca-certificates

RUN mkdir /var/log/nginx \
                    && mkdir /etc/nginx \
                    && cd ~ \
                    && git clone https://github.com/zesticio/nginx.git \
                    && cd nginx \
                    && ./configure \
                        --with-http_ssl_module \
                        --with-debug \
                        --conf-path=/etc/nginx/nginx.conf \
                        --sbin-path=/usr/sbin/nginx \
                        --pid-path=/var/log/nginx/nginx.pid \
                        --error-log-path=/var/log/nginx/error.log \
                        --http-log-path=/var/log/nginx/access.log \
                    && make install \
                    && cd .. \
                    && rm -rf nginx

RUN chmod 777 tmp

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
#COPY ./default.conf /etc/nginx/sites-available/default.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./ssl-params.conf /etc/nginx/ssl-params.conf

# Expose the port for access
EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/nginx","-g","daemon off;"]