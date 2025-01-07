#!/bin/bash

echo "=== シフトスケジュールシステムテスト開始 ==="

# ワークスペースをビルドする
colcon build
source ~/ros2_ws/install/setup.bash

# shift_publisher ノードを起動
echo "shift_publisher ノードを起動します..."
ros2 run mypkg shift_publisher &

# 少し待機（ノード起動を待つ）
sleep 2

# トピック /shift_schedule の出力をキャプチャする（10秒間）
echo "=== /shift_schedule トピックの出力 ==="
timeout 10 ros2 topic echo /shift_schedule --no-arr > /tmp/shift_schedule_output.log
topic_status=$?

# 終了ステータスを確認
if [ $topic_status -eq 0 ]; then
  echo "トピック出力に成功しました。"
else
  echo "トピックの出力に失敗しました。エラーコード: $topic_status"
fi

# ログファイルの内容を確認
echo "=== ログファイルの内容 ==="
cat /tmp/shift_schedule_output.log

# シフトスケジュールデータが出力されているかチェック
if grep -q "日付:" /tmp/shift_schedule_output.log; then
  echo "シフトスケジュールデータが正しく出力されました。成功です。"
else
  echo "シフトスケジュールデータが出力されていません。エラーです。"
fi

# ノードを停止
echo "shift_publisher ノードを停止します..."
kill %1

# 終了
echo "=== シフトスケジュールシステムテスト終了 ==="

