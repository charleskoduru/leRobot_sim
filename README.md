# LeRobot SO-101 + Meta Quest 3 Teleoperation

Docker environment for controlling an SO-101 follower robot using simulation with TeLeRobot and LeRobot.

---

# System Overview

This environment supports:

- Ubuntu host
- NVIDIA GPU + NVIDIA Container Toolkit
- SO-101 follower connected over USB serial
- Meta Quest 3 VR teleoperation
- Quest connection over Wi-Fi or USB networking
- ADB (Android Debug Bridge)
- Gnirehtet USB networking
- End-effector workspace safety bounds
- LeRobot dataset recording
- Hugging Face dataset upload
- LeRobot visualization / Rerun support
- Sapien
- ManiSkill
- Isaac Teleop

## Repository Architecture

Three Git repositories are used:

```text
~/leRobot_teleOP/
│
├── docker/
│   ├── Dockerfile
│   ├── compose.yaml
│   ├── cache/             # Runtime cache - ignored by Git
│   └── ssl_cert/          # SSL keys - ignored by Git
│
├── lerobot/               # charleskoduru/lerobot_ik_fk
│   └── .git/
│
└── telerobot/             # charleskoduru/telerobot
    └── .git/
```

---

## TeLeRobot File Structure and Data Flow



---

# 1. First-Time Setup

## Clone the Repositories

Clone the main Docker project:

```bash
cd ~

git clone https://github.com/charleskoduru/leRobot_sim.git

cd ~/leRobot_sim
```

Clone TeLeRobot:

```bash
git clone https://github.com/charleskoduru/telerobot.git telerobot
```

Clone the custom LeRobot repository:

```bash
git clone https://github.com/charleskoduru/lerobot_ik_fk.git lerobot
```

Verify:

```bash
ls
```

Expected structure:

```text
docker
lerobot
telerobot
README.md
```

---

## Verify Docker and NVIDIA GPU

Check the NVIDIA driver:

```bash
nvidia-smi
```

Check Docker:

```bash
docker --version
```

Verify that Docker can access the GPU:

```bash
docker run --rm --gpus all \
  nvidia/cuda:12.8.1-base-ubuntu22.04 \
  nvidia-smi
```

The NVIDIA GPU should appear inside the Docker container.

---

# 2. Meta Quest 3 Setup

## Configure USB Permissions

Connect the Meta Quest 3 to the Ubuntu computer.

Create the Oculus udev rule:

```bash
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2833", MODE="0660", GROUP="plugdev", TAG+="uaccess"' | \
sudo tee /etc/udev/rules.d/51-oculus.rules
```

Reload the rules:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Reconnect the Quest if necessary.

---

## Verify ADB

ADB is used to communicate with the Meta Quest over USB.

Install ADB 

```bash
sudo apt update
sudo apt install -y adb

```

On the Ubuntu host:

```bash
adb kill-server
adb start-server
adb devices
```

Put on the headset and approve:

```text
Allow USB debugging
```

Run:

```bash
adb devices
```

Expected:

```text
List of devices attached
XXXXXXXXXXXX    device
```

If the device says:

```text
unauthorized
```

put on the Quest and approve the USB debugging prompt.

ADB is also installed inside the Docker image for debugging and development purposes.

---

## Troubleshooting ADB 

If the USB permissions prompt does not show, exit container and go the host terminal. Enter these cmds: 

```bash

adb kill-server
unset ADB_VENDOR_KEYS
rm -f "$HOME/.android/adbkey" "$HOME/.android/adbkey.pub"

```
Reset the headset 

```bash 
adb start-server
```
Plug into the headset 

```bash 
adb devices
```
Then start the docker container again






---

# 3. Build the Docker Image

Go to:

```bash
cd ~/leRobot_sim/docker
```

Build:

```bash
docker compose build
```

There is usually no need to use:

```bash
docker compose build --no-cache
```

unless specifically troubleshooting Docker's build cache.

---

# 4. Start the Teleoperation Environment

## Check Connected Devices

If device names change, update:

```text
docker/compose.yaml
```

---

## Start the Container

```bash
cd ~/leRobot_sim/docker

docker compose run --rm lerobot-so101-sapien
```

The `--rm` option automatically removes the temporary Compose container when it exits.

Inside the container, verify the GPU:

```bash
nvidia-smi
```

Run the container diagnostic script:

```bash
/usr/local/bin/quest-lerobot-scripts/check-container.sh
```

Verify the source repositories:

```bash
ls /workspace/lerobot
ls /workspace/telerobot
```

These directories should contain the host repositories mounted by Docker Compose.

---
## Setup Hugging face
```bash
hf auth login
```
Follow the directions. 
Note: stores its credentials under HF_HOME, which is inside /workspace/.cache, and that directory is mounted to your host. So you only need to do this once. 


---
## Optional: Quest USB Networking with Gnirehtet

Gnirehtet routes Quest network traffic through USB rather than relying entirely on Wi-Fi.


Start it in the foreground after starting container:

```bash
gnirehtet run
```

Approve the VPN/network permission prompt inside the Quest if requested.

To run it in the background:

```bash
gnirehtet run > /tmp/gnirehtet.log 2>&1 &
```

Verify:

```bash
pgrep -af gnirehtet
```


Stop Gnirehtet:

```bash
pkill gnirehtet
```
---

# 5. Normal Startup

After first-time setup, this is the normal workflow.

## Step 1 — Start Docker

```bash
cd ~/leRobot_sim/docker

docker compose run --rm lerobot-so101-sapien

```
--- 

## Step 2 — Start Quest USB Networking

