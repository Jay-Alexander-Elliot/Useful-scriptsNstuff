#!/bin/bash

set -e

BASE_DIR="$(dirname "$(realpath "$0")")"

create_structure() {
    local dir="$1"
    mkdir -p "$dir"
    local placeholder_files=("README.md" ".gitignore" "notes.txt")
    for file in "${placeholder_files[@]}"; do
        if [ ! -f "$dir/$file" ]; then
            echo "Creating $dir/$file"
            echo "Placeholder for $file" > "$dir/$file"
        else
            echo "$dir/$file already exists, skipping creation."
        fi
    done
}

cleanup() {
    echo "Cleaning up existing directories..."
    rm -rf "$BASE_DIR/devops" "$BASE_DIR/webdev" "$BASE_DIR/mobiledev" "$BASE_DIR/cloud" "$BASE_DIR/gamedev" "$BASE_DIR/infosec" "$BASE_DIR/cicd" "$BASE_DIR/monitoring" "$BASE_DIR/scripting"
}

if [ "$1" == "--clean" ]; then
    cleanup
    exit 0
fi

# High-level directories based on function/purpose
declare -A categories=(
[DevOps]="Kubernetes Docker Ansible HashiCorp-Vault HashiCorp-Terraform HashiCorp-Nomad HashiCorp-Consul HashiCorp-Packer HashiCorp-Vagrant HashiCorp-Boundary HashiCorp-Waypoint GoogleWorkspace Helm Git"
[WebDev]="HTML CSS JavaScript Node.js TypeScript React"
[MobileDev]="Flutter Dart Swift Kotlin"
[Cloud]="AWS GCP Linode DigitalOcean Azure CloudFlare Heroku RedisCloud"
[GameDev]="UnrealEngine5 Flame-Engine"
[InfoSec]="Detection&Response Observability OSINT Firewalls Fortinet Snyk"
[CI/CD]="Jenkins GitHubActions GitLabCI BambooCI"
[Monitoring]="Prometheus Grafana ELK Splunk Datadog PagerDuty NewRelic"
[Scripting]="Shell Python PowerShell GoLang Sed-Awk"
[Vim]="VimScripts VimShortcuts"
[Database]="MySQL MongoDB Postgres Redis AWS-RDS AWS-DynamoDB GCP-CloudSQL GCP-Firestore GCP-Bigtable Azure-SQLDatabase Azure-CosmosDB"
[Networking]="DNS SSH FTP SFTP NetworkingTools VPN WireGuard"
[Shell_One-Liners]="FTP SFTP DNS SSH Git Other-Shell-Utilities"



)

# Create directories based on categories
for category in "${!categories[@]}"; do
    IFS=' ' read -ra tools <<< "${categories[$category]}"
    for tool in "${tools[@]}"; do
        create_structure "$BASE_DIR/$category/$tool"
    done
done

echo "Directory structure and files creation/update completed successfully."

