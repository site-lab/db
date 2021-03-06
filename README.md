# データベース
MySQL、MariaDB関連のシェルスクリプト置き場、CentOS7専用となります。**centos7 minimal インストール** した状態で何もはいっていない状態で必要なファイルを実行してください
Apache+PHPなどの環境構築シェルスクリプトです
※自己責任で実行してください

## テスト環境
* conohaのVPS
* メモリ：512MB
* CPU：1コア
* SSD：20GB

* さくらのVPS
* メモリ：512MB
* CPU：1コア
* SSD：20GB

### さくらのクラウド
* メモリ：1GB
* CPU：1コア
* SSD：20GB

### IDCFクラウド
* メモリ：1GB
* CPU：1コア
* SSD：15GB

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

## [mariadb104.sh](https://github.com/site-lab/db/blob/master/mariadb104.sh)
最新安定版のMariaDB10.4をインストールします。
自動起動もOnとなります

## [mariadb105.sh](https://github.com/site-lab/db/blob/master/mariadb105.sh)
最新安定版のMariaDB10.4をインストールします。
自動起動もOnとなります


## [mysql57.sh](https://github.com/site-lab/db/blob/master/mysql57.sh)
MySQL5.7のインストールになります。MariaDBは削除します。
* 文字コード：UTF-8
* デフォルトの有効期限無効
* slowクエリの設定：有効（0.01秒）

※MySQLのパスワードはデフォルトから自動で変更します。必ずメモを取ってください。MySQLのパスワードポリシーにそっていますが、万が一エラーとなる場合はパスワードを再度設定してください
 **mysql --defaults-extra-file=/etc/my.cnf.d/centos.cnf** コマンド実行でcentosユーザーで自動ログインできます


## [mysql8.sh](https://github.com/site-lab/db/blob/master/mysql8.sh)
MySQL8のインストールになります。MariaDBは削除します。
* 文字コード：UTF-8
* デフォルトの有効期限無効
* slowクエリの設定：有効（0.01秒）
