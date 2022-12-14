FROM debian:stable-slim
# Update image
RUN apt update
RUN apt upgrade -y

# Install system tools
RUN apt install -y \
        iputils-ping \
        ca-certificates \
        wget \
        curl \
        git \
        vim \
        nano \
        iperf3 \
        python3 \
        python3-pip \
        mariadb-client

# Install custom tools

## kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" 
RUN curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
RUN echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
RUN install -o root -g root -m 0755 kubectl /bin/kubectl
RUN rm kubectl*
RUN kubectl version --client
ENV KUBECONFIG=/root/.kube/config.yaml

#helm 3
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
RUN helm repo add bitnami https://charts.bitnami.com/bitnami

RUN helm repo update

# Remove APT cache/data
RUN apt-get clean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

ENTRYPOINT [ "bash" ]