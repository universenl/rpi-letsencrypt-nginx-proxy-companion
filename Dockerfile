FROM armv7/armhf-ubuntu:14.04 AS go-builder
LABEL Mitch Daniels <m.daniels@grimbon.nl>

# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    curl \
    wget \
	openssl \
	ca-certificates \
	make \
	gcc \
	build-essential \
	git \
	musl-dev \
	golang \
	python3 \
	#&& rm /var/www/html/index.nginx-debian.html \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN wget http://www.openssl.org/source/openssl-1.1.1c.tar.gz \
  && tar -zxf openssl-1.1.1c.tar.gz \
  && cd openssl-1.1.1c \
  && ./Configure darwin64-x86_64-cc --prefix=/usr/local/bin

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV DOCKER_GEN_VERSION 0.7.4
ENV DEBUG=false \
    DOCKER_HOST=unix:///var/run/docker.sock

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-armhf-$DOCKER_GEN_VERSION.tar.gz

# Install simp_le
COPY /install_simp_le.sh /app/install_simp_le.sh
RUN chmod +rx /app/install_simp_le.sh \
    && sync \
    && /app/install_simp_le.sh \
    && rm -f /app/install_simp_le.sh

COPY /app/ /app/

WORKDIR /app

ENTRYPOINT [ "/bin/bash", "/app/entrypoint.sh" ]
CMD [ "/bin/bash", "/app/start.sh" ]
