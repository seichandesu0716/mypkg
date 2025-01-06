#!/bin/bash -xv
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"

# ROS 2ワークスペースに移動
cd "$dir/ros2_ws" || exit 1

# ROS 2ワークスペースのビルド
colcon build

# 環境のセットアップ
source "$dir/.bashrc"

# シフトスケジュールノードの実行
timeout 10 ros2 run mypkg shift_publisher > /tmp/mypkg.log 2>&1

# ログ出力の確認
if grep -q "日付:" /tmp/mypkg.log && \
   grep -q "ホール:" /tmp/mypkg.log && \
   grep -q "キッチン:" /tmp/mypkg.log; then
  echo "Test Passed: All expected outputs are present."
else
  echo "Test Failed: Some expected outputs are missing."
  cat /tmp/mypkg.log
  exit 1
fi

# トピック出力の確認
if timeout 5 ros2 topic echo /shift_schedule > /tmp/shift_topic.log 2>&1; then
  if grep -q "日付:" /tmp/shift_topic.log && \
     grep -q "ホール:" /tmp/shift_topic.log && \
     grep -q "キッチン:" /tmp/shift_topic.log; then
    echo "Test Passed: /shift_schedule topic contains expected data."
  else
    echo "Test Failed: /shift_schedule topic is missing expected data."
    cat /tmp/shift_topic.log
    exit 1
  fi
else
  echo "Test Failed: /shift_schedule topic did not respond in time."
  exit 1
fi

echo "All tests passed successfully."
exit 0

