set -ouex pipefail

# All remove DNF-related operations should be done here whenever possible

# Packages to exclude - common to all versions
EXCLUDED_PACKAGES=(
    avahi
    cosign
    fedora-bookmarks
    fedora-chromium-config
    fedora-chromium-config-gnome
    firefox
    firefox-langpacks
    gnome-boxes
    gnome-browser-connector
    gnome-calculator
    gnome-calendar
    gnome-calendar
    gnome-characters
    gnome-classic-session
    gnome-clocks
    gnome-color-manager
    gnome-connections
    gnome-contacts
    gnome-disk-utility
    gnome-epub-thumbnailer
    gnome-extensions-app
    gnome-font-viewer
    gnome_keyring
    gnome-logs
    gnome-maps
    gnome-remote-desktop
    gnome-shell-extension-background-logo
    gnome-system-monitor
    gnome-user-docs
    gnome-user-share
    gnome-weather
    gnome-software-rpm-ostree
    gnome-terminal-nautilus
    podman-docker
    qemu-user-static
    qemu-user-static-aarch64
    qemu-user-static-arm
    qemu-user-static-x86
    yelp
    subscription-manager
    subscription-manager-rhsm-certificates
)

# Remove excluded packages if they are installed
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    readarray -t INSTALLED_EXCLUDED < <(rpm -qa --queryformat='%{NAME}\n' "${EXCLUDED_PACKAGES[@]}" 2>/dev/null || true)
    if [[ "${#INSTALLED_EXCLUDED[@]}" -gt 0 ]]; then
        dnf -y remove "${INSTALLED_EXCLUDED[@]}"
    else
        echo "No excluded packages found to remove."
    fi
fi
