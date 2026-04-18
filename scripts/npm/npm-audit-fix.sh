#!/bin/bash

#===============================================================================
# Script: npm-audit-fix.sh
# Purpose: Run npm audit with auto-fix, reporting, and rollback capability
# Author: Dev Launchpad
# Version: 1.0.0
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
readonly LOG_DIR="${LOG_DIR:-./logs}"
readonly TIMESTAMP=$(date +%Y%m%d_%H%M%S)
readonly LOG_FILE="$LOG_DIR/npm-audit-$TIMESTAMP.log"
readonly BACKUP_FILE="package-lock-backup-$TIMESTAMP.json"
readonly MAX_RETRIES=3

# Settings
AUTO_FIX=true
FORCE=false
PRODUCTION_ONLY=false
DRY_RUN=false
SKIP_LOCKFILE_UPDATE=false
EXIT_ON_CRITICAL=false

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

log_audit() {
    echo -e "${CYAN}[AUDIT]${NC} $1" | tee -a "$LOG_FILE"
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Run npm audit with intelligent auto-fix and comprehensive reporting.

OPTIONS:
    -h, --help          Show this help message
    --no-fix            Run audit only, don't attempt fixes
    --force             Use --force for npm audit fix (risky)
    --production        Audit production dependencies only
    --dry-run           Preview what would be changed
    --skip-backup       Don't create package-lock backup
    --strict            Exit with error if critical vulnerabilities found
    -o, --output        Custom output directory for reports

WORKFLOW:
    1. Create backup of package-lock.json
    2. Run npm audit --json (capture baseline)
    3. Attempt npm audit fix
    4. Run npm audit again to verify
    5. Generate human-readable report
    6. If failed, offer rollback

REPORTS GENERATED:
    - JSON audit result: logs/npm-audit-TIMESTAMP.json
    - Human summary: logs/npm-audit-TIMESTAMP.log
    - Package changes: logs/npm-audit-TIMESTAMP-diff.txt

EXAMPLES:
    $(basename "$0")                      # Standard audit + fix
    $(basename "$0") --no-fix             # Audit only, generate report
    $(basename "$0") --production --strict # CI/CD pipeline check
    $(basename "$0") --dry-run            # Preview changes safely

EOF
}

# Setup environment
setup() {
    # Check for package.json
    if [[ ! -f "package.json" ]]; then
        log_error "No package.json found in current directory"
        exit 1
    fi
    
    # Check for npm
    if ! command -v npm &> /dev/null; then
        log_error "npm is not installed"
        exit 1
    fi
    
    # Create log directory
    mkdir -p "$LOG_DIR"
    
    log_info "Starting npm audit session: $TIMESTAMP"
    log_info "Node version: $(node --version)"
    log_info "npm version: $(npm --version)"
    log_info "Working directory: $(pwd)"
    echo "" | tee -a "$LOG_FILE"
}

# Create backup
create_backup() {
    if [[ "$SKIP_LOCKFILE_UPDATE" == true ]] || [[ ! -f "package-lock.json" ]]; then
        return 0
    fi
    
    log_info "Creating backup: $BACKUP_FILE"
    cp package-lock.json "$BACKUP_FILE"
    log_success "Backup created"
}

# Restore from backup
rollback() {
    if [[ ! -f "$BACKUP_FILE" ]]; then
        log_error "No backup file found to restore"
        return 1
    fi
    
    log_warn "Rolling back to previous state..."
    mv "$BACKUP_FILE" package-lock.json
    npm ci 2>/dev/null || npm install 2>/dev/null || true
    log_success "Rollback complete"
}

# Run audit and capture JSON
run_audit() {
    local output_file="$1"
    local audit_args=""
    
    [[ "$PRODUCTION_ONLY" == true ]] && audit_args="$audit_args --production"
    
    log_audit "Running security audit..."
    
    # Run audit with JSON output, allow failure to capture results
    if npm audit $audit_args --json > "$output_file" 2>/dev/null; then
        echo "0"  # Success exit code
    else
        local exit_code=$?
        echo "$exit_code"
    fi
}

# Parse audit JSON and generate summary
parse_audit_results() {
    local json_file="$1"
    
    if [[ ! -f "$json_file" ]] || [[ ! -s "$json_file" ]]; then
        log_error "Audit output is empty"
        return 1
    fi
    
    # Check if valid JSON
    if ! jq empty "$json_file" 2>/dev/null; then
        log_error "Invalid JSON in audit output"
        return 1
    fi
    
    # Extract summary using jq
    local critical high moderate low info
    critical=$(jq '.metadata.vulnerabilities.critical // 0' "$json_file")
    high=$(jq '.metadata.vulnerabilities.high // 0' "$json_file")
    moderate=$(jq '.metadata.vulnerabilities.moderate // 0' "$json_file")
    low=$(jq '.metadata.vulnerabilities.low // 0' "$json_file")
    info=$(jq '.metadata.vulnerabilities.info // 0' "$json_file")
    local total=$((critical + high + moderate + low + info))
    
    echo ""
    echo "╔════════════════════════════════════════════════╗"
    echo "║           SECURITY AUDIT SUMMARY               ║"
    echo "╠════════════════════════════════════════════════╣"
    printf "║  Critical:  %3d  ${RED}███${NC}                         ║\n" "$critical"
    printf "║  High:      %3d  ${YELLOW}███${NC}                         ║\n" "$high"
    printf "║  Moderate:  %3d  ███                         ║\n" "$moderate"
    printf "║  Low:       %3d  ███                         ║\n" "$low"
    printf "║  Info:      %3d  ███                         ║\n" "$info"
    echo "╠════════════════════════════════════════════════╣"
    printf "║  TOTAL:     %3d  vulnerabilities             ║\n" "$total"
    echo "╚════════════════════════════════════════════════╝"
    echo ""
    
    # Log to file
    {
        echo "Audit Summary - $TIMESTAMP"
        echo "Critical: $critical"
        echo "High: $high"
        echo "Moderate: $moderate"
        echo "Low: $low"
        echo "Info: $info"
        echo "Total: $total"
    } >> "$LOG_FILE"
    
    # Return counts for decision making
    echo "$critical:$high:$moderate:$total"
}

# List top vulnerabilities
list_top_vulnerabilities() {
    local json_file="$1"
    local limit="${2:-10}"
    
    log_audit "Top $limit vulnerabilities by severity:"
    
    jq -r '.vulnerabilities | to_entries | 
        map({name: .key, severity: .value.severity, via: .value.via[0].title}) | 
        sort_by(.severity) | 
        reverse | 
        .[0:'"$limit"'] | 
        .[] | 
        "[\(.severity)] \(.name): \(.via)"' "$json_file" 2>/dev/null | \
        while read -r line; do
            if [[ "$line" == *"[critical]"* ]]; then
                echo -e "  ${RED}$line${NC}"
            elif [[ "$line" == *"[high]"* ]]; then
                echo -e "  ${YELLOW}$line${NC}"
            else
                echo "  $line"
            fi
        done | tee -a "$LOG_FILE"
    
    echo "" | tee -a "$LOG_FILE"
}

# Attempt to fix vulnerabilities
attempt_fix() {
    if [[ "$AUTO_FIX" == false ]]; then
        log_info "Skipping auto-fix (--no-fix specified)"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "[DRY-RUN] Would attempt npm audit fix"
        return 0
    fi
    
    log_audit "Attempting automatic fixes..."
    
    local fix_args=""
    [[ "$FORCE" == true ]] && fix_args="$fix_args --force"
    
    # Try audit fix
    if npm audit fix $fix_args 2>&1 | tee -a "$LOG_FILE"; then
        log_success "npm audit fix completed"
        return 0
    else
        log_warn "Some vulnerabilities could not be automatically fixed"
        return 1
    fi
}

# Generate detailed report
generate_report() {
    local before_json="$1"
    local after_json="$2"
    
    local report_file="$LOG_DIR/npm-audit-report-$TIMESTAMP.md"
    
    {
        echo "# npm Audit Report - $TIMESTAMP"
        echo ""
        echo "## Environment"
        echo "- Node: $(node --version)"
        echo "- npm: $(npm --version)"
        echo "- Project: $(basename "$(pwd)")"
        echo ""
        echo "## Summary"
        echo ""
        echo "### Before Fixes"
        jq '.metadata.vulnerabilities' "$before_json" 2>/dev/null || echo "N/A"
        echo ""
        echo "### After Fixes"
        jq '.metadata.vulnerabilities' "$after_json" 2>/dev/null || echo "N/A"
        echo ""
        echo "## Unresolved Vulnerabilities"
        echo ""
        jq -r '.vulnerabilities | to_entries | 
            map(select(.value.fixAvailable == false or .value.fixAvailable == null)) | 
            map({name: .key, severity: .value.severity, range: .value.range}) | 
            .[] | 
            "- **\(.name)** (\(.severity)): \(.range)"' "$after_json" 2>/dev/null || echo "None found or parse error"
        echo ""
        echo "## Manual Action Required"
        echo ""
        echo "Run \`npm audit\` for full details and manual remediation steps."
        echo ""
        echo "## Log File"
        echo "- Full log: $LOG_FILE"
        echo "- JSON before: $before_json"
        echo "- JSON after: $after_json"
    } > "$report_file"
    
    log_success "Report generated: $report_file"
}

# Check for lockfile changes
check_lockfile_changes() {
    if [[ ! -f "$BACKUP_FILE" ]]; then
        return 0
    fi
    
    if diff -q "$BACKUP_FILE" package-lock.json > /dev/null 2>&1; then
        log_info "No changes to package-lock.json"
    else
        log_success "package-lock.json was modified"
        {
            echo ""
            echo "=== Package Changes ==="
            diff "$BACKUP_FILE" package-lock.json | head -100 || true
        } >> "$LOG_FILE"
    fi
}

#===============================================================================
# Main
#===============================================================================

main() {
    local output_dir="$LOG_DIR"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --no-fix)
                AUTO_FIX=false
                shift
                ;;
            --force)
                FORCE=true
                log_warn "--force enabled: may introduce breaking changes"
                shift
                ;;
            --production)
                PRODUCTION_ONLY=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                log_warn "DRY RUN: No changes will be made"
                shift
                ;;
            --skip-backup)
                SKIP_LOCKFILE_UPDATE=true
                shift
                ;;
            --strict)
                EXIT_ON_CRITICAL=true
                shift
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Update paths with custom output dir
    LOG_DIR="$output_dir"
    LOG_FILE="$LOG_DIR/npm-audit-$TIMESTAMP.log"
    
    # Setup
    setup
    
    # Header
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║         NPM SECURITY AUDIT & FIX               ║"
    echo "╚════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Create backup
    create_backup
    
    # Run initial audit
    local before_json="$LOG_DIR/npm-audit-before-$TIMESTAMP.json"
    local exit_code
    exit_code=$(run_audit "$before_json")
    
    # Parse and display results
    local summary
    summary=$(parse_audit_results "$before_json")
    list_top_vulnerabilities "$before_json" 5
    
    # Extract severity counts
    local critical_count
    critical_count=$(echo "$summary" | cut -d: -f1)
    
    # If no vulnerabilities, we're done
    if [[ "$exit_code" == "0" ]]; then
        log_success "No vulnerabilities found!"
        exit 0
    fi
    
    # Attempt fixes
    attempt_fix
    
    # Run post-fix audit
    echo ""
    log_audit "Running verification audit..."
    local after_json="$LOG_DIR/npm-audit-after-$TIMESTAMP.json"
    exit_code=$(run_audit "$after_json")
    
    # Show final results
    echo ""
    parse_audit_results "$after_json"
    
    # Check lockfile
    check_lockfile_changes
    
    # Generate report
    generate_report "$before_json" "$after_json"
    
    # Summary
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "Audit complete!"
    log_info "Log saved: $LOG_FILE"
    log_info "JSON results: $before_json, $after_json"
    
    # Handle critical vulnerabilities in strict mode
    if [[ "$EXIT_ON_CRITICAL" == true ]] && [[ "$critical_count" -gt 0 ]]; then
        log_error "Critical vulnerabilities found in strict mode"
        exit 1
    fi
    
    # Offer rollback if fixes failed
    if [[ "$exit_code" != "0" ]] && [[ "$AUTO_FIX" == true ]] && [[ "$DRY_RUN" == false ]]; then
        echo ""
        log_warn "Some vulnerabilities remain after auto-fix"
        echo "Manual remediation required. Run: npm audit"
        
        if [[ -f "$BACKUP_FILE" ]]; then
            echo ""
            echo "Rollback available: $BACKUP_FILE"
            echo "To restore: mv $BACKUP_FILE package-lock.json && npm ci"
        fi
    fi
    
    exit $exit_code
}

main "$@"
