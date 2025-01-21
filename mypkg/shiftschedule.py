#!/usr/bin/python3
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import requests
from datetime import datetime

class CryptoPricePublisher(Node):
    def __init__(self):
        super().__init__("crypto_price_publisher")
        self.publisher_ = self.create_publisher(String, "crypto_prices", 10)

        # 毎秒価格を発行
        self.timer = self.create_timer(1.0, self.publish_price)

        # CoinGecko APIのURL
        self.api_url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"

    def fetch_btc_price(self):
        """CoinGecko APIを使ってビットコインの価格を取得"""
        try:
            response = requests.get(self.api_url)
            data = response.json()
            return data['bitcoin']['usd']
        except Exception as e:
            self.get_logger().error(f"API取得エラー: {str(e)}")
            return None

    def publish_price(self):
        """ビットコインのリアルタイム価格を発行"""
        price = self.fetch_btc_price()
        if price is not None:
            date_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            # メッセージを生成
            message_data = f"時刻: {date_time}\nビットコイン価格:\n  - BTC: ${price}"

            # トピックに発行
            price_message = String()
            price_message.data = message_data
            self.publisher_.publish(price_message)

            # 標準出力に確認用メッセージを表示
            print(f"Published:\n{price_message.data}")

def main():
    rclpy.init()
    node = ShiftPublisher()
    rclpy.spin(node)
    rclpy.shutdown()
