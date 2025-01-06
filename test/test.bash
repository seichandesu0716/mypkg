#!/bin/bash
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

# ディレクトリの設定（引数が指定されていなければホームディレクトリ）
dir=~
[ "$1" != "" ] && dir="$1"

# ワークスペースに移動してビルド
echo "Navigating to workspace and building..."
cd $dir/ros2_ws || { echo "Error: Could not navigate to $dir/ros2_ws"; exit 1; }
colcon build || { echo "Error: Build failed"; exit 1; }
source $dir/.bashrc
source /opt/ros/foxy/setup.bash

# 既存のshift_publisherノードを停止する
echo "Stopping existing shift_publisher node..."
pid=$(ps aux | grep '[s]hift_publisher' | awk '{print $2}')
if [ ! -z "$pid" ]; then
  echo "Found shift_publisher process with PID $pid. Stopping it."
  kill -9 $pid
  sleep 2
else
  echo "No existing shift_publisher node running."
fi

# shift_publisherノードをバックグラウンドで起動
echo "Launching shift_publisher node..."
timeout 20 ros2 run mypkg shift_publisher &

# 起動後の待機時間
echo "Waiting for node to initialize..."
sleep 5  # 必要に応じて増やしてください

# トピックの出力をキャプチャ
echo "Capturing /shift_schedule topic output..."
timeout 15 ros2 topic echo /shift_schedule > /tmp/shift_schedule.log

# シフトスケジュールの情報が正しく出力されているか確認
echo "Verifying output..."
if grep -q '日付:' /tmp/shift_schedule.log && grep -q 'シフトスケジュール:' /tmp/shift_schedule.log; then
    echo "成功: 正しいシフトスケジュールが出力されました。"
else
    echo "失敗: シフトスケジュールの出力が正しくありません。"
    echo "Log output:"
    cat /tmp/shift_schedule.log
fi

