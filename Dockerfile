FROM registry.access.redhat.com/rhel7:7.4

MAINTAINER Kilian Henneboehle "kilian.henneboehle@mailbox.org"

ENV GOROOT=/usr/local/go \
    NODEJS_VERSION=8 \
    NPM_RUN=start \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH="$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$GOROOT/bin:$PATH"

RUN set -x && \
    yum clean all && \
    yum list updates && \
    yum -y update
  
RUN yum-config-manager \
    --enable "rhel-server-rhscl-7-rpms" \
    --enable "rhel-7-server-rpms" \
    --enable "rhel-7-server-extras-rpms"

#RUN INSTALL_PKGS="wget initscripts curl tar gcc libc6-dev git rh-nodejs8 bzip2 bzip2-libs"
RUN INSTALL_PKGS="wget initscripts curl tar gcc libc6-dev git rh-nodejs8 bzip2 bzip2-libs" && \
    yum install -y --nogpgcheck ${INSTALL_PKGS} && \
    yum -y update && \
    yum clean all

RUN wget https://dl.google.com/go/go1.9.7.linux-amd64.tar.gz && \
    tar -C /usr/local/ -xvf go1.9.7.linux-amd64.tar.gz

RUN go version

RUN source /opt/rh/rh-nodejs8/enable && npm --version;

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
