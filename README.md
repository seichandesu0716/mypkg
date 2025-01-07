# mypkg

・このリポジトリはロボットシステム学の授業で使用したROS2のパッケージです

# シフト作成コマンド

![test](https://github.com/seichandesu0716/robosys2024/actions/workflows/test.yml/badge.svg)
![license](https://img.shields.io/badge/license-BSD--3--Clause-green?style=flat)

**概要**

shift_publisherは1秒ごとにシフトのメンバーからランダムで2人選び、日付順に表示する機能を持ちます

バイトのシフトを作成し、トピックshift_scheduleに定期的にパブリッシュするノードです

# コマンドと実行例

**端末1**
~~~
$ ros2 run mypkg shift_publisher
~~~
**端末2**
~~~
$ ros2 topic echo /shift_schedule
~~~
**実行例**
~~~
data: '日付: 2025-01-04

  シフトスケジュール:

  ホール: 高橋, 佐々木

  キッチン: 鈴木, 中村'
---
data: '日付: 2025-01-05

  シフトスケジュール:

  ホール: 坂上, 佐々木

  キッチン: 森木, 鈴木'
---
data: '日付: 2025-01-06

  シフトスケジュール:

  ホール: 佐々木, 辻

  キッチン: 森木, 鈴木'
---
~~~
 
# 参考資料

バッジの作成・・・https://shields.io/badges

# テスト環境、 必要なソフトウェア
・Ubuntu20.04.6 LTS on Windows

・ROS2_Foxy

・Python

# ライセンスと著作物
・このソフトウェアパッケージは、3条項BSDライセンスの下、再頒布および使用が許可されます

・このパッケージコードの一部は、（CC-BY-SA4.0by Ryuichi Ueda）のものを、本人の許可を得て自身の著作としたものです
　https://github.com/ryuichiueda/my_slides/tree/master/robosys_2024

・© 2024 Sei Takahashi
