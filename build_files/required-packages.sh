set -ouex pipefail

# All DNF-related operations should be done here whenever possible

# Base packages from repos - common to all versions
SHARED_PACKAGES=(
    # Gnome minimal desktop
    NetworkManager-wifi
    # PackageKit-command-not-found
    # PackageKit-gtk3-module
    audit
    bpftool
    dconf
    dnsmasq
    firewalld
    fprintd-pam
    git-core
    git-core-doc
    gdm
    glibc-all-langpacks
    gnome-bluetooth
    gnome-control-center
    gnome-disk-utility
    gnome-initial-setup
    gnome-session-wayland-session
    gnome-settings-daemon
    gnome-shell
    gnome-shell-extension-background-logo
    gnome-software
    # gvfs-fuse
    iw
    iwlwifi-dvm-firmware
    iwlwifi-mvm-firmware
    mesa-dri-drivers
    mesa-vulkan-drivers
    nautilus
    orca
    plymouth-system-theme
    polkit
    ptyxis
    rsync
    realmd
    smartmontools
    tracker
    tracker-miners
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-user-dirs-gtk
    yelp-tools
    vim-enhanced
)

# centos specific packages
CENTOS_PACKAGES=(
    centos-backgrounds
)

FEDORA_PACKAGES=(

)

FONTS_PACKAGES=(
    default-fonts-cjk-mono
    default-fonts-cjk-sans
    default-fonts-cjk-serif
    default-fonts-core-emoji
    default-fonts-core-math 
    default-fonts-core-mono
    default-fonts-core-sans
    default-fonts-core-serif
    default-fonts-other-mono
    default-fonts-other-sans
    default-fonts-other-serif
    dejavu-sans-fonts
    dejavu-sans-mono-fonts
    dejavu-serif-fonts
    google-carlito-fonts
    google-crosextra-caladea-fonts
    google-droid-sans-fonts
    google-droid-sans-mono-fonts
    google-droid-serif-fonts
    google-noto-emoji-fonts
    google-noto-fonts-all
    google-noto-sans-cjk-fonts
    google-roboto-slab-fonts pt-sans-fonts
    redhat-display-vf-fonts
    redhat-mono-vf-fonts
    redhat-text-vf-fonts    
)

# Guest Desktop Agents
GUEST_DESKTOP_AGENTS=(
    hyperv-daemons
#    open-vm-tools-desktop
#    qemu-guest-agent
#    spice-vdagent
)

# Install all packages
echo "Installing ${#SHARED_PACKAGES[@]} packages from repos..."
dnf -y --setopt=install_weak_deps=False install "${SHARED_PACKAGES[@]}" "${GUEST_DESKTOP_AGENTS[@]}" "${FONTS_PACKAGES[@]}"

# shall be installed from EPEL repository to be added later
# dnf -y install NetworkManager-openconnect.x86_64 NetworkManager-openconnect-gnome.x86_64 NetworkManager-openvpn.x86_64 NetworkManager-openvpn-gnome.x86_64

# useful for secure archive.
# dnf -y install restic.x86_64 

# intall podman-compose
# pip3 install podman-compose

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

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
