#!/bin/sh

#rootユーザーで実行 or sudo権限ユーザー

<<COMMENT
作成者：サイトラボ
URL：https://www.site-lab.jp/
URL：https://www.logw.jp/

注意点：conohaのポートは全て許可前提となります。MariaDBがインストールされていない状態となります。

目的：システム更新+MySQL5.7のインストール
・MySQL5.7


COMMENT

echo "インストールスクリプトを開始します"
echo "このスクリプトのインストール対象はCentOS7です。"
echo ""

start_message(){
echo ""
echo "======================開始======================"
echo ""
}

end_message(){
echo ""
echo "======================完了======================"
echo ""
}

#EPELリポジトリのインストール
start_message
yum remove -y epel-release
yum -y install epel-release
end_message

#gitリポジトリのインストール
start_message
yum -y install git
end_message



# yum updateを実行
echo "yum updateを実行します"
echo ""

start_message
yum -y update
end_message

#MariaDBを削除
echo "MariaDBを削除します"
echo ""
start_message
yum -y remove mariadb-libs
rm -rf /var/lib/mysql/
end_message

#公式リポジトリの追加
start_message
yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum info mysql-community-server
end_message

#MySQLのインストール
echo "MySQLのインストール"
echo ""
start_message
yum -y install mysql-community-server
yum list installed | grep mysql
end_message

#バージョン確認
echo "MySQLのバージョン確認"
echo ""
start_message
mysql --version
end_message

#自動起動
echo "MySQLの自動起動を設定"
echo ""
start_message
systemctl enable mysqld.service
end_message

#自動起動
echo "MySQLの起動"
echo ""
start_message
systemctl start mysqld.service
systemctl status mysqld.service
end_message


cat <<EOF
ステータスがアクティブの場合は起動成功です

rootのパスワードは
cat /var/log/mysqld.log
[Note] A temporary password is generated for root@localhost:"ここにパスワードが記述されている"

となります。
EOF
