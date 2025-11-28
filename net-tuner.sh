#!/bin/bash
echo -e "\nThis script was created by NDEVXLK.\n"
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf >/dev/null
SYSCTL_FILE="/etc/sysctl.conf"
apply_setting() {
    KEY="$1"
    VALUE="$2"
    if grep -qE "^${KEY}\b" "$SYSCTL_FILE"; then
        sudo sed -i "s|^${KEY}.*|${KEY} = ${VALUE}|" "$SYSCTL_FILE"
    else
        echo "${KEY} = ${VALUE}" | sudo tee -a "$SYSCTL_FILE" >/dev/null
    fi
}
apply_setting "net.core.rmem_max" "16777216"
apply_setting "net.core.wmem_max" "16777216"
apply_setting "net.core.default_qdisc" "fq"
apply_setting "net.ipv4.tcp_rmem" "4096 87380 16777216"
apply_setting "net.ipv4.tcp_wmem" "4096 65536 16777216"
apply_setting "net.ipv4.tcp_fastopen" "3"
apply_setting "net.ipv4.tcp_low_latency" "1"
apply_setting "net.ipv4.tcp_congestion_control" "bbr"
sudo sysctl -p
echo -e "\nNetwork tweaks were successfully applied.\n"