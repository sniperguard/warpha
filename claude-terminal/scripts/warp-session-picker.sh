#!/bin/bash

# Warp Session Picker - Interactive menu for choosing Warp agent workflow
# Provides options for different Warp CLI operations and shell access

show_banner() {
    clear
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 Warp Terminal                          ║"
    echo "║                   AI Agent Session Picker                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

show_menu() {
    echo "Choose your Warp action:"
    echo ""
    echo "  1) 🔐 Login to Warp (authenticate)"
    echo "  2) 🤖 Run AI agent with prompt"
    echo "  3) 📋 List agent profiles"
    echo "  4) 🔧 List MCP servers"
    echo "  5) ⚙️  Custom Warp command"
    echo "  6) 🐚 Drop to bash shell"
    echo "  7) ❓ Show Warp help"
    echo "  8) ❌ Exit"
    echo ""
}

get_user_choice() {
    local choice
    # Send prompt to stderr to avoid capturing it with the return value
    printf "Enter your choice [1-8] (default: 6): " >&2
    read -r choice
    
    # Default to 6 (bash shell) if empty
    if [ -z "$choice" ]; then
        choice=6
    fi
    
    # Trim whitespace and return only the choice
    choice=$(echo "$choice" | tr -d '[:space:]')
    echo "$choice"
}

launch_warp_login() {
    echo "🔐 Starting Warp authentication..."
    echo "This will open a browser URL for authentication"
    sleep 1
    exec warp login
}

launch_warp_agent() {
    echo ""
    echo "Enter your prompt for the AI agent:"
    echo "Example: 'Fix the bug in my Python code' or 'Set up a new React project'"
    echo -n "> "
    read -r prompt
    
    if [ -z "$prompt" ]; then
        echo "No prompt provided. Returning to menu..."
        return
    else
        echo "🤖 Running AI agent with prompt: $prompt"
        sleep 1
        exec warp agent run --prompt "$prompt"
    fi
}

list_agent_profiles() {
    echo "📋 Listing available agent profiles..."
    sleep 1
    warp agent profile list
    echo ""
    echo "Press Enter to continue..."
    read -r
}

list_mcp_servers() {
    echo "🔧 Listing MCP servers..."
    sleep 1
    warp mcp list
    echo ""
    echo "Press Enter to continue..."
    read -r
}

launch_warp_custom() {
    echo ""
    echo "Enter your Warp command (e.g., 'agent run --prompt \"hello\"' or 'help'):"
    echo "Available commands: login, agent, mcp, help"
    echo -n "> warp "
    read -r custom_args
    
    if [ -z "$custom_args" ]; then
        echo "No arguments provided. Dropping to shell..."
        launch_bash_shell
    else
        echo "🚀 Running: warp $custom_args"
        sleep 1
        # Use eval to properly handle quoted arguments
        eval "exec warp $custom_args"
    fi
}

launch_bash_shell() {
    echo "🐚 Dropping to bash shell..."
    echo "Tip: Warp CLI commands available:"
    echo "  - warp login"
    echo "  - warp agent run --prompt \"your prompt\""
    echo "  - warp help"
    sleep 2
    exec bash
}

show_warp_help() {
    echo "❓ Showing Warp help..."
    sleep 1
    warp help
    echo ""
    echo "Press Enter to continue..."
    read -r
}

exit_session_picker() {
    echo "👋 Goodbye!"
    exit 0
}

# Main execution flow
main() {
    while true; do
        show_banner
        show_menu
        choice=$(get_user_choice)
        
        case "$choice" in
            1)
                launch_warp_login
                ;;
            2)
                launch_warp_agent
                ;;
            3)
                list_agent_profiles
                ;;
            4)
                list_mcp_servers
                ;;
            5)
                launch_warp_custom
                ;;
            6)
                launch_bash_shell
                ;;
            7)
                show_warp_help
                ;;
            8)
                exit_session_picker
                ;;
            *)
                echo ""
                echo "❌ Invalid choice: '$choice'"
                echo "Please select a number between 1-8"
                echo ""
                printf "Press Enter to continue..." >&2
                read -r
                ;;
        esac
    done
}

# Handle cleanup on exit
trap 'exit_session_picker' EXIT INT TERM

# Run main function
main "$@"