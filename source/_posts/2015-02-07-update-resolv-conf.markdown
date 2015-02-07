---
layout: post
title: "起動時にresolv.confが何者かに上書きされた時に更に上書きをする戦い"
published: true
date: 2015-02-07 17:41
comments: true
tags: resolv redhat
categories: memo
---

> みんなこういうのはどういう対応しているんだろう

## resolv.confが圧倒的暴力によって上書きされる場合

対応として`resolv-update`みたいな雑なサービス定義をして、サーバ起動時に実行させるようにした。  
ポイントはcloud-initとかそれ系のヤツが実行される前に上書いてもその後に上書きされるのでタイミングが大切。  

ここの  

```
# chkconfig: 2345 49 49
```

`49 49`の最初の数字が起動時に実行される順番で、後ろの数字が終了時に実行される順番。

```
$ chkconfig --add resolv-update
```

とすることで自動に実行されるようになる。  

runlevel 3のものを確認したければ`/etc/rc3.d/`とか見ればわかる。  


```
#!/bin/sh
#
# resolv-update
# create by kenjiskywalker
#
# chkconfig: 2345 49 49
# description: resolv-update

lock_file="/var/lock/subsys/resolv-update"
redis_port="6379"

start()
{
    # lock_fileを生成しないとshutdownの時に実行されない
    touch ${lock_file}

    # 圧倒的暴力によってresolv.confが上書きされていたら更に上書きする
    if [[ -z "`grep 'nameserver 127.0.0.1' /etc/resolv.conf`" ]]
    then
        sed -i '1s/^/nameserver 127.0.0.1\n/' /etc/resolv.conf
    fi
}

stop()
{
    # lock_fileの削除
    rm -r ${lock_file}
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

Systemd？はて？
