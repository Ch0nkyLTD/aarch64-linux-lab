# Base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    vim \
    tmux \
    git \
    zsh \
    binutils \
    gcc \
    tcpdump \
    inetsim \
    socat \
    netcat \
    python3-pip \
    python3-venv \
    curl \
    wget \
    ipython3 \
    gdb \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install mitmproxy
RUN pip3 install mitmproxy

# Create a non-root user
RUN useradd -m -s /bin/zsh analyst
RUN usermod -aG sudo analyst
RUN echo "analyst ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Install oh-my-zsh for analyst user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Switch to analyst user for oh-my-zsh configuration
USER analyst
WORKDIR /home/analyst


# Configure oh-my-zsh with darkblood theme
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="darkblood"/' ~/.zshrc

# install pwndebug 
RUN git clone https://github.com/pwndbg/pwndbg && ./pwndbg/setup.sh


# Switch back to root for any additional configuration
USER root

# Create necessary directories
RUN mkdir -p /samples /data

# Set permissions
RUN chown -R analyst:analyst /samples /data
user analyst

# Default command
CMD ["zsh"]
