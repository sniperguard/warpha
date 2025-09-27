# Warp Terminal for Home Assistant

A powerful, web-based terminal with Warp CLI pre-installed for Home Assistant.

![Warp Terminal Screenshot](https://github.com/heytcass/home-assistant-addons/raw/main/claude-terminal/screenshot.png)

*Warp Terminal running in Home Assistant*

## What is Warp Terminal?

This add-on provides a web-based terminal interface with Warp CLI pre-installed, allowing you to use Warp's powerful AI agents directly from your Home Assistant dashboard. It gives you direct access to Warp's AI-powered terminal agents, ideal for:

- Running AI agents to automate tasks
- Debugging Home Assistant issues with AI assistance
- Managing your smart home configuration with AI help
- Learning and coding with AI agent support
- Integrating with MCP servers for enhanced capabilities

## Features

- **Web Terminal Interface**: Access Warp agents through a browser-based terminal using ttyd
- **AI Agent Integration**: Run powerful AI agents with natural language prompts
- **Interactive Session Picker**: Choose between different Warp operations or direct shell access
- **Latest Warp CLI**: Pre-installed with Warp's official CLI
- **Simple Authentication**: Uses `warp login` browser-based authentication
- **Direct Config Access**: Terminal starts in your `/config` directory for immediate access to all Home Assistant files
- **Home Assistant Integration**: Access directly from your dashboard
- **Panel Icon**: Quick access from the sidebar with the robot icon
- **Multi-Architecture Support**: Works on amd64, aarch64, and armv7 platforms
- **MCP Server Support**: Integrate with Model Context Protocol servers
- **Agent Profiles**: Customize agent behavior and permissions
- **Secure Credential Management**: Persistent authentication with safe credential storage

## Quick Start

The terminal provides easy access to Warp AI agents. You can immediately start using commands like:

```bash
# Authenticate with Warp (first-time setup)
warp login

# Run an AI agent with a natural language prompt
warp agent run --prompt "Fix the bug in my Home Assistant automation"

# List available agent profiles
warp agent profile list

# List MCP servers
warp mcp list

# Get help with available commands
warp help

# Use the interactive session picker
# (available when auto-launch is disabled in addon config)
```

## Installation

1. Add this repository to your Home Assistant add-on store
2. Install the Warp Terminal add-on
3. Start the add-on
4. Click "OPEN WEB UI" or the sidebar icon to access
5. On first use, run `warp login` and follow the browser-based authentication

## Configuration

The add-on has minimal configuration options:

- **Port**: Web interface runs on port 7681
- **Authentication**: Browser-based OAuth with Warp (credentials stored securely in `/config/.warp/`)
- **Terminal**: Full bash environment with Warp CLI pre-installed
- **Volumes**: Access to both `/config` (Home Assistant) and `/addons` (for development)
- **Auto-launch Warp Shell**: Enable/disable automatic shell launch vs. interactive session picker

## Troubleshooting

### Authentication Issues
If you have authentication problems:
```bash
warp login           # Re-authenticate with Warp
```

### Container Issues
- Credentials are automatically saved and restored between restarts
- Check add-on logs if the terminal doesn't load
- Restart the add-on if Warp commands aren't recognized
- Verify Warp CLI is available: `warp --version`

### Development
For local development and testing:
```bash
# Enter development environment
nix develop

# Build and test locally
build-addon
run-addon

# Lint and validate
lint-dockerfile
test-endpoint
```

## Architecture

- **Base Image**: Home Assistant Alpine Linux base (3.19)
- **Container Runtime**: Compatible with Docker/Podman
- **Web Terminal**: ttyd for browser-based access
- **Process Management**: s6-overlay for reliable service startup
- **Networking**: Ingress support with Home Assistant reverse proxy

## Security

Version 1.0.2 includes important security improvements:
- ✅ **Secure Credential Management**: Limited filesystem access to safe directories only
- ✅ **Safe Cleanup Operations**: No more dangerous system-wide file deletions
- ✅ **Proper Permission Handling**: Consistent file permissions (600) for credentials
- ✅ **Input Validation**: Enhanced error checking and bounds validation

## Development Environment

This add-on includes a comprehensive development setup using Nix:

```bash
# Available development commands
build-addon      # Build the add-on container with Podman
run-addon        # Run add-on locally on port 7681
lint-dockerfile  # Lint Dockerfile with hadolint
test-endpoint    # Test web endpoint availability
```

**Requirements for development:**
- NixOS or Nix package manager
- Podman (automatically provided in dev shell)
- Optional: direnv for automatic environment activation

## Documentation

For detailed usage instructions, see the [documentation](DOCS.md).

## Version History

### v2.0.0 (Current) - Major Migration to Warp CLI
- 🚀 **BREAKING**: Migrated from Claude Code CLI to Warp CLI
- 🤖 AI Agent integration with natural language prompts
- 🔧 MCP server support for enhanced capabilities
- 👤 Agent profile management
- 🎯 Interactive session picker
- 🔒 Browser-based authentication with Warp
- 📱 Updated UI branding and icons

### v1.0.2 - Security & Bug Fix Release (Claude CLI)
- 🔒 **CRITICAL**: Fixed dangerous filesystem operations
- 🐛 Added missing armv7 architecture support
- 🔧 Pinned NPM packages and improved error handling
- 🛠️ Enhanced development environment with Podman support

## Useful Links

- [Warp CLI Documentation](https://docs.warp.dev/developers/cli)
- [Warp Official Website](https://www.warp.dev/)
- [MCP Servers](https://docs.warp.dev/knowledge-and-collaboration/mcp)
- [Home Assistant Add-ons](https://www.home-assistant.io/addons/)

## Credits

This add-on was migrated from Claude Terminal to Warp Terminal to provide enhanced AI agent capabilities. The migration demonstrates the power of AI-assisted development - exactly what this add-on now enables through Warp's AI agents.

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.