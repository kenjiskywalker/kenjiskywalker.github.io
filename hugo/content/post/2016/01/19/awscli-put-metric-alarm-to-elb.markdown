---
layout: post
title: "awscliでput-metric-alarmでELBのUnHealthyHostCountUpをモニタリングして増えたりしたらアラートとばすくん"
published: true
date: 2016-01-19 11:24
comments: true
tags: aws 
categories: aws
---

## 自分用メモ

```rb
#!/usr/bin/env ruby

loadbalancers = `aws elb describe-load-balancers | jq '.[][]["LoadBalancerName"]' -r `
alert_sns = "SNS"

loadbalancers.each_line do |lb|
  lb.chomp!
  p lb
`aws cloudwatch put-metric-alarm --alarm-name "#{lb} UnHealthyHostCountUp" --alarm-description "#{lb} ELB UnHealthyHostCountUp" \
  --actions-enabled \
  --ok-actions #{alert_sns} \
  --alarm-actions #{alert_sns} \
  --insufficient-data-actions #{alert_sns} \
  --metric-name "UnHealthyHostCount" \
  --namespace AWS/ELB \
  --statistic Maximum\
  --dimensions Name=LoadBalancerName,Value=#{lb} \
  --period 60 \
  --evaluation-periods 5 \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold`
end
```
