#!/bin/bash -xv
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"

# ROS 2ワークスペースに移動
cd "$dir/ros2_ws" || { echo "Failed to change directory to $dir/ros2_ws"; exit 1; }

# ROS 2ワークスペースのビルド
echo "Building ROS 2 workspace..."
colcon build
if [ $? -ne 0 ]; then
  echo "Build failed"
  exit 1
fi

# 環境のセットアップ
echo "Setting up the environment..."
source "$dir/.bashrc"
if [ $? -ne 0 ]; then
  echo "Failed to source .bashrc"
  exit 1
fi

# シフトスケジュールノードの実行
echo "Running shift_publisher node..."
ros2 run mypkg shift_publisher &
SHIFT_PID=$!

# 少し待機してからトピックのデータを確認
sleep 5  # 少し待機して、ノードがデータを発行する時間を確保

# トピック出力の確認
echo "Checking /shift_schedule topic..."
timeout 10 ros2 topic echo /shift_schedule > /tmp/shift_topic.log 2>&1
if [ $? -ne 0 ]; then
  echo "Failed to read /shift_schedule topic"
  exit 1
fi

# ログファイルの確認
echo "Checking the topic data for expected content..."
if grep -q "日付:" /tmp/shift_topic.log && \
   grep -q "ホール:" /tmp/shift_topic.log && \
   grep -q "キッチン:" /tmp/shift_topic.log; then
  echo "Test Passed: /shift_schedule topic contains expected data."
else
  echo "Test Failed: /shift_schedule topic is missing expected data."
  echo "Topic log content:"
  cat /tmp/shift_topic.log
  exit 1
fi

# ノードの停止
kill $SHIFT_PID
wait $SHIFT_PID

echo "All tests passed successfully."
exit 0

