# mypkg

・このリポジトリはロボットシステム学の授業で使用したROS2のパッケージです

# 仮想通貨の価格表示コマンド

![test](https://github.com/seichandesu0716/robosys2024/actions/workflows/test.yml/badge.svg)
![license](https://img.shields.io/badge/license-BSD--3--Clause-green?style=flat)

**概要**

crypto_price_publisherは1秒ごとに仮想通貨の価格をランダムで表示する機能を持ちます

仮想通貨の価格を表示し、トピックcrypto_pricesに定期的にパブリッシュするノードです

# コマンドと実行例

**端末1**
~~~
$ ros2 run mypkg crypto_price_publisher
~~~
**端末2**
~~~
$ $ ros2 topic echo /crypto_prices
data: '時刻: 2025-01-22 06:04:00

  仮想通貨価格:

  BTC: $24882.96

  ETH: $1526.7

  XRP: $0.5

  LTC: $99.48

  '
---
data: '時刻: 2025-01-22 06:04:01

  仮想通貨価格:

  BTC: $25031.85

  ETH: $1527.72

  XRP: $0.5

  LTC: $98.81

  '
---
data: '時刻: 2025-01-22 06:04:02

  仮想通貨価格:

  BTC: $24886.57

  ETH: $1515.38

  XRP: $0.5

  LTC: $98.7

  '
---
data: '時刻: 2025-01-22 06:04:03

  仮想通貨価格:

  BTC: $25028.67

  ETH: $1520.74

  XRP: $0.5

  LTC: $99.14

  '
---
~~~
 
# 参考資料

バッジの作成・・・https://shields.io/badges


# テスト環境、 必要なソフトウェア
・Ubuntu20.04.6 LTS on Windows(ROS2_Foxy)

・Ubuntu22.04 (ROS2_Humble)

・Python

# ライセンスと著作物
・このソフトウェアパッケージは、3条項BSDライセンスの下、再頒布および使用が許可されます

・このパッケージコードの一部は、（CC-BY-SA4.0by Ryuichi Ueda）のものを、本人の許可を得て自身の著作としたものです
　https://github.com/ryuichiueda/my_slides/tree/master/robosys_2024

・© 2024 Sei Takahashi
