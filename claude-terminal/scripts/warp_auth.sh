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
    # Check if Warp terminal wrapper exists and is executable
    if [ ! -f "/usr/local/bin/warp" ]; then
        bashio::log.error "Warp terminal wrapper not found at /usr/local/bin/warp"
        return 1
    fi
    
    if [ ! -x "/usr/local/bin/warp" ]; then
        bashio::log.error "Warp terminal wrapper is not executable"
        return 1
    fi
    
    # Check if Warp terminal wrapper is working
    if /usr/local/bin/warp --version >/dev/null 2>&1; then
        bashio::log.info "Warp terminal wrapper is available and working"
        bashio::log.info "Terminal ready - authentication not required for local wrapper"
        return 0
    else
        bashio::log.error "Warp terminal wrapper is not working properly"
        # Show more debug info
        bashio::log.info "Debug: Warp wrapper output:"
        /usr/local/bin/warp --version 2>&1 || bashio::log.info "Warp wrapper failed to run"
        return 1
    fi
}

setup_warp_auth() {
    bashio::log.info "Setting up Warp terminal wrapper..."
    bashio::log.info "The terminal wrapper is ready to use - no authentication required"
    bashio::log.info "You can use commands like 'warp help' to see available options"
    
    # No authentication needed for the local wrapper
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