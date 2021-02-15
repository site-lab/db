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
        wget wget https://www.logw.jp/download/shell/common/system/repository.sh
        source ./repository.sh

        #ユーザー作成
        wget wget https://www.logw.jp/download/shell/common/user/dbuseradd.sh
        source ./dbuseradd.sh


        # yum updateを実行
        wget wget https://www.logw.jp/download/shell/common/system/update.sh
        source ./update.sh

        #MariaDBを削除
        start_message
        echo "MariaDBを削除します"
        echo ""
        yum -y remove mariadb-libs
        rm -rf /var/lib/mysql/
        end_message

        #公式リポジトリの追加
        wget wget https://www.logw.jp/download/shell/common/database/rdbm57.sh
        source ./rdbm57.sh


        echo ""
        echo ""
        cat <<EOF
        ステータスがアクティブの場合は起動成功です
        ---------------------------------------------
        MySQLのポリシーではパスワードは
        "8文字以上＋大文字小文字＋数値＋記号"
        でないといけないみたいです

        MySQLへのログイン方法
        centosユーザーでログインするには下記コマンドを実行してください
        mysql --defaults-extra-file=/etc/my.cnf.d/centos.cnf
        ---------------------------------------------
        ・slow queryはデフォルトでONとなっています
        ・秒数は0.01秒となります
        ・/root/pass.txtにパスワードが保存されています
        ---------------------------------------------
EOF
      echo "データベースのrootユーザーのパスワードは"${RPASSWORD}"です。"
      echo "データベースのcentosユーザーのパスワードは"${UPASSWORD}"です。"
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
