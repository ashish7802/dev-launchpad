#!/bin/bash

#===============================================================================
# Script: git-cleanup.sh
# Purpose: Safely delete merged branches locally and remotely
# Author: Dev Launchpad
# Version: 1.0.0
#===============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Configuration
readonly PROTECTED_BRANCHES=("main" "master" "develop" "production" "staging")
readonly DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
DRY_RUN=false
FORCE_DELETE=false

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

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Safely remove git branches that have been merged into the default branch.

OPTIONS:
    -h, --help          Show this help message
    -d, --dry-run       Preview what would be deleted without making changes
    -f, --force         Force delete branches (even if not fully merged)
    -b, --branch        Specify target branch (default: $DEFAULT_BRANCH)
    -r, --remote        Also delete from remote origin
    -p, --prune         Prune remote-tracking branches

EXAMPLES:
    $(basename "$0") --dry-run              # Preview local cleanup
    $(basename "$0") --remote               # Clean local + remote
    $(basename "$0") -f -b develop          # Force clean against develop

PROTECTED BRANCHES (never deleted): ${PROTECTED_BRANCHES[*]}
EOF
}

# Check if we're in a git repository
verify_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not a git repository. Please run from a git project directory."
        exit 1
    fi
}

# Get the actual default branch (main or master)
get_default_branch() {
    local default_branch
    
    # Try to get from origin first
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@') || true
    
    # Fallback to local detection
    if [[ -z "$default_branch" ]]; then
        if git show-ref --verify --quiet refs/heads/main; then
            default_branch="main"
        elif git show-ref --verify --quiet refs/heads/master; then
            default_branch="master"
        else
            log_error "Could not determine default branch. Please specify with -b"
            exit 1
        fi
    fi
    
    echo "$default_branch"
}

# Check if branch is protected
is_protected() {
    local branch="$1"
    for protected in "${PROTECTED_BRANCHES[@]}"; do
        if [[ "$branch" == "$protected" ]]; then
            return 0
        fi
    done
    return 1
}

# Fetch latest from remote
sync_remote() {
    log_info "Fetching latest from remote..."
    if ! git fetch --prune origin 2>/dev/null; then
        log_warn "Could not fetch from remote (may be offline or no remote configured)"
    fi
}

# Get list of merged local branches
get_merged_locals() {
    local target_branch="$1"
    git branch --merged "$target_branch" --format='%(refname:short)' 2>/dev/null | grep -v "^$target_branch$" || true
}

# Get list of merged remote branches
get_merged_remotes() {
    local target_branch="$1"
    git branch -r --merged "$target_branch" --format='%(refname:short)' 2>/dev/null | \
        sed 's|origin/||' | \
        grep -v "^$target_branch$" | \
        grep -v "HEAD" || true
}

# Delete local branch with safety checks
delete_local_branch() {
    local branch="$1"
    local force="$2"
    
    if is_protected "$branch"; then
        log_warn "Skipping protected branch: $branch"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "  [DRY-RUN] Would delete local branch: $branch"
        return 0
    fi
    
    local delete_flag="-d"
    [[ "$force" == true ]] && delete_flag="-D"
    
    if git branch $delete_flag "$branch" 2>/dev/null; then
        log_success "Deleted local branch: $branch"
        return 0
    else
        log_error "Failed to delete local branch: $branch"
        return 1
    fi
}

# Delete remote branch with safety checks
delete_remote_branch() {
    local branch="$1"
    
    if is_protected "$branch"; then
        log_warn "Skipping protected remote branch: $branch"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "  [DRY-RUN] Would delete remote branch: origin/$branch"
        return 0
    fi
    
    if git push origin --delete "$branch" 2>/dev/null; then
        log_success "Deleted remote branch: origin/$branch"
        return 0
    else
        log_warn "Could not delete remote branch: origin/$branch (may not exist or no permissions)"
        return 1
    fi
}

# Prune remote-tracking branches
prune_remotes() {
    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY-RUN] Would prune remote-tracking branches"
        return 0
    fi
    
    log_info "Pruning remote-tracking branches..."
    git remote prune origin
    log_success "Pruned stale remote-tracking branches"
}

#===============================================================================
# Main Execution
#===============================================================================

main() {
    local target_branch="$DEFAULT_BRANCH"
    local clean_remote=false
    local prune=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -f|--force)
                FORCE_DELETE=true
                shift
                ;;
            -b|--branch)
                target_branch="$2"
                shift 2
                ;;
            -r|--remote)
                clean_remote=true
                shift
                ;;
            -p|--prune)
                prune=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Verify environment
    verify_git_repo
    
    # Auto-detect default branch if not specified
    if [[ "$target_branch" == "$DEFAULT_BRANCH" ]]; then
        target_branch=$(get_default_branch)
        log_info "Detected default branch: $target_branch"
    fi
    
    # Ensure we're on the target branch
    local current_branch
    current_branch=$(git branch --show-current)
    if [[ "$current_branch" != "$target_branch" ]]; then
        log_info "Switching to $target_branch..."
        if ! git checkout "$target_branch" 2>/dev/null; then
            log_error "Could not checkout $target_branch. Please resolve conflicts first."
            exit 1
        fi
    fi
    
    # Sync with remote
    sync_remote
    
    # Show summary header
    echo ""
    echo "=========================================="
    echo "  GIT BRANCH CLEANUP"
    [[ "$DRY_RUN" == true ]] && echo "  *** DRY RUN MODE ***"
    echo "  Target branch: $target_branch"
    echo "  Force delete: $FORCE_DELETE"
    echo "  Clean remote: $clean_remote"
    echo "=========================================="
    echo ""
    
    # Get merged branches
    local merged_locals
    local merged_remotes
    
    merged_locals=$(get_merged_locals "$target_branch")
    merged_remotes=$(get_merged_remotes "$target_branch")
    
    # Clean local branches
    if [[ -n "$merged_locals" ]]; then
        log_info "Found merged local branches:"
        echo "$merged_locals" | while read -r branch; do
            echo "  - $branch"
        done
        echo ""
        
        local deleted_count=0
        echo "$merged_locals" | while read -r branch; do
            [[ -n "$branch" ]] || continue
            if delete_local_branch "$branch" "$FORCE_DELETE"; then
                ((deleted_count++)) || true
            fi
        done
        
        log_success "Local branch cleanup complete"
    else
        log_info "No merged local branches found to delete"
    fi
    
    # Clean remote branches
    if [[ "$clean_remote" == true ]]; then
        echo ""
        if [[ -n "$merged_remotes" ]]; then
            log_info "Found merged remote branches:"
            echo "$merged_remotes" | while read -r branch; do
                echo "  - origin/$branch"
            done
            echo ""
            
            echo "$merged_remotes" | while read -r branch; do
                [[ -n "$branch" ]] || continue
                delete_remote_branch "$branch"
            done
            
            log_success "Remote branch cleanup complete"
        else
            log_info "No merged remote branches found to delete"
        fi
    fi
    
    # Prune if requested
    if [[ "$prune" == true ]]; then
        prune_remotes
    fi
    
    # Final status
    echo ""
    echo "=========================================="
    log_success "Cleanup complete!"
    echo "=========================================="
    
    # Show remaining branches
    echo ""
    log_info "Remaining local branches:"
    git branch --format='  - %(refname:short) %(upstream:short)' 2>/dev/null | head -20
    
    if [[ "$DRY_RUN" == true ]]; then
        echo ""
        log_warn "This was a DRY RUN. No actual changes were made."
        echo "Run without --dry-run to execute deletions."
    fi
}

# Run main
main "$@"
