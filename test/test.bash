#!/bin/bash
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws

# ビルド
colcon build
source $dir/.bashrc
source /opt/ros/foxy/setup.bash

# シフトスケジュールノードの実行
echo "Running shift_publisher node..."
ros2 run mypkg shift_publisher &

# 少し待機してからトピックのデータを確認
echo "Waiting for shift_publisher node to publish data..."
sleep 5  # 5秒待機（必要に応じて調整）

# トピック出力の確認
echo "Checking /shift_schedule topic..."
timeout 10 ros2 topic echo /shift_schedule > /tmp/shift_topic.log 2>&1

# ログの最後の20行を表示
tail -n 20 /tmp/shift_topic.log

# timeout コマンドが正常に終了したかを確認
if [ $? -eq 124 ]; then
  echo "Timeout occurred while waiting for data from /shift_schedule topic"
  exit 1
elif [ $? -ne 0 ]; then
  echo "Failed to read /shift_schedule topic"
  exit 1
fi

echo "Successfully received data from /shift_schedule topic."

