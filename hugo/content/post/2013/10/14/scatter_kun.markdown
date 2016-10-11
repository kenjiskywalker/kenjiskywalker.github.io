---
layout: post
title: "IRCでお願いしたら分散図つくってくれるscatter_kunつくった"
published: true
date: 2013-10-14 15:51
comments: true
tags: scatter_kun perl
categories: scatter_kun
---

## [https://github.com/kenjiskywalker/Scatter_Kun](https://github.com/kenjiskywalker/Scatter_Kun)  
  
Songmuさんにモジュール化しろ。っていわれていたけど  
サクっとできなさそうだったので取り敢えず上げておいて  
誰かがモジュール化してくれたりするのを祈ることにしました。  
  
つくった理由は、負荷テストで同じテストケースを利用して  
並列数を上げた時にどのようにスコアが変化するかを  
ぱっと見でわかるようにしたかったのと、簡単にHTMLで残るように  
したかったのが理由です。  
  
良かったら書きなおしたりしてご利用ください。
  
テンプレートはGoogle Chartsの[Scatter Chart](https://developers.google.com/chart/interactive/docs/gallery/scatterchart)を利用しています。  
Google Charts、とても便利ですね。

