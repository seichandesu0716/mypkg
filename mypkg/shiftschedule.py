#!/usr/bin/python3
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import random
from datetime import datetime, timedelta

class ShiftPublisher(Node):
    def __init__(self):
        super().__init__("shift_publisher")
        self.publisher_ = self.create_publisher(String, "shift_schedule", 10)

        self.current_date = datetime(2024, 12, 30)

        self.timer = self.create_timer(1.0, self.publish_shift_schedule)

        self.hall_names = ["高橋", "佐々木", "辻", "尾牛山", "坂上"]
        self.kitchen_names = ["落合", "森木", "宮崎", "中村", "鈴木"]

    def publish_shift_schedule(self):
        selected_hall_names = random.sample(self.hall_names, 2)  # ホールは2人選択
        selected_kitchen_names = random.sample(self.kitchen_names, 2)  # キッチンは2人選択

        date_str = self.current_date.strftime("%Y-%m-%d")

        hall_schedule = f"ホール: {', '.join(selected_hall_names)}"

        kitchen_schedule = f"キッチン: {', '.join(selected_kitchen_names)}"

        shift_message = String()
        shift_message.data = f"日付: {date_str}\nシフトスケジュール:\n{hall_schedule}\n{kitchen_schedule}"

        self.publisher_.publish(shift_message)
shiftschedule.py
        self.current_date += timedelta(days=1)

def main():
    rclpy.init()
    node = ShiftPublisher()
    rclpy.spin(node)
    rclpy.shutdown()

