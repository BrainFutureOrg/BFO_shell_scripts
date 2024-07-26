#!/bin/bash

# +----------------------+
# | KDE application list |
# +----------------------+

# Define an array of package names
packages_kde=(
  okular
  dolphin
  konsole
  ark
  plasma-systemmonitor
  kate
  gwenview
  spectacle
  filelight
  kcalc
  partitionmanager
  kfind
  kcolorchooser
  kcharselect
  khelpcenter
  skanlite
  ktorrent
  elisa
  kamoso
  kalzium
  kteatime
  kmix
  krecorder
  kile
)

# Update the package database and upgrade all packages
sudo pacman -Syu

# Install each package
for package in "${packages_kde[@]}"; do
  sudo pacman -S --noconfirm "$package"
done

echo "All specified packages have been installed."
