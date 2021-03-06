---
layout: post
title: "/var/lock/subsys/について"
published: true
date: "2014-02-24T17:49:00+09:00"
comments: true


---

init.dスクリプトの中に`/var/lock/subsys/`という文字列を見たことはあったが  
何をしているのかまで追ったことはなかった。

- [（今さら）Linuxでサービスを登録する - あしのあしあと](http://d.hatena.ne.jp/higher_tomorrow/20110421/1303337554)  
  
こちらのページに大切なことは全て書いてあった。ありがたい。  
「インスタンス起動時にRoute53でゴニョゴニョして、  
インスタンス終了時にゴニョゴニョしたい」  
という機能を実装するのに、init scriptを作成するのはよくあることだと思う。  
その際、stopが上手く動かなく、その原因が`/var/lock/subsys/`であったので  
備忘録として記録しておく。


- /etc/init/rc.conf

```
# rc - System V runlevel compatibility
#
# This task runs the old sysv-rc runlevel scripts.  It
# is usually started by the telinit compatibility wrapper.
#
# Do not edit this file directly. If you want to change the behaviour,
# please create a file rc.override and put your changes there.

start on runlevel [0123456]

stop on runlevel [!$RUNLEVEL]

task

export RUNLEVEL
console output
exec /etc/rc.d/rc $RUNLEVEL
```


- /etc/rc.d/rc

```
#! /bin/bash
#
# rc            This file is responsible for starting/stopping
#               services when the runlevel changes.
#
# Original Author:
#               Miquel van Smoorenburg, <miquels@drinkel.nl.mugnet.org>
#

... 

# First, run the KILL scripts.
for i in /etc/rc$runlevel.d/K* ; do

        # Check if the subsystem is already up.
        subsys=${i#/etc/rc$runlevel.d/K??}
        [ -f /var/lock/subsys/$subsys -o -f /var/lock/subsys/$subsys.init ] || continue
        check_runlevel "$i" || continue

        # Bring the subsystem down.
        [ -n "$UPSTART" ] && initctl emit --quiet stopping JOB=$subsys
        $i stop
        [ -n "$UPSTART" ] && initctl emit --quiet stopped JOB=$subsys
done

# Now run the START scripts.
for i in /etc/rc$runlevel.d/S* ; do

        # Check if the subsystem is already up.
        subsys=${i#/etc/rc$runlevel.d/S??}
        [ -f /var/lock/subsys/$subsys ] && continue
        [ -f /var/lock/subsys/$subsys.init ] && continue
        check_runlevel "$i" || continue

        # If we're in confirmation mode, get user confirmation
        if [ "$do_confirm" = "yes" ]; then
                confirm $subsys
                rc=$?
                if [ "$rc" = "1" ]; then
                        continue
                elif [ "$rc" = "2" ]; then
                        do_confirm="no"
                fi
        fi

        update_boot_stage "$subsys"
        # Bring the subsystem up.
        [ -n "$UPSTART" ] && initctl emit --quiet starting JOB=$subsys
        if [ "$subsys" = "halt" -o "$subsys" = "reboot" ]; then
                export LC_ALL=C
                exec $i start
        fi
        $i start
        [ -n "$UPSTART" ] && initctl emit --quiet started JOB=$subsys
done
[ "$do_confirm" = "yes" ] && rm -f /var/run/confirm
exit 0
```

ということで

```
        [ -f /var/lock/subsys/$subsys -o -f /var/lock/subsys/$subsys.init ] || continue
```

この条件を満たさなければ`stop`が発動しないことがわかった。  
nginxのinit scriptでも


- [RedHatNginxInitScript](http://wiki.nginx.org/RedHatNginxInitScript)


```
lockfile=/var/lock/subsys/nginx

...

start()
{
    [ $retval -eq 0 ] && touch $lockfile
}

...

stop()
{
    [ $retval -eq 0 ] && rm -f $lockfile
}
```

としてstart、stop時にlockfileを操作している。  
  
自分の独自スクリプトを作成する場合は


- /etc/init.d/hoge-script

```
#!/bin/sh
#
# hoge-script
#
# chkconfig: 2345 20 01
# 


lock_file="/var/lock/subsys/hoge-script"

start()
{
    # lock_fileを生成しないとshutdownの時に実行されない
    touch ${lock_file}

    # 処理 

}

stop()
{
    # lock_fileの削除
    rm -r ${lock_file}

    # 処理
}

case "$1" in
    start)
        start
    ;;
    stop)
        stop
    ;;
    *)
        echo "Usage: $0 {start|stop}"
    ;;
esac

exit 0
```

のように作成するとstart/stopの処理が正常に動く。  
こういう事象に出くわすと自分の知識がいかに御座なりかわかる。
