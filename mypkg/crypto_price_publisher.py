#!/usr/bin/python3
# SPDX-FileCopyrightText: 2024 Sei Takahashi <seitaka_0716_poke@yahoo.com>
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import random
from datetime import datetime


class CryptoPricePublisher(Node):
    def __init__(self):
        super().__init__("crypto_price_publisher")
        self.publisher_ = self.create_publisher(String, "crypto_prices", 10)

        self.timer = self.create_timer(1.0, self.publish_price)

        self.cryptos = {
            "BTC": 25000.0,
            "ETH": 1500.0,
            "XRP": 0.50,
            "LTC": 100.0
        }

    def publish_price(self):
        """仮想通貨価格をランダムに変化させて発行"""
        date_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        updated_prices = {}

        for crypto, price in self.cryptos.items():
            price_change = price * random.uniform(-0.01, 0.01)
            updated_prices[crypto] = round(price + price_change, 2)

        self.cryptos = updated_prices

        message_data = f"時刻: {date_time}\n仮想通貨価格:\n"
        for crypto, price in self.cryptos.items():
            message_data += f"{crypto}: ${price}\n"  

        price_message = String()
        price_message.data = message_data
        self.publisher_.publish(price_message)


def main():
    rclpy.init()
    node = CryptoPricePublisher()
    rclpy.spin(node)
    rclpy.shutdown()
