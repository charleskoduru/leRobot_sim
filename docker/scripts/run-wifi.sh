#!/usr/bin/env bash
set -e

ROBOT_PORT="${ROBOT_PORT:-/dev/ttyACM0}"
ROBOT_ID="${ROBOT_ID:-so101_follower_arm}"

echo "Starting Quest 3 Wi-Fi teleoperation."
echo "Robot: ${ROBOT_PORT}"
echo
echo "When CloudXR starts, note the workstation IP and open the CloudXR web client"
echo "from Meta Quest Browser on the same LAN."

exec python -m examples.isaac_teleop_to_so101.teleoperate \
  --robot.type=so101_follower \
  --robot.port="${ROBOT_PORT}" \
  --robot.id="${ROBOT_ID}" \
  --teleop.type=xr_controller
