# LeRobot SO-101 + Meta Quest 3 Teleoperation

Docker environment for controlling an SO-101 follower robot using simulation with TeLeRobot and LeRobot.

---

#Video

[Watch the xArm6 simulation demo](https://canva.link/rmd4gghv7evjiyv)

[Watch the SO-101 simulation demo](https://canva.link/purzspssoppf7lc)

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

# 2. Build the Docker Image

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

# 3. Start the Teleoperation Environment

## Check Connected Devices

If device names change, update:

```text
docker/compose.yaml
```

---

## Start the Container

```bash
cd ~/leRobot_sim/docker

xhost +local:docker

docker compose run --rm lerobot-sim
```

```
Inside the container: 

```bash
cd ~/telerobot

git switch teleopSim

teleop
```

Open the WebServer client and accept the permissions 



# Troubleshooting: 

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

(Currently troubleshooting episode recording with depth frames)
--- 




