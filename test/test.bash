#!/bin/bash
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

# ディレクトリの設定（引数が指定されていなければホームディレクトリ）
dir=~
[ "$1" != "" ] && dir="$1"

# ワークスペースに移動してビルド
echo "=== シフトスケジュールシステムテスト開始 ==="
cd $dir/ros2_ws || { echo "Error: Could not navigate to $dir/ros2_ws"; exit 1; }
colcon build || { echo "Error: Build failed"; exit 1; }
source $dir/ros2_ws/install/setup.bash

# 既存の shift_publisher ノードを停止する
echo "既存の shift_publisher ノードを停止します..."
pid=$(ps aux | grep '[s]hift_publisher' | awk '{print $2}')
if [ ! -z "$pid" ]; then
  kill -9 $pid
  echo "shift_publisher ノードを停止しました。"
else
  echo "実行中の shift_publisher ノードはありません。"
fi

# shift_publisher ノードをバックグラウンドで起動
echo "shift_publisher ノードを起動します..."
ros2 run mypkg shift_publisher &
publisher_pid=$!

# ノードが初期化するのを待つ
echo "ノードが初期化するのを待っています..."
sleep 5  # 必要に応じて増やしてください

# トピック /shift_schedule の出力をキャプチャするために一定時間の制限を設けて実行
echo "トピック /shift_schedule の出力をキャプチャ中..."
timeout 30 ros2 topic echo /shift_schedule | tee /tmp/shift_schedule_output.log

# 出力されている内容を確認
echo "ログファイルの結果を解析中..."

# `shift_publisher`が出力する内容を柔軟に確認
if grep -q '日付:' /tmp/shift_schedule_output.log && grep -q 'シフトスケジュール:' /tmp/shift_schedule_output.log; then
    echo "=== シフトスケジュールシステムテスト成功！ ==="
else
    echo "=== シフトスケジュールシステムテスト失敗 ==="
    echo "出力内容:"
    cat /tmp/shift_schedule_output.log
fi

# shift_publisher ノードを停止する
echo "shift_publisher ノードを停止します..."
kill -9 $publisher_pid
echo "shift_publisher ノードを停止しました。"

echo "=== シフトスケジュールシステムテスト終了 ==="

