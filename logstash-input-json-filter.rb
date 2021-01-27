#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

=begin
功能：Logstash7.2 filter使用ruby
filter：必须需要实现的方法，event对象将在这个方法里面处理。
register：可选的实现方法，主要接受logstash的参数传入。
參考官网：https://www.elastic.co/guide/en/logstash/current/plugins-filters-ruby.html
=end

# 可选的实现方法会，接受logstash的传入的参数。params为hash对象（类似于java中的hashmap，python的字典）
# 建议该方法放到第一个
def register(params)
  # @drop_percentage = params["percentage"]
  @lowQualityRate=0.0025; # 0.25%
  @firstTimeGate=10;  # 10毫秒
end

# 计算首包时间（自定义实现方法）
def calFirstTime(event)
  firsttime_avg=event.get("firsttime_avg");
  if firsttime_avg>10 then
    firsttime_avg=rand(1..2);
    event.set("firsttime_avg",firsttime_avg);
  end
  event.set("calFirstTime","计算首包时间方法");
end

# 计算分片质差 ，质差小于0.25%（自定义实现方法）
def calTsLowQuality(event)
  tsbadcount=event.get("tsbadcount");
  tscount=event.get("tscount");
  tsbad_user_count=event.get("tsbad_user_count");
  ts_user_count=event.get("ts_user_count");

  tsBadCountGate=(tscount*@lowQualityRate).to_i; #.to_i 浮点数转整型。i：integer,f:float,s:string
  if tsBadCountGate<=tsbadcount then
    tsbadcount=rand(0..tsBadCountGate);
    event.set("tsbadcount",tsbadcount);
  end

  tsUserBadCountGate=(ts_user_count*@lowQualityRate).to_i;
  if tsBadCountGate<=tsbadcount then
    tsbad_user_count=rand(0..tsUserBadCountGate);
    event.set("tsbad_user_count",tsbad_user_count);
  end

  event.set("calTsLowQuality","计算质差方法");
end

# fiter方法，必须要实现的方法，而且需要接受参数event对象。ruby是解释语言，如果有自定义法方法一定要放到fiter方法前面。
# 改方法放到最后。
def filter(event)
  # 计算首包时间
  calFirstTime event;
  calTsLowQuality event;
  return [event];
end
