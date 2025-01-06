#!/usr/bin/python3
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import random
from datetime import datetime, timedelta

class ShiftScheduler(Node):
    def __init__(self):
        super().__init__("shift_scheduler")
        self.publisher_ = self.create_publisher(String, "shift_schedule", 10)

        # 開始日付
        self.current_date = datetime(2024, 12, 30)

        # タイマー: 1秒ごとにスケジュールを公開
        self.timer = self.create_timer(1.0, self.publish_shift_schedule)

        # ホールとキッチンのメンバーを増加
        self.hall_names = ["高橋", "佐々木", "辻", "尾牛山", "坂上", "村田", "斉藤", "藤田"]
        self.kitchen_names = ["落合", "森木", "宮崎", "中村", "鈴木", "田中", "石井", "山本"]

    def publish_shift_schedule(self):
        # ランダムに人数を選択
        selected_hall_names = random.sample(self.hall_names, 4)  # ホールは4人選択
        selected_kitchen_names = random.sample(self.kitchen_names, 3)  # キッチンは3人選択

        # 現在の日付をフォーマット
        date_str = self.current_date.strftime("%Y-%m-%d")

        # スケジュールのメッセージ作成
        hall_schedule = f"ホール: {', '.join(selected_hall_names)}"
        kitchen_schedule = f"キッチン: {', '.join(selected_kitchen_names)}"

        shift_message = String()
        shift_message.data = f"日付: {date_str}\nシフトスケジュール:\n{hall_schedule}\n{kitchen_schedule}"

        # トピックに公開
        self.publisher_.publish(shift_message)

        # 日付を1日進める
        self.current_date += timedelta(days=1)


def main():
    rclpy.init()
    node = ShiftScheduler()
    rclpy.spin(node)
    rclpy.shutdown()

