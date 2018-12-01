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

# ディレクトリ作成
echo "mkdir /var/log/mysql"
start_message
mkdir /var/log/mysql
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

#ファイル作成
start_message
rm -rf /etc/etc/my.cnf.d/server.cnf
cat >/etc/etc/my.cnf.d/server.cnf <<'EOF'
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see
#
# See the examples of server my.cnf files in /usr/share/mysql/
#

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]

#
# * Galera-related settings
#

#エラーログ
log_error="/var/log/mysql/mysqld.log"
log_warnings=1

#  Query log
general_log = ON
general_log_file="/var/log/mysql/sql.log"

#  Slow Query log
slow_query_log=1
slow_query_log_file="/var/log/mysql/slow.log"
log_queries_not_using_indexes
log_slow_admin_statements
long_query_time=5
character-set-server = utf8


[galera]
# Mandatory settings
#wsrep_on=ON
#wsrep_provider=
#wsrep_cluster_address=
#binlog_format=row
#default_storage_engine=InnoDB
#innodb_autoinc_lock_mode=2
#
# Allow server to accept connections on all interfaces.
#
#bind-address=0.0.0.0
#
# Optional setting
#wsrep_slave_threads=1
#innodb_flush_log_at_trx_commit=0

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.3 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.3]
EOF

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
