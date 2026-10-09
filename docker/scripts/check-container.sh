#!/usr/bin/env bash
set -e

echo "Python:"
python --version

echo
echo "LeRobot import:"
python -c "import lerobot; print('lerobot OK:', lerobot.__file__)"

echo
echo "Isaac Teleop import:"
python -c "import isaacteleop; print('isaacteleop OK:', isaacteleop.__file__)"

echo
echo "GPU:"
nvidia-smi || true

echo
echo "Serial candidates:"
ls -l /dev/ttyACM* /dev/ttyUSB* 2>/dev/null || true

echo
echo "ADB:"
adb devices || true
