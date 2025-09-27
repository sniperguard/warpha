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

# Download and install Warp CLI
RUN curl -L "https://app.warp.dev/download/cli?os=linux&package=tar&arch=x86_64" \
    | tar -xz -C /usr/local/bin --strip-components=1 \
    && chmod +x /usr/local/bin/warp \
    && /usr/local/bin/warp --version || echo "Warp CLI installed"

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