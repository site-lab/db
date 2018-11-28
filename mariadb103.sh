#!/bin/sh

#rootユーザーで実行 or sudo権限ユーザー

<<COMMENT
作成者：サイトラボ
URL：https://www.site-lab.jp/
URL：https://www.logw.jp/

注意点：conohaのポートは全て許可前提となります。MariaDBがインストールされていない状態となります。

目的：システム更新+mariadbのインストール
・Mariadb


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

# yumのキャッシュをクリア
echo "yum clean allを実行します"
start_message
yum clean all
end_message

# MariaDBの設定ファイルを追加
start_message
cat >/etc/yum.repos.d/MariaDB.repo <<'EOF'
# MariaDB 10.3 CentOS repository list
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

yum -y install mariadb-server maradb-client
yum list installed | grep mariadb

end_message

#バージョン表示
start_message
mysql --version
end_message

#MariaDBの起動
start_message
systemctl start mariadb.service
systemctl status mariadb.service
end_message

#自動起動の設定
start_message
systemctl enable mariadb
systemctl list-unit-files --type=service | grep mariadb
end_message



cat <<EOF
mysql --version
mysql  Ver 15.1 Distrib 10.3.11-MariaDB, for Linux (x86_64) using readline 5.1

と表示されたらインストール成功です

ステータスがアクティブの場合は起動も成功です
EOF
