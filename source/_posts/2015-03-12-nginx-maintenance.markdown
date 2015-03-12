---
layout: post
title: "nginxでメンテナンスページ用意する技"
published: true
date: 2015-03-12 12:22
comments: true
tags: nginx
categories: 
---

## LT;DR

かっぱ先輩！

## かっぱ先輩のブログを読んで

- [深夜メンテナンスに役立ちそうな nginx 小ネタ - ようへいの日々精進 XP ](http://inokara.hateblo.jp/entry/2014/02/22/134221)

同じようなことを最近やっていたのでメモ。

- nginx.conf

```
upstream example_pool {
    server 127.0.0.1:3000;
}

geo $allow_ip_flag {
    default 0;
    192.0.2.0/24 1;    #TEST-NET-1
    198.51.100.0/24 1; #TEST-NET-2
}

server {
    listen       80;
    server_name  example.com;

    access_log  /var/log/nginx/example_com_access.log  ltsv;
    error_log  /var/log/nginx/example_com_error.log warn;

    root /var/nginx/html/example;

    location /robots.txt {
            alias /var/nginx/html/robots.txt;
    }

    location / {

        if ( $request_uri ~ /health check ) {
            set $maintenance false;
            access_log off;
        }

        ### メンテナンスの設定 ここから ###############################
        if ( -e /var/nginx/html/maintenance/maintenance.html ) {
            set $maintenance true;
        }

        if ( $allow_ip_flag ) {
            set $maintenance false;
        }

        if ( $maintenance = true ) {
            rewrite ^ /maintenance.html redirect;
        }

        location /maintenance.html {
            alias /var/nginx/html/maintenance/maintenance.html;
            expires 0;
        }
        ### メンテナンスの設定 ここまで ###############################

        proxy_pass http://example_pool;

        proxy_set_header Host              $http_host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;

        client_max_body_size 710M;
        proxy_connect_timeout      3000;
        proxy_send_timeout         3000;
        proxy_read_timeout         3000;
        break;
    }
}
```

nginxは複数の条件の場合bit立てて判断するの知らなかった。

- [IfIsEvil](http://wiki.nginx.org/IfIsEvil)
