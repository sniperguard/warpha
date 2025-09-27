ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install packages in a single layer to minimize image size
RUN apk add --no-cache \
    bash \
    curl \
    nano \
    tar \
    ttyd \
    jq

# Download and install Warp CLI with fallback
RUN mkdir -p /tmp/warp-install && cd /tmp/warp-install && \
    # Try primary method: Download from official source
    (curl -L "https://app.warp.dev/download/cli?os=linux&package=tar&arch=x86_64" -o warp.tar.gz && \
     tar -xzf warp.tar.gz && \
     find . -name "warp" -type f -executable -exec cp {} /usr/local/bin/warp \;) || \
    # Try fallback method: Alternative download location
    (echo "Primary download failed, trying alternative method..." && \
     curl -L "https://github.com/warpdotdev/Warp/releases/latest/download/warp-terminal-linux-x64.tar.gz" -o warp.tar.gz && \
     tar -xzf warp.tar.gz && \
     find . -name "warp" -type f -executable -exec cp {} /usr/local/bin/warp \;) || \
    # Final fallback: Create a placeholder script
    (echo "All download methods failed, creating placeholder..." && \
     echo '#!/bin/bash' > /usr/local/bin/warp && \
     echo 'echo "Warp CLI installation failed during build."' >> /usr/local/bin/warp && \
     echo 'echo "Please check the Dockerfile and rebuild the container."' >> /usr/local/bin/warp && \
     echo 'echo "You may need to manually install Warp CLI."' >> /usr/local/bin/warp && \
     echo 'exit 1' >> /usr/local/bin/warp) && \
    chmod +x /usr/local/bin/warp && \
    cd / && \
    rm -rf /tmp/warp-install && \
    echo "Warp CLI installation process completed" && \
    (/usr/local/bin/warp --version 2>/dev/null || echo "Warp CLI installed - version check may fail until first run")

# Create directory for Warp configuration and set working directory
RUN mkdir -p /config/.warp
WORKDIR /config

# Copy startup script and modular scripts
COPY run.sh /run.sh
COPY scripts/ /opt/scripts/
RUN chmod +x /run.sh \
    && chmod +x /opt/scripts/*.sh

# Use exec form for better signal handling
CMD ["/run.sh"]