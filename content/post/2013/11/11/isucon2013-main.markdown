---
layout: post
title: "#isucon 2013 参加してきました"
published: true
date: "2013-11-11T10:02:00+09:00"
comments: true


---

運営のみなさまおつかれさまでした。今回もとても楽しかったです。  

今回は誰でもわかるようなボトルネック、例えばクソクエリとか  
クソコードとかはなくて、現状のゼロベースからどうやってスコアを上げるか。  
みたいな感じだった。なので最初の方向性付けがすべてだったのかなと。  
出題者の@fujiwaraさんと@acidlemonさんすごい。  
  
また、アプリケーションを確認した時点で  
2人でできることって限界があるな。って感じていました。  
  
細かいことは[http://soh335.hatenablog.com/entry/2013/11/10/214457](http://soh335.hatenablog.com/entry/2013/11/10/214457)ここ読んでください。

# 課題

- 予選の時にはできていたスコアを着実に上げていくことができなかった。(人数の問題もあった)
- エラーが発生していて、その解決を@soh335待ちにしてたところがあった。問題解決とは別に平行して作業を行えばよかった。  
- 待ちにしていた実装が不可能だった場合、即切り替えてやればよかった。  
- 切り替えるにしろ、実装の確認、問題意識のすり合わせをしなかったのでそこは予選から改善されていなかった。(問題の複雑さと人数の少なさを意識し過ぎた)
- Redis載せ、取り敢えず画像を縮小するか  手分けして複数台でRedisに載せられるように改修できればよかった。自分の実装力が足りなかった。
  
残り2時間前まで何やっていたのか覚えていない。  
  
- サーバ全員が同じ画像ディレクトリを見ていれば良い
- 内部ネットワークは1Gbpsって言っていたのでネットワークのボトルネックはない  
  
と信じてNFSの導入をした。30分ぐらいで全台NFSで見れるようになったけど  
アプリでどうにかイケそうだ。っていう話だったのでNFSだと全台再起動してからのテストでコケた場合、  
設定箇所の特定が間に合わないかもしれないと判断して、NFSは捨ててアプリのフォローに回った。  
結果、改修は間に合わなかった。  
  
# まとめ

Failで終わるのはプロとして恥ずかしい。  
  
転職前にスピードワゴンはクールに去るぜ。の如くキメたかったけど  
先は長く厳しい。日々戦いは続く。ベルマーレがJ2に落ちたとしても  
オレたちは常に目の前の問題に最善をつくしていかなければならないんだ。  

先は長く、厳しい。
