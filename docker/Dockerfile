# SO-101 + LeRobot + SAPIEN/ManiSkill + RealSense RGB-D
# Base: Ubuntu 22.04 / CUDA 12.8 runtime
FROM nvidia/cuda:12.8.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    UV_LINK_MODE=copy \
    PATH="/root/.local/bin:/workspace/.venv/bin:${PATH}" \
    HF_HOME=/workspace/.cache/huggingface \
    HF_LEROBOT_HOME=/workspace/.cache/lerobot \
    MUJOCO_GL=glfw \
    PYOPENGL_PLATFORM=glx \
    LIBGL_ALWAYS_INDIRECT=0 \
    QT_X11_NO_MITSHM=1

############################################################
# Ubuntu runtime/build packages
############################################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    ffmpeg \
    iproute2 \
    iputils-ping \
    libegl1 \
    libgl1 \
    libgl1-mesa-glx \
    libglfw3 \
    libglew2.2 \
    libgles2 \
    libglib2.0-0 \
    libice6 \
    libosmesa6 \
    libsm6 \
    libudev1 \
    libusb-1.0-0 \
    libvulkan1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxcursor1 \
    libxext6 \
    libxi6 \
    libxinerama1 \
    libxrandr2 \
    libxrender1 \
    mesa-utils \
    vulkan-tools \
    nano \
    net-tools \
    openssh-client \
    openssl \
    udev \
    unzip \
    usbutils \
    wget \
    android-tools-adb \
    && rm -rf /var/lib/apt/lists/*

############################################################
# uv + Python 3.12
############################################################
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN /root/.local/bin/uv python install 3.12

WORKDIR /workspace

############################################################
# Clone repositories into the image.
# compose.yaml can bind-mount your local repos over these at runtime.
############################################################
RUN git clone \
    https://github.com/charleskoduru/lerobot_ik_fk.git \
    /workspace/lerobot

RUN git clone \
    https://github.com/charleskoduru/telerobot.git \
    /workspace/telerobot

############################################################
# Python virtual environment
############################################################
RUN uv venv --python 3.12 /workspace/.venv

############################################################
# PyTorch CUDA 12.8
# Install explicitly so ManiSkill and LeRobot share one CUDA-enabled torch.
############################################################
ARG PYTORCH_INDEX_URL=https://download.pytorch.org/whl/cu128
RUN uv pip install --no-cache \
    --index-url "${PYTORCH_INDEX_URL}" \
    torch \
    torchvision

############################################################
# LeRobot + Hugging Face dataset support
############################################################
WORKDIR /workspace/lerobot

RUN uv pip install --no-cache \
    -e ".[feetech,kinematics,dataset,viz]" \
    "huggingface_hub>=1.5"

# Keep compatibility with the user's existing LeRobot setup.
RUN uv pip install --no-cache --force-reinstall draccus==0.10.0

############################################################
# SAPIEN + ManiSkill
# ManiSkill is the high-level environment layer; SAPIEN provides physics/rendering.
############################################################
RUN uv pip install --no-cache \
    "sapien==3.0.3" \
    "mani_skill==3.0.1"

############################################################
# RealSense + Isaac Teleop + robotics utilities
############################################################
RUN uv pip install --no-cache \
    "isaacteleop[cloudxr,retargeters-lite]~=1.3.131" \
    pyrealsense2 \
    mujoco \
    scipy \
    numpy \
    opencv-python \
    imageio \
    imageio-ffmpeg \
    mediapy \
    matplotlib \
    pyyaml \
    transforms3d \
    pytransform3d \
    websockets \
    aiohttp \
    aiohttp-cors \
    aiortc \
    rerun-sdk

############################################################
# Telerobot
############################################################
WORKDIR /workspace/telerobot
RUN uv pip install --no-cache -e .

############################################################
# Vulkan / NVIDIA
# IMPORTANT:
# Do NOT write a fake NVIDIA Vulkan ICD JSON into the image.
# At runtime, nvidia-container-toolkit + NVIDIA_DRIVER_CAPABILITIES=all
# should mount the host NVIDIA userspace driver and Vulkan ICD.
############################################################
RUN mkdir -p /tmp/runtime-root \
    /workspace/simulation \
    /workspace/assets \
    /workspace/datasets \
    /workspace/user \
    && chmod 700 /tmp/runtime-root

############################################################
# Runtime validation
# After the container starts, validate with:
#   nvidia-smi
#   vulkaninfo --summary
#   python -c "import torch, sapien, mani_skill, pyrealsense2, lerobot; print(torch.cuda.is_available())"
############################################################

############################################################
# Gnirehtet for Quest networking
############################################################
ARG GNIREHTET_VERSION=2.5.1

RUN wget -q \
    "https://github.com/Genymobile/gnirehtet/releases/download/v${GNIREHTET_VERSION}/gnirehtet-rust-linux64-v${GNIREHTET_VERSION}.zip" \
    -O /tmp/gnirehtet.zip \
    && unzip /tmp/gnirehtet.zip -d /opt/gnirehtet \
    && chmod +x /opt/gnirehtet/gnirehtet-rust-linux64/gnirehtet \
    && ln -s /opt/gnirehtet/gnirehtet-rust-linux64/gnirehtet /usr/local/bin/gnirehtet \
    && rm /tmp/gnirehtet.zip

############################################################
# Preserve existing Quest/LeRobot helper scripts
############################################################
COPY scripts /usr/local/bin/quest-lerobot-scripts
RUN chmod +x /usr/local/bin/quest-lerobot-scripts/*.sh

WORKDIR /workspace
CMD ["/bin/bash"]
