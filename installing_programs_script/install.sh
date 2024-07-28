#!/bin/bash

# +-----------------------------+
# | Installation configurations |
# +-----------------------------+

# Main
install_office=true
install_kde=true
install_dev_tools=true
install_flatpak=false # if user has no flatpak yet; requires restart
install_flatpaks=true
install_aurs=true
install_zsh=true
install_yay=false
#install_powerlevel10k_zsh_theme=false # done as separate script; requires zsh and yay, also reboot before doing it or run zsh config in any other way

# KDE
install_chemistry=true
install_teatime=true
install_graphical_design=true
install_virtualbox=true

# dev_tools
install_java=true # java's probably too popular to be optional
install_c=true
install_python=true

# Conditional Flatpak applications
install_spotify=false

declare -A browsers=(
  [chromium]=true
  [firefox]=true
  [vivaldi]=false
  [brave]=true
  [opera]=false
  [tor]=true
)

declare -A messengers=(
  [telegram]=true
  [signal]=true
  [whatsapp]=false
  [discord]=true
  [zoom]=true
  [slack]=true
)

# helper variables
declare -A browser_flatpak=(
  [chromium]="org.chromium.Chromium"
  [firefox]="org.mozilla.firefox"
  [vivaldi]="com.vivaldi.Vivaldi"
  [brave]="com.brave.Browser"
  [opera]="com.opera.Opera"
  [tor]="org.torproject.torbrowser-launcher"
)

declare -A messengers_flatpak=(
  [telegram]="org.telegram.desktop"
  [signal]="org.signal.Signal"
  [whatsapp]="chat.rocket.RocketChat"
  [discord]="com.discordapp.Discord"
  [zoom]="us.zoom.Zoom"
  [slack]="com.slack.Slack"
)

function add_to_list_by_dict_condition() { # args: 1 - condition dict, 2 - to add dict, 3 - list for addition
  declare -n condition_dict=$1
  declare -n add_dict=$2
  declare -n list=$3
  for element in "${!condition_dict[@]}"; do
    if ${condition_dict[$element]}; then
      if [ -v "add_dict[$element]" ]; then
        list+=("${add_dict[$element]}")
      else
        echo "No script for $element installation"
      fi
    fi
  done
}

# Function to install a list of packages
install_packages() {
  local packages=("$@")
  for package in "${packages[@]}"; do
    sudo pacman -S --noconfirm --needed "$package"
  done
}

# Function to install Flatpak applications
install_flatpaks() {
  local flatpaks=("$@")
  for flatpak in "${flatpaks[@]}"; do
    flatpak install flathub "$flatpak" -y
  done
}


# +----------------------+
# | KDE application list |
# +----------------------+

# Define an array of package names
kde_apps=(
  okular                # Document viewer for PDF, Postscript, and many other formats
  dolphin               # File manager for KDE
  konsole               # Terminal emulator for KDE
  ark                   # Archiving tool for KDE
  plasma-systemmonitor  # System monitor for KDE
  kate                  # Advanced text editor for KDE
  gwenview              # Image viewer for KDE
  spectacle             # Screenshot capture utility for KDE
  filelight             # Disk usage analyzer for KDE
  kcalc                 # Scientific calculator for KDE
  partitionmanager      # Disk partition manager for KDE
  kfind                 # File search utility for KDE
  kcharselect           # Character selector for KDE
  khelpcenter           # Documentation and help viewer for KDE
  skanlite              # Image scanning application for KDE
  ktorrent              # BitTorrent client for KDE
  elisa                 # Music player for KDE
  kamoso                # Webcam application for KDE
  kmix                  # Sound mixer for KDE
  krecorder             # Audio recording application for KDE
  kile                  # LaTeX editor for KDE
)

if $install_chemistry; then
  kde_apps+=(
    kalzium               # Periodic table of elements for KDE
  )
fi

if $install_teatime; then
  kde_apps+=(
    kteatime              # Tea cooking timer for KDE
  )
fi

if $install_graphical_design; then
  kde_apps+=(
    kcolorchooser         # Color chooser for KDE
  )
fi

dev_tools=(
  make                  # Build automation tool
  git                   # Distributed version control system
)

if $install_java; then
  dev_tools+=(
    jdk-openjdk           # OpenJDK Java Development Kit
  )
fi

if $install_c; then
  dev_tools+=(
    valgrind              # Instrumentation framework for building dynamic analysis tools
    gcc                   # GNU Compiler Collection
  )
fi

if $install_python; then
  dev_tools+=(
    python                # Python programming language
  )
fi


flatpaks=(
  io.mpv.Mpv                     # MPV media player
  com.obsproject.Studio          # OBS Studio
  com.valvesoftware.Steam        # Steam
  org.pipewire.Helvum            # Helvum for PipeWire
)

add_to_list_by_dict_condition browsers browser_flatpak flatpaks
add_to_list_by_dict_condition messengers messengers_flatpak flatpaks

if $install_graphical_design; then
  flatpaks+=("org.inkscape.Inkscape" "org.gimp.GIMP")
fi

# Add Spotify and Slack if flags are set
if $install_spotify; then
  flatpaks+=("com.spotify.Client")
fi


aurs=(
  htop
  neofetch
  which
  wine
  vim
)

if $install_virtualbox; then
  aurs+=(virtualbox)
fi

if $install_flatpak; then
  aurs+=(flatpak)
fi

office=(
  libreoffice-fresh
)

# Update the package database and upgrade all packages
sudo pacman -Syu

# +--------------------------+
# | Install KDE applications |
# +--------------------------+
if $install_kde; then
  install_packages "${kde_apps[@]}"
  echo "KDE package list have been installed."
fi
# +---------------------------+
# | Install development tools |
# +---------------------------+

if $install_dev_tools; then
  install_packages "${dev_tools[@]}"
  echo "Dev tools package list have been installed."
fi

if $install_aurs; then
  install_packages "${aurs[@]}"
  echo "AUR package list have been installed."
fi

if $install_office; then
  install_packages "${office[@]}"
  echo "Office package list have been installed."
fi

if $install_flatpaks; then
  install_flatpaks "${flatpaks[@]}"
  echo "Flatpak package list have been installed."
fi

# +--------------------------+
# | Install and decorate zsh |
# +--------------------------+

if $install_zsh; then
  pacman -S --noconfirm --needed zsh
  chsh -s $(which zsh)
  echo "ZSH has been installed."
fi

if $install_yay; then
  pacman -S --noconfirm --needed base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  echo "yay has been installed."
fi

