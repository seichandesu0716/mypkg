#!/bin/bash -xv
# SPDX-License-Identifier: BSD-3-Clause
# シフトスケジュールプログラムのテストスクリプト

# テストが失敗した場合の関数
ng () {
    echo "${1}行目が違うよ"
    res=1
}

# 初期化
res=0

# ROS 2ワークスペースディレクトリを設定
dir=~
[ "$1" != "" ] && dir="$1"

# ROS 2ワークスペースに移動して環境をセットアップ
cd "$dir/ros2_ws" || exit 1
source /opt/ros/<your_ros_distro>/setup.bash
colcon build
source "$dir/.bashrc"

# シフトスケジュールノードを起動
ros2 run mypkg shift_publisher &
NODE_PID=$!
sleep 5  # ノードが完全に起動するまで待機

# トピックから出力を取得
out=$(timeout 5 ros2 topic echo /shift_schedule)

# 出力に期待されるフォーマットが含まれるか確認
echo "$out" | grep -q "日付: " || ng "$LINENO" "Date is missing"
echo "$out" | grep -q "ホール: " || ng "$LINENO" "Hall schedule is missing"
echo "$out" | grep -q "キッチン: " || ng "$LINENO" "Kitchen schedule is missing"

# サンプルチェック（カスタマイズ可能）
echo "$out" | grep -q "高橋" || ng "$LINENO" "Expected member 高橋 not found"
echo "$out" | grep -q "佐々木" || ng "$LINENO" "Expected member 佐々木 not found"

[ "$res" -eq 0 ] && echo "OK"

exit $res

