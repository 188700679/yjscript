yjscript是一款centos7的上的一键辅助工具。

PS:本人优化了很多操作以及简化了docker命令,经测试,这个脚本docker和docker-compose的安装比起官方给的文档快10倍,

同时环境搭建采用了源码编译安装,比起原先的编译安装,时间已经从2个小时缩短到5分钟,搭建php环境就是这么快,更多功能敬请期待.

欢迎加qq群:597755927

#1.纯净系统快速部署php,源码编译,5分钟搞定
```
./yjscript lnmp -yjlnmp 
```


# 2.快速使用
1. git clone https://github.com/188700679/yjscript
2. chmod 777 ./yjscript
3. ./yjscript 开始享用

#有问题
欢迎加qq群:597755927


# 3.常见问题
1.如果使用了./yjscript docker -lnmp,尽量不要再使用./yjscript lnmp -yjscript,避免冲突


#4.命令查询

##端口类
./yjscirpt port --help

./yjscript port -add  80        //开放某个端口

./yjscript port -delete 80      //删除某个端口

./yjscript port -all            //查看所有开放端口

./yjscript port -query 80         //查看固定某个端口是否开放


##docker相关
./yjscript docker --help

./yjscript docker -check           //检查docker版本

./yjscript docker -compose         //安装docker-compose

./yjscript docker -compose -v      //检查docker-compose版本

./yjscript docker -lnmp            //安装lnmp环境,需要先安装docker

./yjscript docker -install         //安装docker


##php环境相关
./yjscirpt lnmp --help

./yjscript lnmp -yjlnmp            //适用纯净环境一键安装lnmp,否则有可能出错

./yjscript lnmp -open              //开启lnmp环境,请确保yjlnmp已经安装

./yjscript lnmp -close             //关闭lnmp环境,请确保yjlnmp已经安装

./yjscript lnmp -change php56      //切换php5.6,第一次切换需要5min

./yjscript lnmp -change php7           //切换php7,非常快


## License
MIT


