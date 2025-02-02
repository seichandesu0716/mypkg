from setuptools import setup

package_name = 'mypkg'

setup(
    name=package_name,
    version='0.0.0',
    packages=[package_name],
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='sei0716',
    maintainer_email='s23C1082TL@s.chibakoudai.jp',
    description='ロボットシステム学のサンプル:Package description',
    license='BSD-3-Clause: License declaration',
    tests_require=['pytest'],
    entry_points={
        'console_scripts': [
            #'talker = mypkg.talker:main',
            #'listener = mypkg.listener:main',
        #'forex_publisher = mypkg.forex_publisher:main'
             #'btc_publisher = mypkg.btc_publisher:main',  
            'crypto_price_publisher = mypkg.crypto_price_publisher:main'
             ],
    },
)
