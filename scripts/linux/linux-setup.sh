#!/bin/bash

#===============================================================================
# Script: linux-setup.sh
# Purpose: Automated development environment setup for fresh Linux machines
# Supports: Ubuntu/Debian, Fedora, Arch (with detection)
# Author: Dev Launchpad
# Version: 2.0.0
#===============================================================================

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Configuration
readonly SETUP_DIR="$HOME/.dev-setup"
readonly LOG_FILE="$SETUP_DIR/setup-$(date +%Y%m%d_%H%M%S).log"
readonly BACKUP_DIR="$SETUP_DIR/backups"

# Package selections (modify as needed)
INSTALL_GIT=true
INSTALL_NODE=true
INSTALL_PYTHON=true
INSTALL_DOCKER=true
INSTALL_ZSH=true
INSTALL_VSCODE=false
INSTALL_JETBRAINS=false
INSTALL_CHROME=false

# Versions
NODE_VERSION="${NODE_VERSION:-lts}"  # lts, latest, or specific (20, 18, etc.)
PYTHON_VERSION="${PYTHON_VERSION:-3.11}"
ZSH_THEME="${ZSH_THEME:-robbyrussell}"

# Non-interactive mode for CI/automation
NON_INTERACTIVE=false
SKIP_UPDATES=false

#===============================================================================
# Functions
#===============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE" >&2
}

log_step() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "" | tee -a "$LOG_FILE"
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Automated development environment setup for Linux.

OPTIONS:
    -h, --help          Show this help message
    -y, --yes           Non-interactive mode (answer yes to all)
    --minimal           Install only: git, zsh, basic tools
    --full              Install everything including IDEs
    --no-update         Skip system package update (faster)
    --node VERSION      Specify Node version (lts, 20, 18, latest)
    --python VERSION    Specify Python version (3.11, 3.12, etc.)
    --skip-docker       Skip Docker installation
    --skip-zsh          Skip Zsh/Oh-My-Zsh setup

COMPONENTS:
    ✓ Git + configuration
    ✓ Node.js (via nvm) + npm/yarn/pnpm
    ✓ Python + pip + virtualenv
    ✓ Docker + Docker Compose
    ✓ Zsh + Oh-My-Zsh + plugins
    ✓ Common dev tools (curl, wget, jq, etc.)

SUPPORTED DISTROS:
    - Ubuntu 20.04+ / Debian 11+
    - Fedora 35+
    - Arch Linux / Manjaro

EXAMPLES:
    $(basename "$0")                    # Interactive setup
    $(basename "$0") -y --minimal       # Quick minimal setup
    $(basename "$0") --node 20 --full   # Full setup with Node 20

EOF
}

# Detect Linux distribution
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    elif command -v lsb_release &> /dev/null; then
        lsb_release -is | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Get package manager
get_package_manager() {
    local distro="$1"
    case "$distro" in
        ubuntu|debian|pop)
            echo "apt"
            ;;
        fedora|rhel|centos)
            echo "dnf"
            ;;
        arch|manjaro)
            echo "pacman"
            ;;
        *)
            log_error "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
}

# Update package lists
update_packages() {
    if [[ "$SKIP_UPDATES" == true ]]; then
        log_warn "Skipping system update (--no-update)"
        return 0
    fi
    
    log_step "Updating System Packages"
    
    case "$PKG_MANAGER" in
        apt)
            sudo apt-get update
            sudo apt-get upgrade -y
            ;;
        dnf)
            sudo dnf update -y
            ;;
        pacman)
            sudo pacman -Syu --noconfirm
            ;;
    esac
    
    log_success "System updated"
}

# Install base packages
install_base_packages() {
    log_step "Installing Base Tools"
    
    local packages=""
    case "$PKG_MANAGER" in
        apt)
            packages="curl wget git vim nano htop tree jq unzip zip build-essential software-properties-common apt-transport-https ca-certificates gnupg lsb-release"
            sudo apt-get install -y $packages
            ;;
        dnf)
            packages="curl wget git vim nano htop tree jq unzip zip gcc gcc-c++ make dnf-plugins-core"
            sudo dnf install -y $packages
            ;;
        pacman)
            packages="curl wget git vim nano htop tree jq unzip zip base-devel"
            sudo pacman -S --noconfirm $packages
            ;;
    esac
    
    log_success "Base packages installed"
}

# Install and configure Git
setup_git() {
    [[ "$INSTALL_GIT" == false ]] && return 0
    
    log_step "Setting Up Git"
    
    if ! command_exists git; then
        case "$PKG_MANAGER" in
            apt) sudo apt-get install -y git ;;
            dnf) sudo dnf install -y git ;;
            pacman) sudo pacman -S --noconfirm git ;;
        esac
    fi
    
    # Configure git if not already set
    if [[ -z "$(git config --global user.name 2>/dev/null)" ]]; then
        if [[ "$NON_INTERACTIVE" == false ]]; then
            read -rp "Enter your Git name: " git_name
            read -rp "Enter your Git email: " git_email
        else
            git_name="${GIT_NAME:-Developer}"
            git_email="${GIT_EMAIL:-dev@localhost}"
        fi
        
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
        git config --global init.defaultBranch main
        git config --global core.editor "vim"
        git config --global pull.rebase false
        
        log_success "Git configured: $git_name <$git_email>"
    else
        log_info "Git already configured: $(git config --global user.name) <$(git config --global user.email)>"
    fi
    
    # Generate SSH key if doesn't exist
    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
        log_info "Generating SSH key..."
        mkdir -p "$HOME/.ssh"
        ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f "$HOME/.ssh/id_ed25519" -N ""
        eval "$(ssh-agent -s)"
        ssh-add "$HOME/.ssh/id_ed25519"
        log_success "SSH key generated at ~/.ssh/id_ed25519.pub"
        log_info "Add this key to GitHub/GitLab:"
        cat "$HOME/.ssh/id_ed25519.pub"
    fi
}

# Install Node.js via nvm
setup_node() {
    [[ "$INSTALL_NODE" == false ]] && return 0
    
    log_step "Setting Up Node.js"
    
    # Install nvm if not present
    if [[ ! -d "$HOME/.nvm" ]]; then
        log_info "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        
        # Source nvm
        export NVM_DIR="$HOME/.nvm"
        # shellcheck source=/dev/null
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    else
        export NVM_DIR="$HOME/.nvm"
        # shellcheck source=/dev/null
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        log_info "nvm already installed"
    fi
    
    # Install Node
    log_info "Installing Node.js $NODE_VERSION..."
    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
    nvm alias default "$NODE_VERSION"
    
    # Install global packages
    log_info "Installing global npm packages..."
    npm install -g npm@latest
    npm install -g yarn pnpm typescript ts-node nodemon pm2 eslint prettier
    
    # Verify
    log_success "Node.js $(node --version) installed"
    log_success "npm $(npm --version) installed"
    log_info "Global packages: yarn, pnpm, typescript, ts-node, nodemon, pm2, eslint, prettier"
}

# Install Python
setup_python() {
    [[ "$INSTALL_PYTHON" == false ]] && return 0
    
    log_step "Setting Up Python"
    
    case "$PKG_MANAGER" in
        apt)
            sudo apt-get install -y "python$PYTHON_VERSION" "python$PYTHON_VERSION-venv" "python$PYTHON_VERSION-dev" python3-pip
            ;;
        dnf)
            sudo dnf install -y "python$PYTHON_VERSION" python3-pip python3-virtualenv
            ;;
        pacman)
            sudo pacman -S --noconfirm python python-pip python-virtualenv
            ;;
    esac
    
    # Ensure pip is up to date
    python3 -m pip install --upgrade pip setuptools wheel
    
    # Install common tools
    pip3 install --user virtualenvwrapper pipenv poetry black flake8 pytest ipython
    
    # Configure
    mkdir -p "$HOME/.virtualenvs"
    
    # Add to shell config
    if ! grep -q "WORKON_HOME" "$HOME/.bashrc" 2>/dev/null; then
        {
            echo ""
            echo "# Python virtualenvwrapper"
            echo "export WORKON_HOME=$HOME/.virtualenvs"
            echo "export VIRTUALENVWRAPPER_PYTHON=$(which python3)"
            echo "source $(which virtualenvwrapper.sh)"
        } >> "$HOME/.bashrc"
    fi
    
    log_success "Python $PYTHON_VERSION configured"
    log_info "Tools installed: virtualenvwrapper, pipenv, poetry, black, flake8, pytest"
}

# Install Docker
setup_docker() {
    [[ "$INSTALL_DOCKER" == false ]] && return 0
    
    log_step "Setting Up Docker"
    
    if command_exists docker; then
        log_info "Docker already installed: $(docker --version)"
    else
        case "$PKG_MANAGER" in
            apt)
                # Add Docker's official GPG key
                sudo install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                sudo chmod a+r /etc/apt/keyrings/docker.gpg
                
                # Add repository
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                
                sudo apt-get update
                sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                ;;
            dnf)
                sudo dnf -y install dnf-plugins-core
                sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
                sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
                ;;
            pacman)
                sudo pacman -S --noconfirm docker docker-compose
                ;;
        esac
        
        # Start and enable Docker
        sudo systemctl start docker
        sudo systemctl enable docker
        
        # Add user to docker group
        sudo usermod -aG docker "$USER"
        log_warn "Added $USER to docker group. Please log out and back in for this to take effect."
    fi
    
    # Install Docker Compose (standalone) as backup
    if ! command_exists docker-compose; then
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    
    log_success "Docker $(docker --version) installed"
    log_success "Docker Compose $(docker-compose --version) installed"
}

# Install and configure Zsh
setup_zsh() {
    [[ "$INSTALL_ZSH" == false ]] && return 0
    
    log_step "Setting Up Zsh"
    
    # Install zsh
    if ! command_exists zsh; then
        case "$PKG_MANAGER" in
            apt) sudo apt-get install -y zsh ;;
            dnf) sudo dnf install -y zsh ;;
            pacman) sudo pacman -S --noconfirm zsh ;;
        esac
    fi
    
    # Install Oh-My-Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Change default shell
        sudo chsh -s "$(which zsh)" "$USER"
    else
        log_info "Oh-My-Zsh already installed"
    fi
    
    # Install plugins
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # zsh-autosuggestions
    if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    fi
    
    # zsh-syntax-highlighting
    if [[ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
    fi
    
    # Configure .zshrc
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc" 2>/dev/null || true
    sed -i "s/ZSH_THEME=.*/ZSH_THEME=\"$ZSH_THEME\"/" "$HOME/.zshrc" 2>/dev/null || true
    
    # Add useful aliases
    if ! grep -q "# Custom aliases" "$HOME/.zshrc" 2>/dev/null; then
        cat >> "$HOME/.zshrc" << 'EOF'

# Custom aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias gp='git pull'
alias gl='git log --oneline --graph'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF
    fi
    
    log_success "Zsh configured with Oh-My-Zsh"
    log_info "Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting"
    log_warn "Please restart your terminal or run 'zsh' to start using it"
}

# Install VS Code
setup_vscode() {
    [[ "$INSTALL_VSCODE" == false ]] && return 0
    
    log_step "Setting Up VS Code"
    
    if command_exists code; then
        log_info "VS Code already installed"
        return 0
    fi
    
    case "$PKG_MANAGER" in
        apt)
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
            sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm -f packages.microsoft.gpg
            sudo apt update
            sudo apt install -y code
            ;;
        dnf)
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
            sudo dnf check-update
            sudo dnf install -y code
            ;;
        pacman)
            sudo pacman -S --noconfirm code
            ;;
    esac
    
    log_success "VS Code installed"
}

# Create summary
create_summary() {
    log_step "Setup Complete!"
    
    local summary_file="$SETUP_DIR/summary-$TIMESTAMP.txt"
    
    {
        echo "Development Environment Setup Summary"
        echo "Date: $(date)"
        echo "Distribution: $DISTRO"
        echo ""
        echo "Installed Components:"
        command_exists git && echo "  ✓ Git $(git --version)"
        command_exists node && echo "  ✓ Node.js $(node --version) / npm $(npm --version)"
        command_exists python3 && echo "  ✓ Python $(python3 --version)"
        command_exists docker && echo "  ✓ Docker $(docker --version)"
        command_exists zsh && echo "  ✓ Zsh $(zsh --version)"
        command_exists code && echo "  ✓ VS Code"
        echo ""
        echo "Configuration Files:"
        echo "  - Log: $LOG_FILE"
        echo "  - Backup: $BACKUP_DIR"
        echo ""
        echo "Next Steps:"
        echo "  1. Restart your terminal or run: exec zsh"
        echo "  2. Verify Docker: docker run hello-world"
        echo "  3. Add SSH key to GitHub: ~/.ssh/id_ed25519.pub"
        echo "  4. Customize ~/.zshrc with your preferences"
    } | tee "$summary_file"
    
    log_info "Summary saved to: $summary_file"
}

#===============================================================================
# Main
#===============================================================================

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -y|--yes)
                NON_INTERACTIVE=true
                shift
                ;;
            --minimal)
                INSTALL_DOCKER=false
                INSTALL_PYTHON=false
                INSTALL_NODE=false
                shift
                ;;
            --full)
                INSTALL_VSCODE=true
                INSTALL_JETBRAINS=true
                INSTALL_CHROME=true
                shift
                ;;
            --no-update)
                SKIP_UPDATES=true
                shift
                ;;
            --node)
                NODE_VERSION="$2"
                shift 2
                ;;
            --python)
                PYTHON_VERSION="$2"
                shift 2
                ;;
            --skip-docker)
                INSTALL_DOCKER=false
                shift
                ;;
            --skip-zsh)
                INSTALL_ZSH=false
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Setup directories
    mkdir -p "$SETUP_DIR" "$BACKUP_DIR"
    touch "$LOG_FILE"
    
    # Header
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║     LINUX DEVELOPMENT ENVIRONMENT SETUP        ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Detect environment
    DISTRO=$(detect_distro)
    PKG_MANAGER=$(get_package_manager "$DISTRO")
    
    log_info "Distribution: $DISTRO"
    log_info "Package Manager: $PKG_MANAGER"
    log_info "Log file: $LOG_FILE"
    echo ""
    
    # Confirm if interactive
    if [[ "$NON_INTERACTIVE" == false ]]; then
        echo "This will install:"
        [[ "$INSTALL_GIT" == true ]] && echo "  • Git + SSH key"
        [[ "$INSTALL_NODE" == true ]] && echo "  • Node.js ($NODE_VERSION) + npm/yarn/pnpm"
        [[ "$INSTALL_PYTHON" == true ]] && echo "  • Python $PYTHON_VERSION + pipenv/poetry"
        [[ "$INSTALL_DOCKER" == true ]] && echo "  • Docker + Docker Compose"
        [[ "$INSTALL_ZSH" == true ]] && echo "  • Zsh + Oh-My-Zsh"
        [[ "$INSTALL_VSCODE" == true ]] && echo "  • VS Code"
        echo ""
        read -rp "Continue? [Y/n]: " confirm
        [[ "$confirm" =~ ^[Nn]$ ]] && exit 0
    fi
    
    # Execute setup
    update_packages
    install_base_packages
    setup_git
    setup_node
    setup_python
    setup_docker
    setup_zsh
    setup_vscode
    
    # Finalize
    create_summary
    
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log_success "Setup complete! Please restart your terminal."
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

main "$@"
