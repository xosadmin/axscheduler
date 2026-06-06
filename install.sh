#!/bin/bash
set -euo pipefail

dstFolder="/opt/axscheduler"
serviceName="axscheduler.service"

if [[ $(whoami) != "root" ]]; then
  echo "Error: this installer must be executed under root user." >&2
  exit 1
fi

scriptDir="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$dstFolder" ]]; then
  echo "Creating folder ${dstFolder}..."
  mkdir -p "$dstFolder"
fi

echo "Installing dependencies..."
apt-get update
apt-get install -y python3 python3-yaml python3-schedule

echo "Copying files..."
cp "${scriptDir}/main.py" "$dstFolder/"
rm -rf "${dstFolder}/utils"
cp -r "${scriptDir}/utils" "$dstFolder/"

echo "Generating config file..."
if [[ -f "${dstFolder}/config.yaml" ]]; then
  echo "Skipped due to existing config file detected."
else
  cat > "${dstFolder}/config.yaml" <<EOF
tasks:
EOF
fi

echo "Installing systemd file..."
cp "${scriptDir}/${serviceName}" "/etc/systemd/system/${serviceName}"
sed -i "s!__CHANGEDIR__!${dstFolder}!g" "/etc/systemd/system/${serviceName}"

systemctl daemon-reload
systemctl enable "$serviceName"
systemctl restart "$serviceName"

echo "Done. AXScheduler is installed and running."
echo "The config file is located in ${dstFolder}/config.yaml"
echo "Check status with: systemctl status ${serviceName}"
echo "Check logs with: journalctl -u ${serviceName} -f"