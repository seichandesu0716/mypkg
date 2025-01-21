#!/bin/bash
# SPDX-License-Identifier: BSD-3-Clause

echo "=== シフトスケジュールテスト開始 ==="

# デフォルトのディレクトリを設定
dir=~
[ "$1" != "" ] && dir="$1"

# ワークスペースに移動
cd "$dir/ros2_ws" || { echo "ワークスペースに移動できません: $dir/ros2_ws"; exit 1; }

# ビルドと環境設定
echo "ビルドを開始します..."
colcon build || { echo "ビルドに失敗しました"; exit 1; }

source "$dir/.bashrc"
source /opt/ros/foxy/setup.bash || { echo "ROS 2 環境のセットアップに失敗しました"; exit 1; }

# shift_publisher ノードをバックグラウンドで起動
echo "ShiftPublisher ノードを起動します..."
timeout 20 ros2 run mypkg shift_publisher > /dev/null 2>&1 &
publisher_pid=$!

# トピックが発行されるのを待つ
echo "トピック /shift_schedule の公開を待機中..."
sleep 5

# トピック /shift_schedule のデータを取得
echo "トピック /shift_schedule のデータをキャプチャ中..."
timeout 15 ros2 topic echo /shift_schedule > /tmp/shift_schedule.log || {
    echo "トピックデータの取得に失敗しました";
    kill $publisher_pid 2>/dev/null
    exit 1;
}

# ログ内容を確認
echo "=== ログ内容 ==="
cat /tmp/shift_schedule.log

if grep -q 'シフトスケジュール:' /tmp/shift_schedule.log; then
    echo "テスト成功: シフトスケジュールデータが正しく出力されました。"
else
    echo "テスト失敗: シフトスケジュールデータが見つかりません。"
fi

# ShiftPublisher ノードを終了
if ps -p $publisher_pid > /dev/null 2>&1; then
    echo "ShiftPublisher ノードを終了します..."
    kill $publisher_pid 2>/dev/null
fi

# 一時ファイルを削除
rm -f /tmp/shift_schedule.log

echo "=== シフトスケジュールテスト終了 ==="

