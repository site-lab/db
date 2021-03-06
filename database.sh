#!/bin/sh

#rootユーザーで実行 or sudo権限ユーザー

<<COMMENT
作成者：サイトラボ
URL：https://www.site-lab.jp/
URL：https://www.logw.jp/


目的：データベースを選択してインストール
・Mariadb
・MySQL5.7
・MySQL8.0


COMMENT

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

#CentOS7か確認
if [ -e /etc/redhat-release ]; then
    DIST="redhat"
    DIST_VER=`cat /etc/redhat-release | sed -e "s/.*\s\([0-9]\)\..*/\1/"`

    if [ $DIST = "redhat" ];then
      if [ $DIST_VER = "7" ];then
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

        PS3="インストールしたいMariaDB・MySQLのバージョンを選んでください > "
        ITEM_LIST="MariaDB10.3 MySQL5.7 MySQL8.0"

        select selection in $ITEM_LIST
        do
          if [ $selection = "MariaDB10.3" ]; then
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
            break
          elif [ $selection = "MySQL5.7" ]; then

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

            #my.cnfの設定を変える
            start_message
            echo "ファイル名をリネーム"
            echo "/etc/my.cnf.default"
            mv /etc/my.cnf /etc/my.cnf.default

            echo "新規ファイルを作成してパスワードを無制限使用に変える"
            cat <<EOF >/etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

character-set-server = utf8
default_password_lifetime = 0

#slowクエリの設定
slow_query_log=ON
slow_query_log_file=/var/log/mysql-slow.log
long_query_time=0.01

EOF
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
            break
          else
            #MariaDBを削除
            start_message
            echo "MariaDBを削除します"
            echo ""
            rm -rf /var/lib/mysql/
            end_message

            #公式リポジトリの追加
            start_message
            rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
            yum info mysql-community-server
            end_message

            #MySQLのインストール
            start_message
            echo "MySQLのインストール"
            echo ""
            yum -y install mysql-community-server --enablerepo=mysql80-community
            yum list installed | grep mysql
            end_message

            #バージョン確認
            start_message
            echo "MySQLのバージョン確認"
            echo ""
            mysql --version
            end_message

            #my.cnfの設定を変える
            start_message
            echo "ファイル名をリネーム"
            echo "/etc/my.cnf.default"
            mv /etc/my.cnf /etc/my.cnf.default

            echo "新規ファイルを作成してパスワードを無制限使用に変える"
            cat <<EOF >/etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove the leading "# " to disable binary logging
# Binary logging captures changes between backups and is enabled by
# default. It's default setting is log_bin=binlog
# disable_log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
#
# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

character-set-server = utf8
default_password_lifetime = 0

#slowクエリの設定
slow_query_log=ON
slow_query_log_file=/var/log/mysql-slow.log
long_query_time=0.01
EOF
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
            break
          fi
        done

        cat <<EOF
        ステータスがアクティブの場合は起動成功です

        ---------------------------------------------
        rootのパスワードは
        cat /var/log/mysqld.log
        [Note] A temporary password is generated for root@localhost:"ここにパスワードが記述されている"
        ---------------------------------------------

        となります。パスワードの変更は絶対行ってください
        MySQLのポリシーではパスワードは
        "8文字以上＋大文字小文字＋数値＋記号"
        でないといけないみたいです

        ---------------------------------------------
        MySQL 5.7 からユーザーのパスワードの有効期限がデフォルトで360日になりました。 360日するとパスワードの変更を促されてログインできなくなります。
        ・slow queryはデフォルトでONとなっています
        ・秒数は0.01秒となります
        ---------------------------------------------
EOF

      else
        echo "CentOS7ではないため、このスクリプトは使えません。このスクリプトのインストール対象はCentOS7です。"
      fi
    fi

else
  echo "このスクリプトのインストール対象はCentOS7です。CentOS7以外は動きません。"
  cat <<EOF
  検証LinuxディストリビューションはDebian・Ubuntu・Fedora・Arch Linux（アーチ・リナックス）となります。
EOF
fi
