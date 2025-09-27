#!/usr/bin/with-contenv bashio

# Initialize environment for Warp CLI
init_environment() {
    # Ensure warp config directory exists for persistent storage
    mkdir -p /config/.warp
    chmod 755 /config/.warp

    # Set environment variables for Warp CLI
    export WARP_CONFIG_DIR="/config/.warp"
    export HOME="/root"
    export PATH="/usr/local/bin:$PATH"
    
    # Ensure .bashrc exists and has Warp environment
    echo 'export WARP_CONFIG_DIR="/config/.warp"' >> /root/.bashrc
    echo 'export PATH="/usr/local/bin:$PATH"' >> /root/.bashrc
    
    bashio::log.info "Warp config directory initialized: /config/.warp"
}

# Verify required tools
verify_tools() {
    bashio::log.info "Verifying required tools..."
    
    # Debug: Show current PATH and check for warp binary
    bashio::log.info "Current PATH: $PATH"
    bashio::log.info "Checking for warp binary..."
    
    # Check if Warp CLI binary exists
    if [ -f "/usr/local/bin/warp" ]; then
        bashio::log.info "Warp CLI binary found at /usr/local/bin/warp"
        
        # Check if it's executable
        if [ -x "/usr/local/bin/warp" ]; then
            bashio::log.info "Warp CLI binary is executable"
        else
            bashio::log.warning "Warp CLI binary is not executable, attempting to fix..."
            chmod +x /usr/local/bin/warp
        fi
        
        # Test if command works
        if command -v warp >/dev/null 2>&1; then
            bashio::log.info "Warp CLI is accessible via command"
        else
            bashio::log.warning "Warp CLI not in PATH, but binary exists"
        fi
    else
        bashio::log.error "Warp CLI binary not found at /usr/local/bin/warp"
        bashio::log.info "Attempting to locate warp binary..."
        find /usr -name "warp" -type f 2>/dev/null || bashio::log.info "No warp binary found in /usr"
        exit 1
    fi
    
    # Check if ttyd is available
    if ! command -v ttyd >/dev/null 2>&1; then
        bashio::log.error "ttyd not found"
        exit 1
    fi
    
    bashio::log.info "All required tools verified successfully"
}

# Setup Warp authentication
setup_warp_auth() {
    # Run Warp authentication setup script
    if [ -f "/opt/scripts/warp_auth.sh" ]; then
        bashio::log.info "Setting up Warp authentication..."
        chmod +x /opt/scripts/warp_auth.sh
        /opt/scripts/warp_auth.sh
    else
        bashio::log.warning "Warp auth script not found, manual authentication may be required"
    fi
}

# Get Warp launch command based on configuration
get_warp_launch_command() {
    local auto_launch_warp
    
    # Get configuration value, default to true for backward compatibility
    auto_launch_warp=$(bashio::config 'auto_launch_warp' 'true')
    
    if [ "$auto_launch_warp" = "true" ]; then
        # Create a welcome script that shows Warp info and provides a shell
        cat > /tmp/warp_welcome.sh << 'EOF'
#!/bin/bash
clear
echo "======================================"
echo "🚀 Welcome to Warp Terminal for HA!"
echo "======================================"
echo ""
echo "Available Warp commands:"
echo "  warp login          - Show welcome message"
echo "  warp agent run      - Simulate AI agent mode"
echo "  warp agent profile  - Show available profiles"
echo "  warp help          - Show all commands"
echo "  warp --version      - Show version info"
echo ""
echo "Environment:"
echo "  WARP_CONFIG_DIR: $WARP_CONFIG_DIR"
echo "  PATH: $PATH"
echo "  Current directory: $(pwd)"
echo ""

# Check if wrapper is working
if warp --version >/dev/null 2>&1; then
    echo "✅ Warp terminal wrapper is ready"
    echo "📁 Navigate to /config for Home Assistant files"
else
    echo "⚠️  Terminal wrapper issue detected"
fi

echo ""
echo "Starting enhanced bash shell..."
echo "💡 Tip: Try 'warp help' for available commands"
echo ""
exec bash
EOF
        chmod +x /tmp/warp_welcome.sh
        echo "/tmp/warp_welcome.sh"
    else
        # Use interactive session picker
        if [ -f "/opt/scripts/warp-session-picker.sh" ]; then
            echo "/opt/scripts/warp-session-picker.sh"
        else
            # Fallback if session picker is missing
            bashio::log.warning "Session picker not found, falling back to auto-launch"
            cat > /tmp/warp_welcome.sh << 'EOF'
#!/bin/bash
exec bash
EOF
            chmod +x /tmp/warp_welcome.sh
            echo "/tmp/warp_welcome.sh"
        fi
    fi
}


# Start main web terminal
start_web_terminal() {
    local port=7681
    bashio::log.info "Starting Warp web terminal on port ${port}..."
    
    # Log environment information for debugging
    bashio::log.info "Environment variables:"
    bashio::log.info "WARP_CONFIG_DIR=${WARP_CONFIG_DIR}"
    bashio::log.info "HOME=${HOME}"
    bashio::log.info "PATH=${PATH}"

    # Get the Warp launch command
    local launch_command
    launch_command=$(get_warp_launch_command)
    
    bashio::log.info "Launch command: ${launch_command}"
    
    # Run ttyd with Warp configuration
    exec ttyd \
        --port "${port}" \
        --interface 0.0.0.0 \
        --writable \
        "$launch_command"
}

# Main execution
main() {
    bashio::log.info "Initializing Warp Terminal add-on..."
    
    init_environment
    verify_tools
    setup_warp_auth
    start_web_terminal
}

# Execute main function
main "$@"