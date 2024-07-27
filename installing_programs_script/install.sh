#!/bin/bash

# +-----------------------------+
# | Installation configurations |
# +-----------------------------+

# Main
install_office = true
install_kde = true
install_dev_tools = true
install_flatpak = false # if user has no flatpak yet; requires restart
install_flatpaks = true
install_aurs = true
install_zsh = true
install_yay = false
#install_powerlevel10k_zsh_theme = false # done as separate script; requires zsh and yay, also reboot before doing it or run zsh config in any other way

# KDE
install_chemistry = true
install_teatime = true
install_graphical_design = true
install_virtualbox = true

# dev_tools
install_java = true # java's probably too popular to be optional
install_c = true
install_python = true


# Conditional Flatpak applications
install_spotify=false

browsers=(
  [chromium] = true
  [firefox]  = true
  [vivaldi]  = false
  [brave]    = true
  [opera]    = false
  [tor]      = true
)

messengers=(
  [telegram] = true
  [signal]   = true
  [whatsapp] = false
  [discord]  = true
  [zoom]     = true
  [slack]    = true
)

# helper variables
browser_flatpak=(
  [chromium] = "org.chromium.Chromium"
  [firefox]  = "org.mozilla.firefox"
  [vivaldi]  = "com.vivaldi.Vivaldi"
  [brave]    = "com.brave.Browser"
  [opera]    = "com.opera.Opera"
  [tor]      = "org.torproject.torbrowser-launcher"
)

messengers_flatpack=(
  [telegram] = "org.telegram.desktop"
  [signal]   = "org.signal.Signal"
  [whatsapp] = "chat.rocket.RocketChat"
  [discord]  = "chat.rocket.RocketChat"
  [zoom]     = "com.discordapp.Discord"
  [slack]    = "com.slack.Slack"
)

function add_to_list_by_dict_condition() { # args: 1 - condition dict, 2 - to add dict, 3 - list for addition
  for element in "{!$1[@]}"; do
    if [ -n "$2[$element]" ]; then
      $3 += (
        "${$2[$element]}"
      )
    else
      echo "No script for $element installation"
    fi
  done
} # not sure if works

# Function to check presence in list
function is_in_list {
  local element
  for element in "${@:2}"; do [[ "$element" == "$1" ]] && return 0; done
  return 1
}

# Function to check presence in list


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
# kcolorchooser         # Color chooser for KDE
  kcharselect           # Character selector for KDE
  khelpcenter           # Documentation and help viewer for KDE
  skanlite              # Image scanning application for KDE
  ktorrent              # BitTorrent client for KDE
  elisa                 # Music player for KDE
  kamoso                # Webcam application for KDE
# kalzium               # Periodic table of elements for KDE
# kteatime              # Tea cooking timer for KDE
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
#  valgrind              # Instrumentation framework for building dynamic analysis tools
#  jdk-openjdk           # OpenJDK Java Development Kit
  make                  # Build automation tool
#  gcc                   # GNU Compiler Collection
  git                   # Distributed version control system
#  python                # Python programming language
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
  #org.gimp.GIMP                  # GIMP image editor
  io.mpv.Mpv                     # MPV media player
  com.obsproject.Studio          # OBS Studio
  com.valvesoftware.Steam        # Steam
  org.pipewire.Helvum            # Helvum for PipeWire
)

# Add browsers to flatpaks list if specified
#for browser in "${browsers[@]}"; do
#  case $browser in
#    chromium)
#      flatpaks+=("org.chromium.Chromium")
#      ;;
#    firefox)
#      flatpaks+=("org.mozilla.firefox")
#      ;;
#    vivaldi)
#      flatpaks+=("com.vivaldi.Vivaldi")
#      ;;
#    brave)
#      flatpaks+=("com.brave.Browser")
#      ;;
#    tor)
#      flatpaks+=("org.torproject.torbrowser-launcher")
#      ;;
#    opera)
#      flatpaks+=("com.opera.Opera")
#      ;;
#    *)
#      echo "Unknown browser: $browser"
#      ;;
#  esac
#done

add_to_list_by_dict_condition "$browsers" "$browser_flatpak" "$flatpaks"

add_to_list_by_dict_condition "$messengers" "$messengers_flatpack" "$flatpaks"

## Add messengers to flatpaks list if specified
#for messenger in "${messengers[@]}"; do
#  case $messenger in
#    telegram)
#      flatpaks+=("org.telegram.desktop")
#      ;;
#    signal)
#      flatpaks+=("org.signal.Signal")
#      ;;
#    whatsapp)
#      flatpaks+=("chat.rocket.RocketChat")
#      ;;
#    discord)
#      flatpaks+=("com.discordapp.Discord")
#      ;;
#    zoom)
#      flatpaks+=("us.zoom.Zoom")
#      ;;
#    slack)
#      flatpaks+=("com.slack.Slack")
#      ;;
#    *)
#      echo "Unknown messenger: $messenger"
#      ;;
#  esac
#done

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
  #flatpak
  which
  wine
  vim
  #virtualbox
)

if $install_virtualbox; then
  aurs += (virtualbox)
fi

if $install_flatpak; then
  aurs += (flatpak)
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
fi
# +---------------------------+
# | Install development tools |
# +---------------------------+

if $install_dev_tools; then
  install_packages "${dev_tools[@]}"
fi

if $install_aurs; then
  install_packages "${aurs[@]}"
fi

if $install_office; then
  install_packages "${office[@]}"
fi

if $install_flatpaks; then
  install_flatpaks "${flatpaks[@]}"
fi

echo "KDE package list have been installed."

# +--------------------------+
# | Install and decorate zsh |
# +--------------------------+

if $install_zsh; then
  pacman -S --noconfirm --needed zsh
  chsh -s $(which zsh)
fi

if $install_yay; then
  pacman -S --noconfirm --needed base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
fi

