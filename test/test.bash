#!/bin/bash
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

echo "=== シフトスケジュールシステムテスト開始 ==="

colcon build
source ~/ros2_ws/install/setup.bash

echo "shift_publisher ノードを確認します"
running_nodes=$(ros2 node list | grep "/shift_publisher")

if [ -n "$running_nodes" ]; then
    echo "既存のshift_publisher ノードがあります。対応するプロセスを停止します"
    existing_pids=$(pgrep -f "ros2 run mypkg shift_publisher")

    if [ -n "$existing_pids" ]; then
        echo "停止するプロセスID: $existing_pids"
        kill $existing_pids
        sleep 2 
    fi

    remaining_pids=$(pgrep -f "ros2 run mypkg shift_publisher")
    if [ -n "$remaining_pids" ]; then
        echo "強制終了します"
        kill -9 $remaining_pids
        sleep 1
    fi
fi

echo "新しい shift_publisher ノードを起動します"
timeout 15s ros2 run mypkg shift_publisher > /tmp/shift_schedule_output.log 2>&1 &
shift_publisher_pid=$!

sleep 10

echo "=== /shift_schedule トピックの出力 ==="
timeout 20 ros2 topic echo /shift_schedule > /tmp/shift_schedule_topic_output.log 2>&1 &
topic_capture_pid=$!

sleep 10
echo "=== ログファイルの内容 ==="
tail -n 20 /tmp/shift_schedule_topic_output.log

if grep -q "シフトスケジュール" /tmp/shift_schedule_topic_output.log; then
  echo "シフトスケジュールデータが正しく出力されました。成功です。"
else
  echo "シフトスケジュールデータが出力されていません。エラーです。"
fi

if ps -p $shift_publisher_pid > /dev/null; then
    echo "shift_publisher ノードを終了します (PID: $shift_publisher_pid)..."
    kill $shift_publisher_pid
    sleep 1
fi

if ps -p $topic_capture_pid > /dev/null; then
    echo "トピックキャプチャプロセスを終了します (PID: $topic_capture_pid)..."
    kill $topic_capture_pid
    sleep 1
fi

echo "=== 現在のノードリスト ==="
ros2 node list

echo "=== シフトスケジュールシステムテスト終了 ==="

