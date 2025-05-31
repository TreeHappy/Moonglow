# Use the latest Alpine Linux base
FROM alpine:edge

# Install system dependencies
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    bash \
    curl \
    git \
    nodejs \
    npm \
    python3 \
    py3-pip \
    cargo \
    make \
    g++ \
    cmake

# Install Rust tools via cargo
RUN cargo install starship difftastic

# Install latest Neovim from edge repository
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    neovim

# Install core utilities
RUN apk add --no-cache \
    ripgrep \
    fd \
    fzf \
    zoxide

# Install moon monorepo via npm
RUN npm install -g @moonrepo/cli

# Install jj (just-jitting) version control system
RUN curl -L https://github.com/martinvonz/jj/releases/latest/download/jj-linux-x86_64 -o /usr/bin/jj && \
    chmod +x /usr/bin/jj

# Install mergiraf (Git merge conflict resolver)
RUN curl -L https://github.com/psmitt/mergiraf/releases/latest/download/mergiraf-linux-amd64 -o /usr/bin/mergiraf && \
    chmod +x /usr/bin/mergiraf

# Create non-root user
RUN adduser -D -s /bin/bash developer
USER developer
WORKDIR /home/developer

# Configure starship
RUN mkdir -p /home/developer/.config && \
    sh -c "$(starship init bash)" > /home/developer/.config/starship.bash && \
    echo 'eval "$(starship init bash)"' >> /home/developer/.bashrc

# Set default shell to bash with enhancements
SHELL ["/bin/bash", "-c"]
RUN echo 'eval "$(zoxide init bash)"' >> /home/developer/.bashrc && \
    echo 'source /usr/share/fzf/key-bindings.bash' >> /home/developer/.bashrc && \
    echo 'source /usr/share/fzf/completion.bash' >> /home/developer/.bashrc

# Verify installations
RUN nvim --version && \
    moon --version && \
    rg --version && \
    fd --version && \
    starship --version && \
    jj --version && \
    mergiraf --version && \
    difft --version

# Set entrypoint
CMD ["/bin/bash"]

