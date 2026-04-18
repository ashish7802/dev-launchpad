#!/bin/bash

#===============================================================================
# Script: project-init.sh
# Purpose: Initialize new project with git, README, .gitignore, and structure
# Author: Dev Launchpad
# Version: 1.2.0
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
readonly TEMPLATES_DIR="${TEMPLATES_DIR:-$HOME/.project-templates}"
readonly DEFAULT_LICENSE="MIT"

# Project settings
PROJECT_NAME=""
PROJECT_TYPE="generic"  # node, python, go, rust, generic
CREATE_GIT=true
CREATE_README=true
CREATE_GITIGNORE=true
CREATE_STRUCTURE=true
CREATE_LICENSE=true
CREATE_CI=false
CREATE_DOCKER=false
INITIAL_COMMIT=true
PRIVATE=false

#===============================================================================
# Functions
#===============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] <project-name>

Initialize a new project with professional structure and boilerplate.

OPTIONS:
    -h, --help          Show this help message
    -t, --type          Project type: node, python, go, rust, generic (default: generic)
    --no-git            Skip git initialization
    --no-readme         Skip README creation
    --no-gitignore      Skip .gitignore creation
    --no-structure      Skip directory structure creation
    --no-license        Skip LICENSE file
    --ci                Add CI/CD configuration (GitHub Actions)
    --docker            Add Dockerfile and docker-compose.yml
    --no-commit         Skip initial git commit
    -p, --private       Mark as private project (no public repo hints)
    --template DIR      Use custom template directory

PROJECT TYPES:
    node        Node.js project with package.json, src/, tests/
    python      Python project with pyproject.toml, src/, tests/
    go          Go module with go.mod, cmd/, pkg/, internal/
    rust        Cargo project with Cargo.toml, src/
    generic     Language-agnostic structure with docs/, src/, tests/

EXAMPLES:
    $(basename "$0") my-api --type node --ci --docker
    $(basename "$0") data-processor -t python --private
    $(basename "$0") cli-tool --type go --no-docker

EOF
}

# Validate project name
validate_name() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        log_error "Project name is required"
        show_help
        exit 1
    fi
    
    # Check for valid characters
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "Invalid project name. Use only: letters, numbers, hyphens, underscores"
        exit 1
    fi
    
    # Check if directory exists
    if [[ -d "$name" ]]; then
        log_error "Directory '$name' already exists"
        exit 1
    fi
}

# Create project directory
create_directory() {
    log_info "Creating project directory: $PROJECT_NAME"
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    PROJECT_PATH=$(pwd)
    log_success "Created: $PROJECT_PATH"
}

# Initialize git repository
init_git() {
    [[ "$CREATE_GIT" == false ]] && return 0
    
    log_info "Initializing git repository..."
    
    git init
    
    # Configure git (if not already set globally)
    if [[ -z "$(git config user.name 2>/dev/null || true)" ]]; then
        git config user.email "dev@localhost"
        git config user.name "Developer"
    fi
    
    log_success "Git repository initialized"
}

# Create README.md
create_readme() {
    [[ "$CREATE_README" == false ]] && return 0
    
    log_info "Creating README.md..."
    
    local description="${PROJECT_DESCRIPTION:-A $PROJECT_TYPE project}"
    local year=$(date +%Y)
    local author="${GIT_AUTHOR:-$(git config user.name 2>/dev/null || echo 'Developer')}"
    
    cat > README.md << EOF
# $PROJECT_NAME

$description

## 🚀 Getting Started

### Prerequisites

- List dependencies here
- Installation requirements

### Installation

\`\`\`bash
# Clone the repository
git clone https://github.com/username/$PROJECT_NAME.git
cd $PROJECT_NAME

# Install dependencies
# (Add specific commands for $PROJECT_TYPE)
\`\`\`

### Usage

\`\`\`bash
# Add usage examples
\`\`\`

## 🏗️ Project Structure

\`\`\`
$PROJECT_NAME/
├── src/           # Source code
├── tests/         # Test files
├── docs/          # Documentation
└── README.md      # This file
\`\`\`

## 🧪 Testing

\`\`\`bash
# Add test commands
\`\`\`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

## 📝 License

This project is licensed under the $DEFAULT_LICENSE License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**$author**

---

Made with ❤️ and ☕
EOF

    log_success "Created README.md"
}

# Create .gitignore
create_gitignore() {
    [[ "$CREATE_GITIGNORE" == false ]] && return 0
    
    log_info "Creating .gitignore..."
    
    # Base gitignore for all projects
    cat > .gitignore << 'EOF'
# OS files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Editor directories and files
.idea/
.vscode/
*.swp
*.swo
*~
.project
.classpath
.settings/

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.*.local
.env.development
.env.test
.env.production

# Temporary files
tmp/
temp/
*.tmp
*.temp
.cache/

# Build outputs
dist/
build/
out/
target/

# Coverage reports
coverage/
.nyc_output/

# Dependency directories (if vendoring)
vendor/
EOF

    # Add type-specific ignores
    case "$PROJECT_TYPE" in
        node)
            cat >> .gitignore << 'EOF'

# Node.js
node_modules/
package-lock.json
yarn.lock
pnpm-lock.yaml
.eslintcache
.node_repl_history
*.tgz
.yarn-integrity
EOF
            ;;
        python)
            cat >> .gitignore << 'EOF'

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST
.pytest_cache/
.mypy_cache/
.dmypy.json
dmypy.json
*.pytype
cython_debug/
.venv/
venv/
ENV/
env/
EOF
            ;;
        go)
            cat >> .gitignore << 'EOF'

# Go
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
go.work
EOF
            ;;
        rust)
            cat >> .gitignore << 'EOF'

# Rust
/target/
**/*.rs.bk
Cargo.lock
EOF
            ;;
    esac

    log_success "Created .gitignore"
}

# Create project structure
create_structure() {
    [[ "$CREATE_STRUCTURE" == false ]] && return 0
    
    log_info "Creating project structure for $PROJECT_TYPE..."
    
    case "$PROJECT_TYPE" in
        node)
            mkdir -p src tests docs scripts
            cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "test": "jest",
    "lint": "eslint src/",
    "dev": "nodemon src/index.js"
  },
  "keywords": [],
  "author": "",
  "license": "$DEFAULT_LICENSE",
  "devDependencies": {
    "eslint": "^8.0.0",
    "jest": "^29.0.0",
    "nodemon": "^3.0.0"
  }
}
EOF
            cat > src/index.js << 'EOF'
// Main entry point
console.log('Hello, world!');
EOF
            ;;
            
        python)
            mkdir -p src/"$PROJECT_NAME" tests docs
            cat > pyproject.toml << EOF
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
version = "1.0.0"
description = ""
readme = "README.md"
requires-python = ">=3.8"
license = {text = "$DEFAULT_LICENSE"}
authors = [
    {name = "Developer", email = "dev@localhost"}
]
classifiers = [
    "Programming Language :: Python :: 3",
    "License :: OSI Approved :: MIT License",
    "Operating System :: OS Independent",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "black>=23.0",
    "flake8>=6.0",
    "mypy>=1.0",
]

[tool.setuptools.packages.find]
where = ["src"]

[tool.black]
line-length = 88

[tool.pytest.ini_options]
testpaths = ["tests"]
EOF
            mkdir -p src/"$PROJECT_NAME"
            touch src/"$PROJECT_NAME"/__init__.py
            cat > src/"$PROJECT_NAME"/main.py << 'EOF'
"""Main module for the project."""


def main() -> None:
    """Main entry point."""
    print("Hello, world!")


if __name__ == "__main__":
    main()
EOF
            ;;
            
        go)
            mkdir -p cmd/"$PROJECT_NAME" internal pkg docs
            go mod init "github.com/username/$PROJECT_NAME"
            cat > cmd/"$PROJECT_NAME"/main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, world!")
}
EOF
            ;;
            
        rust)
            mkdir -p src tests docs
            cat > Cargo.toml << EOF
[package]
name = "$PROJECT_NAME"
version = "1.0.0"
edition = "2021"

[dependencies]

[dev-dependencies]
EOF
            cat > src/main.rs << 'EOF'
fn main() {
    println!("Hello, world!");
}
EOF
            ;;
            
        generic)
            mkdir -p src tests docs scripts
            cat > Makefile << 'EOF'
.PHONY: help test clean

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

test: ## Run tests
	@echo "Add test commands here"

clean: ## Clean build artifacts
	rm -rf dist/ build/ tmp/
EOF
            ;;
    esac
    
    # Create common files
    touch tests/.gitkeep
    touch docs/.gitkeep
    
    log_success "Created project structure"
}

# Create LICENSE
create_license() {
    [[ "$CREATE_LICENSE" == false ]] && return 0
    
    log_info "Creating LICENSE ($DEFAULT_LICENSE)..."
    
    local year=$(date +%Y)
    local author="${GIT_AUTHOR:-$(git config user.name 2>/dev/null || echo 'Developer')}"
    
    case "$DEFAULT_LICENSE" in
        MIT)
            cat > LICENSE << EOF
MIT License

Copyright (c) $year $author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
            ;;
        Apache-2.0)
            cat > LICENSE << EOF
Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

Copyright $year $author

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
EOF
            ;;
        *)
            cat > LICENSE << EOF
$DEFAULT_LICENSE License

Copyright (c) $year $author

[Add full license text here]
EOF
            ;;
    esac
    
    log_success "Created LICENSE"
}

# Create CI/CD configuration
create_ci() {
    [[ "$CREATE_CI" == false ]] && return 0
    
    log_info "Creating GitHub Actions CI configuration..."
    
    mkdir -p .github/workflows
    
    case "$PROJECT_TYPE" in
        node)
            cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x, 20.x]

    steps:
    - uses: actions/checkout@v4
    
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - run: npm ci
    - run: npm run lint
    - run: npm test
EOF
            ;;
            
        python)
            cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.9', '3.10', '3.11', '3.12']

    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v5
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e ".[dev]"
    
    - name: Lint with flake8
      run: flake8 src tests
    
    - name: Type check with mypy
      run: mypy src
    
    - name: Test with pytest
      run: pytest
EOF
            ;;
            
        *)
            cat > .github/workflows/ci.yml << 'EOF'
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Run tests
      run: echo "Add your test commands here"
EOF
            ;;
    esac
    
    log_success "Created CI configuration"
}

# Create Docker files
create_docker() {
    [[ "$CREATE_DOCKER" == false ]] && return 0
    
    log_info "Creating Docker configuration..."
    
    case "$PROJECT_TYPE" in
        node)
            cat > Dockerfile << 'EOF'
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

USER node
EXPOSE 3000

CMD ["node", "src/index.js"]
EOF
            ;;
            
        python)
            cat > Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY pyproject.toml ./
RUN pip install -e .

COPY . .

EXPOSE 8000

CMD ["python", "-m", "src.main"]
EOF
            ;;
            
        go)
            cat > Dockerfile << 'EOF'
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app ./cmd/app

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/app .
CMD ["./app"]
EOF
            ;;
            
        rust)
            cat > Dockerfile << 'EOF'
FROM rust:1.75 AS builder

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src

COPY . .
RUN touch src/main.rs
RUN cargo build --release

FROM debian:bookworm-slim
COPY --from=builder /app/target/release/app /usr/local/bin/
CMD ["app"]
EOF
            ;;
            
        *)
            cat > Dockerfile << 'EOF'
FROM alpine:latest

WORKDIR /app
COPY . .

CMD ["echo", "Hello from Docker"]
EOF
            ;;
    esac
    
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
      - /app/node_modules
EOF

    cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
.git
.env
.env.local
dist
build
coverage
.vscode
.idea
EOF

    log_success "Created Docker configuration"
}

# Create initial commit
create_initial_commit() {
    [[ "$INITIAL_COMMIT" == false ]] && return 0
    [[ "$CREATE_GIT" == false ]] && return 0
    
    log_info "Creating initial commit..."
    
    git add -A
    
    git -c user.email="dev@localhost" \
        -c user.name="Developer" \
        commit -m "chore: initial project setup

- Add project structure and boilerplate
- Configure development environment
- Add documentation and license"
    
    log_success "Initial commit created"
    
    # Show status
    echo ""
    git log --oneline -1
    echo ""
    git status
}

# Print next steps
print_next_steps() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  PROJECT INITIALIZED SUCCESSFULLY      ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Project: $PROJECT_NAME"
    echo "Location: $PROJECT_PATH"
    echo "Type: $PROJECT_TYPE"
    echo ""
    echo "Next steps:"
    echo "  cd $PROJECT_NAME"
    
    case "$PROJECT_TYPE" in
        node)
            echo "  npm install"
            echo "  npm run dev"
            ;;
        python)
            echo "  python -m venv .venv"
            echo "  source .venv/bin/activate"
            echo "  pip install -e '.[dev]'"
            ;;
        go)
            echo "  go mod tidy"
            echo "  go run ./cmd/$PROJECT_NAME"
            ;;
        rust)
            echo "  cargo build"
            echo "  cargo run"
            ;;
    esac
    
    if [[ "$CREATE_GIT" == true ]]; then
        echo ""
        echo "Git repository initialized."
        echo "To push to GitHub:"
        echo "  gh repo create $PROJECT_NAME --public --source=. --push"
    fi
    
    if [[ "$CREATE_DOCKER" == true ]]; then
        echo ""
        echo "Docker configured. To build:"
        echo "  docker-compose up --build"
    fi
    
    echo ""
    echo -e "${GREEN}Happy coding! 🚀${NC}"
    echo ""
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
            -t|--type)
                PROJECT_TYPE="$2"
                shift 2
                ;;
            --no-git)
                CREATE_GIT=false
                shift
                ;;
            --no-readme)
                CREATE_README=false
                shift
                ;;
            --no-gitignore)
                CREATE_GITIGNORE=false
                shift
                ;;
            --no-structure)
                CREATE_STRUCTURE=false
                shift
                ;;
            --no-license)
                CREATE_LICENSE=false
                shift
                ;;
            --ci)
                CREATE_CI=true
                shift
                ;;
            --docker)
                CREATE_DOCKER=true
                shift
                ;;
            --no-commit)
                INITIAL_COMMIT=false
                shift
                ;;
            -p|--private)
                PRIVATE=true
                shift
                ;;
            --template)
                TEMPLATES_DIR="$2"
                shift 2
                ;;
            -*)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                PROJECT_NAME="$1"
                shift
                ;;
        esac
    done
    
    # Validate
    validate_name "$PROJECT_NAME"
    
    # Header
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║         PROJECT INITIALIZATION                 ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Execute
    create_directory
    init_git
    create_structure
    create_gitignore
    create_readme
    create_license
    create_ci
    create_docker
    create_initial_commit
    
    # Finish
    print_next_steps
}

main "$@"
