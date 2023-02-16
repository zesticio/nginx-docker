FROM ubuntu
MAINTAINER Deebendu Kumar <deebendu.kumar@zestc.io>

# Install Nginx
RUN apt-get -y update
RUN apt-get -y install nginx curl vim
RUN apt-get -y install openssl
RUN apt-get update -y
RUN apt-get clean

# Copy the Nginx config
COPY index.html /usr/share/nginx/html
COPY default.conf /etc/nginx/sites-available/default.conf

# Expose the port for access
EXPOSE 80/tcp
EXPOSE 443/tcp

# Run the Nginx server
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]