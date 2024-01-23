#!/usr/bin/env bash
# MOTD Disabler

[ -r /etc/os-release ] && . /etc/os-release

if [[ $ID != "ubuntu" ]]; then
  echo "Script intended for Debian-like distributions only."
  exit 2
fi

printf "Welcome to %s (%s %s %s)\n" "$VERSION" "$(uname -o)" "$(uname -r)" "$(uname -m)"

MOTD_SCRIPTS=(
  "/etc/update-motd.d/10-help-text"
  "/etc/update-motd.d/50-motd-news"
  "/etc/update-motd.d/95-hwe-eol"
)

for script in "${MOTD_SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    chmod -x "$script"
    echo "Disabled MOTD script: $script"
  else
    echo "MOTD script not found: $script"
  fi
done
