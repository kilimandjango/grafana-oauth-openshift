FROM registry.access.redhat.com/rhel7:7.4

MAINTAINER Kilian Henneboehle "kilian.henneboehle@mailbox.org"

ENV GOPATH /root/go \
    GOROOT /usr/local/go \
    NODEJS_VERSION=8 \
    NPM_RUN=start \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

RUN yum-config-manager --enable "rhel-server-rhscl-7-rpms" --enable "rhel-7-server-rpms" --enable "rhel-7-server-extras-rpms" && \
    yum install -y --nogpgcheck \
    wget \
    initscripts \
    curl \
    tar \
    gcc \
    libc6-dev \
    git \
    go \
    rh-nodejs8 \
    bzip2 \
    bzip2-libs;
    
RUN scl enable rh-nodejs8 bash && node --version;

RUN yum -y update && yum clean all

RUN wget https://dl.google.com/go/go1.9.2.linux-amd64.tar.gz

RUN tar -C /usr/local/ -xvf go1.9.2.linux-amd64.tar.gz

ENV PATH $GOROOT/bin:$PATH

RUN go version

#ENV http_proxy 'http://'
#ENV https_proxy 'http://'

RUN mkdir -p $GOPATH/src/github.com/grafana && \
    cd $GOPATH/src/github.com/grafana && pwd && \
    git clone https://github.com/kilimandjango/grafana.git && \
    cd grafana && pwd;

RUN cd $GOPATH/src/github.com/grafana/grafana && \
    go run build.go setup && \
    go run build.go build && \
    npm install -g yarn && \
    yarn install --pure-lockfile && \
    npm run build;

WORKDIR /root/go/src/github.com/grafana/grafana
