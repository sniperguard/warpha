#!/usr/bin/with-contenv bashio

# Warp Authentication Helper Script
# Manages Warp CLI authentication and configuration

init_warp_config() {
    # Ensure warp config directory exists with proper permissions
    mkdir -p /config/.warp
    chmod 755 /config/.warp
    
    # Set environment variables for Warp CLI
    export WARP_CONFIG_DIR="/config/.warp"
    export HOME="/root"
    
    bashio::log.info "Warp config directory initialized: /config/.warp"
}

check_warp_auth() {
    # Check if Warp CLI binary exists and is executable
    if [ ! -f "/usr/local/bin/warp" ]; then
        bashio::log.error "Warp CLI binary not found at /usr/local/bin/warp"
        return 1
    fi
    
    if [ ! -x "/usr/local/bin/warp" ]; then
        bashio::log.error "Warp CLI binary is not executable"
        return 1
    fi
    
    # Check if Warp CLI is available and working
    if /usr/local/bin/warp --version >/dev/null 2>&1; then
        bashio::log.info "Warp CLI is available and working"
        
        # Try to check auth status (this may vary based on actual Warp CLI implementation)
        if /usr/local/bin/warp auth status >/dev/null 2>&1; then
            bashio::log.info "Warp CLI is authenticated"
            return 0
        else
            bashio::log.warning "Warp CLI needs authentication"
            return 1
        fi
    else
        bashio::log.error "Warp CLI is not working properly"
        # Show more debug info
        bashio::log.info "Debug: Warp CLI output:"
        /usr/local/bin/warp --version 2>&1 || bashio::log.info "Warp CLI failed to run"
        return 1
    fi
}

setup_warp_auth() {
    bashio::log.info "Setting up Warp authentication..."
    bashio::log.info "Please use the web terminal to run: warp login"
    bashio::log.info "This will provide a URL to authenticate with Warp"
    
    # We don't automatically run warp login here because it requires interactive input
    # Instead, we'll let the user run it in the terminal
    return 0
}

# Main execution
main() {
    bashio::log.info "Initializing Warp authentication..."
    
    init_warp_config
    
    if ! check_warp_auth; then
        setup_warp_auth
    fi
    
    # Export environment variables for the session
    echo "export WARP_CONFIG_DIR=\"/config/.warp\"" >> /root/.bashrc
    echo "export PATH=\"/usr/local/bin:\$PATH\"" >> /root/.bashrc
    
    bashio::log.info "Warp authentication setup complete"
}

# Execute main function
main "$@"