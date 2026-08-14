set -ouex pipefail

# All remove DNF-related operations should be done here whenever possible

# Packages to exclude - common to all versions
EXCLUDED_PACKAGES=(
    cosign
    fedora-bookmarks
    fedora-chromium-config
    fedora-chromium-config-gnome
    firefox
    firefox-langpacks
    gnome-extensions-app
    gnome-shell-extension-background-logo
    gnome-software-rpm-ostree
    gnome-terminal-nautilus
    podman-docker
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
