#!/bin/bash

#===============================================================================
# Script: docker-nuke.sh
# Purpose: Comprehensive Docker cleanup with safety confirmations
# Author: Dev Launchpad
# Version: 1.1.0
# WARNING: Destructive operation - requires explicit confirmation
#===============================================================================

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Safety configuration
readonly REQUIRED_CONFIRMATION="NUKE"
readonly EXCLUDED_IMAGES=("postgres:alpine" "redis:alpine")  # Never delete these

# Default settings
STOP_CONTAINERS=true
REMOVE_CONTAINERS=true
REMOVE_IMAGES=true
REMOVE_VOLUMES=false
REMOVE_NETWORKS=false
REMOVE_BUILD_CACHE=false
FORCE=false
DRY_RUN=false

#===============================================================================
# Functions
#===============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_nuke() {
    echo -e "${RED}[NUKE]${NC} $1"
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

⚠️  DESTRUCTIVE OPERATION: Stops and removes Docker resources

OPTIONS:
    -h, --help          Show this help message
    --soft              Stop containers only (safest)
    --medium            Stop + remove containers (default)
    --hard              Stop + remove containers + images + volumes (DANGEROUS)
    --all               Everything including networks and build cache
    -f, --force         Skip confirmation prompts (CI/CD use)
    -d, --dry-run       Preview what would be deleted
    -e, --except        Comma-separated list of images to preserve
    -y, --yes           Auto-confirm (use with caution)

NUKE LEVELS:
    --soft:    docker stop \$(docker ps -q)
    --medium:  soft + docker rm + prune containers
    --hard:    medium + docker rmi + docker volume rm + prune
    --all:     hard + networks + build cache + system prune -a

EXAMPLES:
    $(basename "$0") --dry-run              # Preview what would be deleted
    $(basename "$0") --soft                 # Just stop running containers
    $(basename "$0") --hard -e "postgres,redis"  # Hard nuke but keep DB images
    $(basename "$0") --all -y               # CI/CD pipeline cleanup

EOF
}

# Check if Docker is running
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        exit 1
    fi
    
    log_success "Docker is available"
}

# Get resource counts for reporting
get_resource_summary() {
    local running_containers
    local total_containers
    local images
    local volumes
    local networks
    local disk_usage
    
    running_containers=$(docker ps -q 2>/dev/null | wc -l)
    total_containers=$(docker ps -aq 2>/dev/null | wc -l)
    images=$(docker images -q 2>/dev/null | wc -l)
    volumes=$(docker volume ls -q 2>/dev/null | wc -l)
    networks=$(docker network ls -q 2>/dev/null | wc -l)
    disk_usage=$(docker system df --format '{{.Size}}' 2>/dev/null | head -1 || echo "unknown")
    
    echo "running_containers:$running_containers"
    echo "total_containers:$total_containers"
    echo "images:$images"
    echo "volumes:$volumes"
    echo "networks:$networks"
    echo "disk_usage:$disk_usage"
}

# Print resource summary
print_summary() {
    log_info "Current Docker resources:"
    local summary
    summary=$(get_resource_summary)
    
    echo "$summary" | while read -r line; do
        local key="${line%%:*}"
        local value="${line##*:}"
        printf "  %-20s: %s\n" "$key" "$value"
    done
    echo ""
}

# Safety confirmation
confirm_nuke() {
    if [[ "$FORCE" == true ]]; then
        return 0
    fi
    
    echo -e "${RED}"
    cat << 'EOF'
    _   _       _      _             _ 
   | \ | |     | |    | |           | |
   |  \| | __ _| | ___| |_ __ _  ___| | __
   | . ` |/ _` | |/ _ \ __/ _` |/ __| |/ /
   | |\  | (_| | |  __/ || (_| | (__|   <
   |_| \_|\__,_|_|\___|\__\__,_|\___|_|\_\
EOF
    echo -e "${NC}"
    
    log_nuke "WARNING: This will DESTROY Docker resources!"
    echo ""
    echo "Actions to be performed:"
    [[ "$STOP_CONTAINERS" == true ]] && echo "  [✓] Stop running containers"
    [[ "$REMOVE_CONTAINERS" == true ]] && echo "  [✓] Remove all containers"
    [[ "$REMOVE_IMAGES" == true ]] && echo "  [✓] Remove images"
    [[ "$REMOVE_VOLUMES" == true ]] && echo "  [✓] Remove volumes (DATA LOSS RISK)"
    [[ "$REMOVE_NETWORKS" == true ]] && echo "  [✓] Remove custom networks"
    [[ "$REMOVE_BUILD_CACHE" == true ]] && echo "  [✓] Clear build cache"
    echo ""
    
    # Show excluded images
    if [[ ${#EXCLUDED_IMAGES[@]} -gt 0 ]]; then
        log_info "Protected images (will be preserved):"
        for img in "${EXCLUDED_IMAGES[@]}"; do
            echo "  - $img"
        done
        echo ""
    fi
    
    # Require typed confirmation for destructive operations
    if [[ "$REMOVE_VOLUMES" == true ]] || [[ "$REMOVE_IMAGES" == true ]]; then
        echo -e "${RED}This operation may result in DATA LOSS.${NC}"
        echo "Type '$REQUIRED_CONFIRMATION' to proceed, or Ctrl+C to cancel:"
        read -r user_input
        
        if [[ "$user_input" != "$REQUIRED_CONFIRMATION" ]]; then
            log_error "Confirmation failed. Aborting."
            exit 1
        fi
    else
        echo "Proceed? [y/N]: "
        read -r user_input
        if [[ "$user_input" != "y" && "$user_input" != "Y" ]]; then
            log_info "Aborted by user"
            exit 0
        fi
    fi
}

# Stop containers
stop_containers() {
    local containers
    containers=$(docker ps -q 2>/dev/null || true)
    
    if [[ -z "$containers" ]]; then
        log_info "No running containers to stop"
        return 0
    fi
    
    local count
    count=$(echo "$containers" | wc -l)
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "[DRY-RUN] Would stop $count container(s)"
        return 0
    fi
    
    log_info "Stopping $count container(s)..."
    if docker stop $containers 2>/dev/null; then
        log_success "Stopped all containers"
    else
        log_warn "Some containers may not have stopped cleanly"
    fi
}

# Remove containers
remove_containers() {
    local containers
    containers=$(docker ps -aq 2>/dev/null || true)
    
    if [[ -z "$containers" ]]; then
        log_info "No containers to remove"
        return 0
    fi
    
    local count
    count=$(echo "$containers" | wc -l)
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "[DRY-RUN] Would remove $count container(s)"
        return 0
    fi
    
    log_info "Removing $count container(s)..."
    if docker rm $containers 2>/dev/null; then
        log_success "Removed all containers"
    else
        log_warn "Some containers could not be removed (may be running)"
    fi
}

# Remove images with exclusions
remove_images() {
    local images
    # Get images excluding protected ones
    images=$(docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | \
        grep -v "<none>" | \
        while read -r img; do
            local protected=false
            for excluded in "${EXCLUDED_IMAGES[@]}"; do
                if [[ "$img" == *"$excluded"* ]]; then
                    protected=true
                    break
                fi
            done
            [[ "$protected" == false ]] && echo "$img"
        done || true)
    
    if [[ -z "$images" ]]; then
        log_info "No images to remove (or all are protected)"
        return 0
    fi
    
    local count
    count=$(echo "$images" | wc -l)
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "[DRY-RUN] Would remove $count image(s)"
        echo "$images" | head -10 | sed 's/^/    /'
        [[ $count -gt 10 ]] && echo "    ... and $((count - 10)) more"
        return 0
    fi
    
    log_info "Removing $count image(s)..."
    echo "$images" | while read -r img; do
        [[ -n "$img" ]] || continue
        if docker rmi "$img" 2>/dev/null; then
            echo "  - Removed: $img"
        else
            log_warn "Could not remove: $img (in use)"
        fi
    done
}

# Remove volumes
remove_volumes() {
    local volumes
    volumes=$(docker volume ls -q 2>/dev/null || true)
    
    if [[ -z "$volumes" ]]; then
        log_info "No volumes to remove"
        return 0
    fi
    
    local count
    count=$(echo "$volumes" | wc -l)
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "[DRY-RUN] Would remove $count volume(s) - DATA LOSS RISK"
        return 0
    fi
    
    log_nuke "Removing $count volume(s)..."
    if docker volume rm $volumes 2>/dev/null; then
        log_success "Removed all volumes"
    else
        log_warn "Some volumes could not be removed (may be in use)"
    fi
}

# Remove networks
remove_networks() {
    # Don't remove default networks: bridge, host, none
    local networks
    networks=$(docker network ls --format '{{.Name}}' 2>/dev/null | \
        grep -v -E '^(bridge|host|none)$' || true)
    
    if [[ -z "$networks" ]]; then
        log_info "No custom networks to remove"
        return 0
    fi
    
    local count
    count=$(echo "$networks" | wc -l)
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "[DRY-RUN] Would remove $count custom network(s)"
        return 0
    fi
    
    log_info "Removing $count custom network(s)..."
    echo "$networks" | while read -r net; do
        [[ -n "$net" ]] || continue
        if docker network rm "$net" 2>/dev/null; then
            echo "  - Removed network: $net"
        else
            log_warn "Could not remove network: $net"
        fi
    done
}

# System prune
system_prune() {
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "[DRY-RUN] Would run docker system prune"
        return 0
    fi
    
    log_info "Running system prune..."
    local prune_flags=""
    [[ "$REMOVE_VOLUMES" == true ]] && prune_flags="$prune_flags --volumes"
    [[ "$REMOVE_BUILD_CACHE" == true ]] && prune_flags="$prune_flags -a"
    
    if docker system prune -f $prune_flags 2>/dev/null; then
        log_success "System prune complete"
    else
        log_warn "System prune encountered issues"
    fi
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
            --soft)
                STOP_CONTAINERS=true
                REMOVE_CONTAINERS=false
                REMOVE_IMAGES=false
                REMOVE_VOLUMES=false
                shift
                ;;
            --medium)
                STOP_CONTAINERS=true
                REMOVE_CONTAINERS=true
                REMOVE_IMAGES=false
                REMOVE_VOLUMES=false
                shift
                ;;
            --hard)
                STOP_CONTAINERS=true
                REMOVE_CONTAINERS=true
                REMOVE_IMAGES=true
                REMOVE_VOLUMES=true
                shift
                ;;
            --all)
                STOP_CONTAINERS=true
                REMOVE_CONTAINERS=true
                REMOVE_IMAGES=true
                REMOVE_VOLUMES=true
                REMOVE_NETWORKS=true
                REMOVE_BUILD_CACHE=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -e|--except)
                IFS=',' read -ra EXTRA_EXCLUDES <<< "$2"
                EXCLUDED_IMAGES+=("${EXTRA_EXCLUDES[@]}")
                shift 2
                ;;
            -y|--yes)
                FORCE=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Header
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║           DOCKER NUKE - Cleanup Utility                ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Checks
    check_docker
    print_summary
    
    # Confirmation (unless dry run)
    if [[ "$DRY_RUN" == false ]]; then
        confirm_nuke
    else
        log_warn "DRY RUN MODE - No actual changes will be made"
    fi
    
    echo ""
    log_info "Starting cleanup operations..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Execute operations
    [[ "$STOP_CONTAINERS" == true ]] && stop_containers
    [[ "$REMOVE_CONTAINERS" == true ]] && remove_containers
    [[ "$REMOVE_IMAGES" == true ]] && remove_images
    [[ "$REMOVE_VOLUMES" == true ]] && remove_volumes
    [[ "$REMOVE_NETWORKS" == true ]] && remove_networks
    [[ "$REMOVE_BUILD_CACHE" == true ]] && system_prune
    
    # If only containers removed, do a light prune
    if [[ "$REMOVE_CONTAINERS" == true ]] && [[ "$REMOVE_BUILD_CACHE" == false ]]; then
        docker container prune -f 2>/dev/null || true
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Final report
    log_success "Docker nuke complete!"
    echo ""
    log_info "Remaining resources:"
    get_resource_summary | while read -r line; do
        local key="${line%%:*}"
        local value="${line##*:}"
        printf "  %-20s: %s\n" "$key" "$value"
    done
    
    # Disk space reclaimed estimate
    local new_usage
    new_usage=$(docker system df --format '{{.Size}}' 2>/dev/null | head -1 || echo "unknown")
    echo ""
    log_info "Current disk usage: $new_usage"
    
    if [[ "$DRY_RUN" == true ]]; then
        echo ""
        log_warn "This was a DRY RUN. No resources were actually deleted."
        echo "Run without --dry-run to perform cleanup."
    fi
}

main "$@"
