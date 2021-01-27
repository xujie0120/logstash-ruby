# logstash总使用ruby 脚本的方法。
## 1、包含两个脚本
### logstash.cfg ： 该脚本为logstash的配置脚本样例。
### logstash-input-json-filter.rb ：该脚本为ruby脚本，logstash.cfg脚本中filter中引入的ruby脚本。
## 2、脚本详细说明
### 2.1、logstash.cfg
该脚本包含三个部分，input，filter，output
input：kafka输入
filter：引入ruby脚本，语法为：
       ruby {
              path => "./logstash-input-json-filter.rb"
       }
output：stdout { codec => rubydebug}为debug输出到控制台。
        elasticsearch：为ES的输出。
 
### 2.2、 logstash-input-json-filter.rb
要实现的方法有两个：
#### 2.2.1 fiter
必须实现的方法，接受event对象，event里面的值使用event.get("key")获取，设置值使用event.set("key","value")
#### 2.2.2 register
可选的实现方法会，接受logstash的传入的参数。params为hash对象（类似于java中的hashmap，python的字典）
举例：获取方法：@drop_percentage = params["percentage"]，@drop_percentage是变量名字。
