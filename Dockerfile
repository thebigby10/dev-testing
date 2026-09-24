FROM ubuntu:22.04

# Avoid interactive prompts during apt install
ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server, sudo, and basic tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH directory
RUN mkdir /var/run/sshd

# Copy entrypoint script and ssh config
COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose standard SSH port (22) and an example app port (e.g., 8080)
EXPOSE 22 8080

ENTRYPOINT ["/entrypoint.sh"]
