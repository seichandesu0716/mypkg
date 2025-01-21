#!/bin/bash

# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

dir=~
[ "$1" != "" ] && dir="$1"  # 引数があればディレクトリを変更

cd $dir/ros2_ws || exit 1
colcon build
source /opt/ros/foxy/setup.bash  # 必須: ROS 2の環境変数を設定

LOG_FILE="/tmp/mypkg_crypto_test.log"

echo "仮想通貨価格ノードをバックグラウンドで起動中..."
ros2 run mypkg crypto_price_publisher > "$LOG_FILE" &
NODE_PID=$!

echo "トピック /crypto_prices を監視中..."
timeout 10 ros2 topic echo /crypto_prices > /tmp/mypkg_topic_test.log


if grep -q '仮想通貨価格' /tmp/mypkg_topic_test.log; then
    echo "テスト成功: トピック /crypto_prices に仮想通貨価格が含まれています。"
    echo "==== トピックログの内容 ===="
    cat /tmp/mypkg_topic_test.log
    echo "==========================="
    exit 0
else
    echo "テスト失敗: トピック /crypto_prices に仮想通貨価格が含まれていません。"
    echo "==== トピックログの内容 ===="
    cat /tmp/mypkg_topic_test.log
    echo "==========================="
    exit 1
fi

