#!/bin/bash

# +-----------------------------+
# | Installation configurations |
# +-----------------------------+
install_chemistry = true
install_teatime = true
install_graphical_design = true

# dev_tools
install_java = true # java's probably too popular to be optional
install_c = true
install_python = true


# Conditional Flatpak applications
install_spotify=false
install_slack=false

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
)

# helper variables
browser_flatpak=(
  [chromium] = "org.chromium.Chromium"
  [firefox]  = "org.mozilla.firefox"
  [vivaldi]  = "com.vivaldi.Vivaldi"
  [brave]    = "com.brave.Browser"
  [opera]    = "com.opera.Opera"
)

function add_to_list_by_dict_condition() { # args: 1 - condition dict, 2 - to add dict, 3 - list for addition
  for element in "{!$1[@]}"; do
    if [ -n "$2[$element]" ]; then
      $3 += (
        "${$2[$element]}"
      )
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
    sudo pacman -S --noconfirm "$package"
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
  org.gimp.GIMP                  # GIMP image editor
  io.mpv.Mpv                     # MPV media player
  com.obsproject.Studio          # OBS Studio
  com.valvesoftware.Steam        # Steam
  org.pipewire.Helvum            # Helvum for PipeWire
)

# Add browsers to flatpaks list if specified
for browser in "${browsers[@]}"; do
  case $browser in
    chromium)
      flatpaks+=("org.chromium.Chromium")
      ;;
    firefox)
      flatpaks+=("org.mozilla.firefox")
      ;;
    vivaldi)
      flatpaks+=("com.vivaldi.Vivaldi")
      ;;
    brave)
      flatpaks+=("com.brave.Browser")
      ;;
    tor)
      flatpaks+=("org.torproject.torbrowser-launcher")
      ;;
    opera)
      flatpaks+=("com.opera.Opera")
      ;;
    *)
      echo "Unknown browser: $browser"
      ;;
  esac
done

# Add messengers to flatpaks list if specified
for messenger in "${messengers[@]}"; do
  case $messenger in
    telegram)
      flatpaks+=("org.telegram.desktop")
      ;;
    signal)
      flatpaks+=("org.signal.Signal")
      ;;
    whatsapp)
      flatpaks+=("chat.rocket.RocketChat")
      ;;
    discord)
      flatpaks+=("com.discordapp.Discord")
      ;;
    zoom)
      flatpaks+=("us.zoom.Zoom")
      ;;
    *)
      echo "Unknown messenger: $messenger"
      ;;
  esac
done

# Add Spotify and Slack if flags are set
if $install_spotify; then
  flatpaks+=("com.spotify.Client")
fi

if $install_slack; then
  flatpaks+=("com.slack.Slack")
fi



# Update the package database and upgrade all packages
sudo pacman -Syu

# +--------------------------+
# | Install KDE applications |
# +--------------------------+

install_packages "${kde_apps[@]}"

# +---------------------------+
# | Install development tools |
# +---------------------------+

install_packages "${dev_tools[@]}"

install_flatpaks "${flatpaks[@]}"

echo "KDE package list have been installed."

