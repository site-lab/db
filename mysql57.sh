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

start_message
echo "yum updateを実行します"
echo ""
end_message

#MariaDBを削除
start_message
echo "MariaDBを削除します"
echo ""
rm -rf /var/lib/mysql/
end_message

#公式リポジトリの追加
start_message
yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
yum info mysql-community-server
end_message

#MySQLのインストール
start_message
echo "MySQLのインストール"
echo ""
yum -y install mysql-community-server
yum list installed | grep mysql
end_message

#バージョン確認
start_message
echo "MySQLのバージョン確認"
echo ""
mysql --version
end_message

#自動起動
start_message
echo "MySQLの自動起動を設定"
echo ""
systemctl enable mysqld.service
end_message

#自動起動
start_message
echo "MySQLの起動"
echo ""
systemctl start mysqld.service
systemctl status mysqld.service
end_message


cat <<EOF
ステータスがアクティブの場合は起動成功です

rootのパスワードは
cat /var/log/mysqld.log
[Note] A temporary password is generated for root@localhost:"ここにパスワードが記述されている"

となります。パスワードの変更は絶対行ってください
MySQLのポリシーではパスワードは
"8文字以上＋大文字小文字＋数値＋記号"
でないといけないみたいです

MySQL 5.7 からユーザーのパスワードの有効期限がデフォルトで360日になりました。 360日するとパスワードの変更を促されてログインできなくなります。
EOF
