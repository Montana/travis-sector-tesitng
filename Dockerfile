# Start with a base image with Ubuntu 16.04
FROM ubuntu:16.04

# Maintainer
LABEL maintainer="montana@travis-ci.org"

# Set environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    software-properties-common \
    build-essential \
    git \
    mercurial \
    docker \
    jq \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Ruby
RUN apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y ruby2.6 ruby2.6-dev && \
    gem install bundler --no-document

# Install Python
RUN apt-get update
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip    

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs

# Install Java
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk

# Install additional languages, databases, and services here as needed

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up the user environment
RUN useradd -m -s /bin/bash travis && \
    echo "travis ALL=NOPASSWD: ALL" > /etc/sudoers.d/travis && \
    chmod 0440 /etc/sudoers.d/travis

# Switch to user
USER travis

# Set work directory
WORKDIR /home/travis

# Entrypoint
CMD ["/bin/bash"]
