# データベース
MySQL、MariaDB関連のシェルスクリプト置き場、CentOS7専用となります。**centos7 minimal インストール** した状態で何もはいっていない状態で必要なファイルを実行してください
Apache+PHPなどの環境構築シェルスクリプトです
※自己責任で実行してください

## テスト環境
* conohaのVPS
* メモリ：512MB
* CPU：1コア
* SSD：20GB

### 実行方法
SFTPなどでアップロードをして、rootユーザーもしくはsudo権限で実行
wgetを使用する場合は[環境構築スクリプトを公開してます](https://www.logw.jp/cloudserver/8886.html)を閲覧してください。
wgetがない場合は **yum -y install wget** でインストールしてください

**sh ファイル名.sh** ←同じ階層にある場合

**sh /home/ユーザー名/ファイル名.sh** ユーザー階層にある場合（rootユーザー実行時）

## [mariadb102.sh](https://github.com/site-lab/db/blob/master/mariadb102.sh)
MariaDB10.2をインストールします。
自動起動もOnとなります

## [mariadb103.sh](https://github.com/site-lab/db/blob/master/mariadb103.sh)
最新安定版のMariaDB10.3をインストールします。
自動起動もOnとなります

## [mysql57.sh](https://github.com/site-lab/db/blob/master/mysql57.sh)
MySQL5.7のインストールになります。MariaDBは削除します。

## [mysql8.sh](https://github.com/site-lab/db/blob/master/mysql8.sh)
MySQL8のインストールになります。MariaDBは削除します。
