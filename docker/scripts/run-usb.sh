#!/usr/bin/env bash
set -e

ROBOT_PORT="${ROBOT_PORT:-/dev/ttyACM0}"
ROBOT_ID="${ROBOT_ID:-so101_follower_arm}"

echo "Checking Quest USB ADB connection..."
adb devices

echo
echo "Starting Gnirehtet reverse tethering in the background."
echo "On first use, put on the Quest and accept the VPN prompt."
gnirehtet run &
GNIREHTET_PID=$!

cleanup() {
  kill "${GNIREHTET_PID}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

sleep 2

echo
echo "Starting LeRobot + Isaac Teleop."
exec python -m examples.isaac_teleop_to_so101.teleoperate \
  --robot.type=so101_follower \
  --robot.port="${ROBOT_PORT}" \
  --robot.id="${ROBOT_ID}" \
  --teleop.type=xr_controller
