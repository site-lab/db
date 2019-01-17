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

        start_message
        echo "yum updateを実行します"
        echo ""
        yum -y update
        end_message

        #MariaDBを削除
        start_message
        echo "MariaDBを削除します"
        echo ""
        yum -y remove mariadb-libs
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

#mysqlのパスワードなしでログインできるように設定
skip-grant-tables
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

        #ログイン
        mysql -u root　<<EOF
show databases;
EOF

        #cnfファイルの表示
        cat /etc/my.cnf

        echo ""
        echo ""
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
        MySQL初期設定は以下の通りです
        [root@ ~]# mysql_secure_installation

        Securing the MySQL server deployment.

        Enter password for user root:

        The existing password for the user account root has expired. Please set a new password.

        New password:"初期パスワードを入れる"

        Re-enter new password:"初期パスワードを入れる"

        Estimated strength of the password: 100
        Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : y
        By default, a MySQL installation has an anonymous user,
        allowing anyone to log into MySQL without having to have
        a user account created for them. This is intended only for
        testing, and to make the installation go a bit smoother.
        You should remove them before moving into a production
        environment.

        Remove anonymous users? (Press y|Y for Yes, any other key for No) : y
        Success.


        Normally, root should only be allowed to connect from
        'localhost'. This ensures that someone cannot guess at
        the root password from the network.

        Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y
        Success.

        By default, MySQL comes with a database named 'test' that
        anyone can access. This is also intended only for testing,
        and should be removed before moving into a production
        environment.


        Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
         - Dropping test database...
        Success.

         - Removing privileges on test database...
        Success.

        Reloading the privilege tables will ensure that all changes
        made so far will take effect immediately.

        Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
        Success.

        All done!

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
