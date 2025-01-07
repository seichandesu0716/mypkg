# test.bashの変更
#!/bin/bash

echo "=== シフトスケジュールシステムテスト開始 ==="

# ワークスペースをビルド
colcon build
source ~/ros2_ws/install/setup.bash

# shift_publisherノードを実行してログをファイルに出力
echo "shift_publisher ノードを起動します..."
ros2 run mypkg shift_publisher > /tmp/shift_schedule_output.log 2>&1 &

# ノードが起動してしばらく待つ
sleep 3

# トピック /shift_schedule のデータをファイルにキャプチャ
echo "=== /shift_schedule トピックの出力 ==="
ros2 topic echo /shift_schedule > /tmp/shift_schedule_topic_output.log 2>&1 &

# キャプチャが終了した後、最後のログを表示
sleep 3
echo "=== ログファイルの内容 ==="
tail -n 20 /tmp/shift_schedule_topic_output.log

# 成功したか確認
if grep -q "シフトスケジュール" /tmp/shift_schedule_topic_output.log; then
  echo "シフトスケジュールデータが正しく出力されました。成功です。"
else
  echo "シフトスケジュールデータが出力されていません。エラーです。"
fi

# 終了
echo "=== シフトスケジュールシステムテスト終了 ==="

