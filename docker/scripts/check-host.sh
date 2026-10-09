#!/usr/bin/env bash
set -e

echo "=== NVIDIA GPU ==="
nvidia-smi || true

echo
echo "=== Docker ==="
docker --version || true

echo
echo "=== NVIDIA container GPU test ==="
docker run --rm --gpus all nvidia/cuda:12.8.1-base-ubuntu22.04 nvidia-smi || true

echo
echo "=== SO-101 candidate serial devices ==="
ls -l /dev/ttyACM* /dev/ttyUSB* 2>/dev/null || true

echo
echo "=== USB devices ==="
lsusb || true
