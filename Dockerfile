FROM ubuntu:14.04

ENV ETCDCTL_VERSION v2.2.4
ENV ETCDCTL_ARCH linux-amd64
ENV KVIATOR_VERSION 0.0.7
ENV CONFD_VERSION 0.10.0
ENV KUBECTL_VERSION v1.2.4

# Download kviator( manages data across distributed key value stores (consul, etcd) )
ADD https://github.com/AcalephStorage/kviator/releases/download/v${KVIATOR_VERSION}/kviator-${KVIATOR_VERSION}-linux-amd64.zip /kviator.zip

# Download conf
ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 /usr/local/bin/confd

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y wget unzip uuid-runtime python-setuptools udev runit sharutils python3 && \
\
# Install glusterfs 
  apt-get update && apt-get install -y software-properties-common && \
  add-apt-repository ppa:gluster/glusterfs-3.8 && \
  apt-get update && apt-get install -y glusterfs-server && \
\
# Install kviator
  cd /usr/local/bin && unzip /kviator.zip && chmod +x /usr/local/bin/kviator && rm /kviator.zip && \
\
# Install etcdctl
  wget -q -O- "https://github.com/coreos/etcd/releases/download/${ETCDCTL_VERSION}/etcd-${ETCDCTL_VERSION}-${ETCDCTL_ARCH}.tar.gz" |tar xfz - -C/tmp/ etcd-${ETCDCTL_VERSION}-${ETCDCTL_ARCH}/etcdctl && \
  mv /tmp/etcd-${ETCDCTL_VERSION}-${ETCDCTL_ARCH}/etcdctl /usr/local/bin/etcdctl && \
\
# Install conf
  chmod +x /usr/local/bin/confd && mkdir -p /etc/confd/conf.d && mkdir -p /etc/confd/templates

# Install kubectl
ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

# JSON Processor
ADD https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

