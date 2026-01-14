FROM alpine:3.23.2

WORKDIR /app

# Add repo from Singapore
RUN echo "http://mirror.jingk.ai/alpine/v3.23/main" > /etc/apk/repositories \
 && echo "http://mirror.jingk.ai/alpine/v3.23/community" >> /etc/apk/repositories

RUN apk update && apk add --no-cache vim curl htop

RUN apk add --no-cache nodejs npm

RUN apk add --no-cache composer

RUN apk add --no-cache \
    php84 \
    php84-phar \
    php84-mbstring \
    php84-openssl \
    php84-json \
    php84-tokenizer \
    php84-ctype \
    php84-curl \
    php84-xml \
    php84-dom \
    php84-simplexml \
    php84-fileinfo \
    php84-session \
    php84-zip \
    php84-bcmath \
    php84-gd \
    php84-intl \
    php84-opcache \
    php84-xmlwriter \
    php84-xmlreader
	
# Database drivers
RUN apk add --no-cache \
    php84-pdo \
    php84-pdo_mysql \
    php84-pdo_pgsql \
    php84-pdo_sqlite \
    php84-sqlite3 \
	php84-pecl-mongodb

RUN rm -rf /var/cache/apk/*

CMD ["sh"]

# ================================================

# docker image rm alpine-custom
# docker build -t alpine-custom .
# docker run -it --rm alpine-custom

# php -v
# composer -V
# node -v
# npm -v
# vim --version