#!/bin/bash

echo "=== シフトスケジュールシステムテスト開始 ==="

# ワークスペースをビルド
colcon build
source ~/ros2_ws/install/setup.bash

# 実行中の shift_publisher ノードを確認して削除
echo "既存の shift_publisher ノードを確認します..."
running_nodes=$(ros2 node list | grep "/shift_publisher")

if [ -n "$running_nodes" ]; then
    echo "既存の shift_publisher ノードがあります。対応するプロセスを停止します..."
    existing_pids=$(pgrep -f "ros2 run mypkg shift_publisher")

    if [ -n "$existing_pids" ]; then
        echo "停止するプロセスID: $existing_pids"
        kill $existing_pids
        sleep 2  # プロセスの完全停止待ち
    fi

    # 再確認: プロセスがまだ存在している場合は強制終了
    remaining_pids=$(pgrep -f "ros2 run mypkg shift_publisher")
    if [ -n "$remaining_pids" ]; then
        echo "強制終了を試みます..."
        kill -9 $remaining_pids
        sleep 1
    fi
fi

# 新しい shift_publisher ノードを起動
echo "新しい shift_publisher ノードを起動します..."
timeout 15s ros2 run mypkg shift_publisher > /tmp/shift_schedule_output.log 2>&1 &
shift_publisher_pid=$!

# ノードが起動してしばらく待つ
sleep 5

# トピック /shift_schedule のデータをファイルにキャプチャ
echo "=== /shift_schedule トピックの出力 ==="
timeout 10s ros2 topic echo /shift_schedule > /tmp/shift_schedule_topic_output.log 2>&1 &
topic_capture_pid=$!

# トピックキャプチャが終了した後、最後のログを表示
sleep 3
echo "=== ログファイルの内容 ==="
tail -n 20 /tmp/shift_schedule_topic_output.log

# 成功したか確認
if grep -q "シフトスケジュール" /tmp/shift_schedule_topic_output.log; then
  echo "シフトスケジュールデータが正しく出力されました。成功です。"
else
  echo "シフトスケジュールデータが出力されていません。エラーです。"
fi

# 実行中の shift_publisher ノードを終了
if ps -p $shift_publisher_pid > /dev/null; then
    echo "shift_publisher ノードを終了します (PID: $shift_publisher_pid)..."
    kill $shift_publisher_pid
    sleep 1
fi

# キャプチャプロセスを終了
if ps -p $topic_capture_pid > /dev/null; then
    echo "トピックキャプチャプロセスを終了します (PID: $topic_capture_pid)..."
    kill $topic_capture_pid
    sleep 1
fi

# 再確認: ノードのリストを表示
echo "=== 現在のノードリスト ==="
ros2 node list

# 終了
echo "=== シフトスケジュールシステムテスト終了 ==="

