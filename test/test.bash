#!/bin/bash

# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

# 初期設定
dir=~
[ "$1" != "" ] && dir="$1"  # 引数があればディレクトリを変更

# ROS 2ワークスペースに移動してビルド
cd $dir/ros2_ws || { echo "ROS 2 ワークスペースが見つかりません。"; exit 1; }
colcon build
source $dir/ros2_ws/install/setup.bash

# 出力ログファイル
LOG_FILE="/tmp/mypkg_crypto_test.log"

# 仮想通貨価格のノードをバックグラウンドで実行
echo "仮想通貨価格ノードをバックグラウンドで起動中..."
ros2 run mypkg crypto_price_publisher > "$LOG_FILE" &
NODE_PID=$!

# トピックの内容を一定時間監視してログを収集
echo "トピック /crypto_prices ..."
timeout 10 ros2 topic echo /crypto_prices > /tmp/mypkg_topic_test.log

# ノードを終了
kill $NODE_PID

# トピックログを検証
if grep -q '仮想通貨価格' "$LOG_FILE"; then
    echo "テスト成功: ログに仮想通貨価格が含まれています。"
    exit 0
else
    echo "テスト失敗: ログに仮想通貨価格が含まれていません。"
    exit 1
fi
