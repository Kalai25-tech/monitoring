#!/bin/bash

# Prometheus Installation Script
# Standard paths: /etc/prometheus (config), /var/lib/prometheus (data)
# Version: 3.5.0

set -e

# Set hostname
echo "prometheus" > /etc/hostname
hostname prometheus

# Variables
PROM_VERSION="3.5.0"
DOWNLOAD_URL="https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
TAR_FILE="prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
EXTRACT_DIR="prometheus-${PROM_VERSION}.linux-amd64"
WORK_DIR="/tmp/prom"
CONFIG_DIR="/etc/prometheus"
DATA_DIR="/var/lib/prometheus"
BIN_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/prometheus.service"

# Create working directory
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

# Download and extract
wget "${DOWNLOAD_URL}"
tar xzvf "${TAR_FILE}"

# Create group and user
groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus

# Create data directory
mkdir "${DATA_DIR}"
chown -R prometheus:prometheus "${DATA_DIR}"
chmod -R 775 "${DATA_DIR}"

# Create config subdirectories
mkdir -p "${CONFIG_DIR}/rules"
mkdir -p "${CONFIG_DIR}/rules.s"
mkdir -p "${CONFIG_DIR}/files_sd"

# Enter extracted directory
cd "${EXTRACT_DIR}"

# Move binaries
mv prometheus promtool "${BIN_DIR}"

# Check version
prometheus --version

# Move config file
mv prometheus.yml "${CONFIG_DIR}"

# Create systemd service file
cat > "${SERVICE_FILE}" << EOF
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries \\
  --web.listen-address=0.0.0.0:9090 \\
  --web.enable-remote-write-receiver

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Set permissions
chown -R prometheus:prometheus "${CONFIG_DIR}"
chmod -R 775 "${CONFIG_DIR}"
chown -R prometheus:prometheus "${DATA_DIR}"

# Reload and start service
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
systemctl status prometheus --no-pager

# Display service file for verification
cat "${SERVICE_FILE}"


#-------------------------------------------------------------
# Add helper script to add scrape targets later
#-------------------------------------------------------------
echo "===== Creating add-prometheus-target.sh helper script ====="

cat <<'EOF' > /usr/local/bin/add-prometheus-target.sh
#!/bin/bash
#=============================================================
#  Add Scrape Target to Prometheus Config
#-------------------------------------------------------------
#  Prompts for a target IP/hostname and port, then appends
#  a new scrape job to /etc/prometheus/prometheus.yml
#=============================================================

set -e

PROM_CONFIG="/etc/prometheus/prometheus.yml"

# ---- Sanity checks ----
if [ ! -f "$PROM_CONFIG" ]; then
    echo "❌ Error: $PROM_CONFIG not found. Is Prometheus installed on this host?"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (sudo)."
    exit 1
fi

# ---- Prompt for input ----
read -rp "Enter target IP or hostname: " TARGET_IP
read -rp "Enter target port: " TARGET_PORT

if [ -z "$TARGET_IP" ] || [ -z "$TARGET_PORT" ]; then
    echo "❌ Target IP/hostname and port cannot be empty."
    exit 1
fi

# ---- Optional: job name and label so repeated runs don't collide ----
read -rp "Enter job name [default: web_app_systems]: " JOB_NAME
JOB_NAME=${JOB_NAME:-web_app_systems}

read -rp "Enter app label value [default: web_app_systems]: " APP_LABEL
APP_LABEL=${APP_LABEL:-web_app_systems}

# ---- Backup existing config ----
BACKUP_FILE="${PROM_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
cp "$PROM_CONFIG" "$BACKUP_FILE"
echo "🗂  Backed up existing config to $BACKUP_FILE"

# ---- Check if scrape_configs key exists ----
if ! grep -q "^scrape_configs:" "$PROM_CONFIG"; then
    echo "⚠️  No 'scrape_configs:' section found. Adding one."
    echo "" >> "$PROM_CONFIG"
    echo "scrape_configs:" >> "$PROM_CONFIG"
fi

# ---- Append the new job block ----
cat <<EOT >> "$PROM_CONFIG"

  # The job name is added as a label \`job=<job_name>\` to any timeseries scraped from this config.
  - job_name: "${JOB_NAME}"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["${TARGET_IP}:${TARGET_PORT}"]
        # The label name is added as a label \`label_name=<label_value>\` to any timeseries scraped from this config.
        labels:
          app: "${APP_LABEL}"
EOT

echo "✅ Added target ${TARGET_IP}:${TARGET_PORT} under job '${JOB_NAME}' to $PROM_CONFIG"

# ---- Validate config syntax if promtool is available ----
if command -v promtool >/dev/null 2>&1; then
    echo "🔍 Validating config with promtool..."
    if promtool check config "$PROM_CONFIG"; then
        echo "✅ Config syntax is valid."
    else
        echo "❌ Config validation failed. Restoring backup..."
        cp "$BACKUP_FILE" "$PROM_CONFIG"
        exit 1
    fi
else
    echo "⚠️  promtool not found — skipping syntax validation. Double-check indentation manually if Prometheus fails to reload."
fi

# ---- Reload Prometheus ----
if systemctl is-active --quiet prometheus; then
    echo "🔄 Reloading Prometheus service..."
    systemctl reload prometheus || systemctl restart prometheus
    echo "✅ Prometheus reloaded."
else
    echo "⚠️  Prometheus service not detected as active under the name 'prometheus'. Reload it manually if your service name differs."
fi

echo "🎉 Done."
EOF

chmod +x /usr/local/bin/add-prometheus-target.sh
echo "✅ add-prometheus-target.sh installed at /usr/local/bin/ — run it anytime with: sudo add-prometheus-target.sh"