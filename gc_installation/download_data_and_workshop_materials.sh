#!/bin/bash

# --- Config ---
GROUP="trainees"
NUM_USERS=30
SHARED_DIR="/opt/workshop_shared"
REPO_URL="https://github.com/SydneyBioX/2025_CUHK_workshop.git"
DATA_URL="https://www.dropbox.com/scl/fi/92h9jd23kxz7i62op2a5u/data.zip?rlkey=ycncox2mmds8555nps0z2p0t3&dl=1"  # direct download

# --- Group ---
getent group "$GROUP" >/dev/null || sudo groupadd "$GROUP"

# --- Shared cache (download once) ---
sudo mkdir -p "$SHARED_DIR"
sudo chown root:root "$SHARED_DIR"
sudo chmod 755 "$SHARED_DIR"

# Clone or update the Git repo
if [ ! -d "$SHARED_DIR/2025_CUHK_workshop/.git" ]; then
  echo "[*] Cloning workshop repo..."
  sudo git clone "$REPO_URL" "$SHARED_DIR/2025_CUHK_workshop"
else
  echo "[*] Updating workshop repo..."
  sudo git -C "$SHARED_DIR/2025_CUHK_workshop" pull --ff-only
fi

# --- Download and unzip data once ---
echo "[*] Downloading and extracting data.zip..."
sudo wget -O "$SHARED_DIR/data.zip" "$DATA_URL"

# install unzip if not present
if ! command -v unzip &>/dev/null; then
  sudo apt-get update -y
  sudo apt-get install -y unzip
fi

# unzip into $SHARED_DIR/data
sudo rm -rf "$SHARED_DIR/data"
sudo unzip -q "$SHARED_DIR/data.zip" -d "$SHARED_DIR"
sudo chmod -R 755 "$SHARED_DIR/data"

# --- Create users & copy materials ---
for ((i=1; i<=NUM_USERS; i++)); do
  user="user${i}"
  home="/home/${user}"

  # Create user if missing
  if ! id "$user" &>/dev/null; then
    echo "[*] Creating $user..."
    sudo useradd -g "$GROUP" -d "$home" -m -s /bin/bash "$user"
    echo "${user}:2025" | sudo chpasswd
  fi

  # Copy workshop repo and unzipped data folder
  sudo mkdir -p "$home/2025_CUHK_workshop"
  sudo cp -a "$SHARED_DIR/2025_CUHK_workshop/." "$home/2025_CUHK_workshop/"
  sudo cp -a "$SHARED_DIR/data" "$home/data"

  # Fix ownership
  sudo chown -R "$user:$GROUP" "$home/2025_CUHK_workshop" "$home/data"
done

echo "[✓] All trainee accounts now have 2025_CUHK_workshop and data folder."
