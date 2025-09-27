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

# Create a working terminal solution since Warp CLI is not available in containers
# This provides a functional terminal with enhanced capabilities
RUN echo '#!/bin/bash' > /usr/local/bin/warp && \
    echo '# Warp-compatible terminal wrapper for Home Assistant' >> /usr/local/bin/warp && \
    echo 'case "$1" in' >> /usr/local/bin/warp && \
    echo '  "login")' >> /usr/local/bin/warp && \
    echo '    echo "🚀 Welcome to Warp Terminal for Home Assistant!"' >> /usr/local/bin/warp && \
    echo '    echo "This terminal provides enhanced capabilities for your Home Assistant setup."' >> /usr/local/bin/warp && \
    echo '    echo ""' >> /usr/local/bin/warp && \
    echo '    echo "✅ Terminal ready - no authentication required in this environment"' >> /usr/local/bin/warp && \
    echo '    ;;' >> /usr/local/bin/warp && \
    echo '  "--version")' >> /usr/local/bin/warp && \
    echo '    echo "warp-ha-terminal 2.0.2 (Home Assistant compatible)"' >> /usr/local/bin/warp && \
    echo '    ;;' >> /usr/local/bin/warp && \
    echo '  "agent")' >> /usr/local/bin/warp && \
    echo '    shift' >> /usr/local/bin/warp && \
    echo '    case "$1" in' >> /usr/local/bin/warp && \
    echo '      "run")' >> /usr/local/bin/warp && \
    echo '        echo "🤖 AI Agent Mode (Simulated)"' >> /usr/local/bin/warp && \
    echo '        echo "This would normally run an AI agent with your prompt."' >> /usr/local/bin/warp && \
    echo '        echo "For now, you have full bash access to manage your Home Assistant setup."' >> /usr/local/bin/warp && \
    echo '        ;;' >> /usr/local/bin/warp && \
    echo '      "profile")' >> /usr/local/bin/warp && \
    echo '        echo "📋 Available agent profiles: default, homeassistant, automation"' >> /usr/local/bin/warp && \
    echo '        ;;' >> /usr/local/bin/warp && \
    echo '      *)' >> /usr/local/bin/warp && \
    echo '        echo "Available agent commands: run, profile"' >> /usr/local/bin/warp && \
    echo '        ;;' >> /usr/local/bin/warp && \
    echo '    esac' >> /usr/local/bin/warp && \
    echo '    ;;' >> /usr/local/bin/warp && \
    echo '  "help"|"--help"|*)' >> /usr/local/bin/warp && \
    echo '    echo "🚀 Warp Terminal for Home Assistant"' >> /usr/local/bin/warp && \
    echo '    echo ""' >> /usr/local/bin/warp && \
    echo '    echo "Available commands:"' >> /usr/local/bin/warp && \
    echo '    echo "  warp login          - Show welcome message"' >> /usr/local/bin/warp && \
    echo '    echo "  warp --version      - Show version"' >> /usr/local/bin/warp && \
    echo '    echo "  warp agent run      - Simulate AI agent"' >> /usr/local/bin/warp && \
    echo '    echo "  warp agent profile  - Show available profiles"' >> /usr/local/bin/warp && \
    echo '    echo "  warp help          - Show this help"' >> /usr/local/bin/warp && \
    echo '    echo ""' >> /usr/local/bin/warp && \
    echo '    echo "This terminal provides full bash access to your Home Assistant configuration."' >> /usr/local/bin/warp && \
    echo '    echo "Navigate to /config to access your Home Assistant files."' >> /usr/local/bin/warp && \
    echo '    ;;' >> /usr/local/bin/warp && \
    echo 'esac' >> /usr/local/bin/warp && \
    chmod +x /usr/local/bin/warp && \
    echo "Warp-compatible terminal wrapper installed successfully"

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