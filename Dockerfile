# Grabbing Latest Alpine Docker Image
FROM alpine:latest

# Setting Arguments
ARG NGINX_VERSION=1.19.0

# Setting Environment Variables
ENV PATH "${PATH}:/usr/local/nginx/sbin"

# Adding non-build related dependencies
RUN apk add --no-cache git

# Cloning NGINX RTMP Module Repository
RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git

# Downloading and unpacking nginx source code
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar zxf nginx-${NGINX_VERSION}.tar.gz

# Adding needed dependencies for nginx to build
RUN apk add --no-cache g++ make pcre-dev openssl-dev zlib-dev

# Compiling NGINX from source
RUN cd nginx-${NGINX_VERSION} && \
    ./configure --prefix=/usr/local/nginx --conf-path=/etc/nginx/nginx.conf --with-http_ssl_module --add-module=../nginx-rtmp-module && \
    make -j && \
    make install

# Making HLS directory
RUN mkdir /mnt/hls

# Copying needed files
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /mnt/index.html
COPY favicon.ico /mnt/favicon.ico

# Exposing needed ports
EXPOSE 1935
EXPOSE 8080
EXPOSE 80

# Making /mnt volume for persistant data
VOLUME ["/mnt"]

# Running NGINX
CMD ["nginx", "-g", "daemon off;"]