#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export MC="-j$(nproc)"
export PATH
LANG=en_US.UTF-8

author="So:Lo"
author_qq="269995848@qq.com"
qqun="597755927"
git_addree=""
VERSION=1.0
project_path=$(cd `dirname $0`; pwd)
project_name="${project_path##*/}"

isCentos7="抱歉, 7.x不支持Centos6.x!"
isDockerInstall="docker没有安装,现在是否安装(y/n):"
currentVersion="当前版本:"
paramsError='error1:无效的参数,请使用"./yjscript --help"获取帮助';
portError="error:缺少端口号!"
noCompose="木有安装docker-compose,执行'./yjscript -compose'安装"
yjlnmpInstall="本功能适用于纯净的centos系统安装"
errorInstall="安装失败"
successInstall="安装成功"
uninstallSuccess="卸载成功!!!!!"
successChange56="php5.6切换成功"
successChange7="php7切换成功"
portNo="请填写端口号"
passNo="请填写VNC密码"
vnc_passwd="你的vnc密码是:"
loading="loading...........................!"
zjloading="组件加载成功!"
inApi="请填写你项目的入口地址"
qConfig="配置成功!"
qNumber="缺少qq号"
red_error(){
          printf '\033[1;31;40m%b\033[0m\n' "$1";
         exit 0;
}
blue_info(){
          printf '\033[36m%b\033[0m\n' "$1";
}
green_info(){
          printf '\033[32m%b\033[0m\n' "$1";

}


distName(){
    if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    echo $DISTRO
}

yjscript_help(){
        echo "
command         detail

port            端口类操作
docker          docker相关操作
lnmp		php环境安装
qqrobot         coolq相关操作
"

}

help(){
    cat << EOF
==================================================================
		欢迎使用linux一键辅助工具$project_name $VERSION
		如有任何问题可以联系$author_qq
		qq交流群:$qqun
		本工具完全开源
		输入:./yjscript --help 查看所有帮助
=================================================================
EOF
}
docker_help(){

    echo "
command		detail

-check		检查docker版本
-compose	安装docker-compose
-compose -v	检查compose版本
-lnmp		安装lnmp环境,需要先安装docker
-install        安装docker
"
}

port(){
    echo "
command		detail

-add		添加一个端口
-query		查询一个端口是否存在
-delete		删除一个端口
-all		查看所有开放的端口
"
}


lnmp_help(){

    echo "
command		detail

-yjlnmp		只适用于纯净环境安装php环境
-open		打开lnmp环境
-close		关闭lnmp环境
-change php56   切换php5.6,第一次切换需要耗时5min
-change php7	 切换php7
"
}

qrobot_help(){

    echo "
command         detail

-install        安装coolq
-start          开启coolq
-close          关闭coolq
-uninstall      卸载coolq
-init           初始化coolq
-config         配置初始化
"
}





docker_yum(){
       sudo yum install -y yum-utils \
           device-mapper-persistent-data \
           lvm2

        sudo yum-config-manager \
        --add-repo \
        http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
	sudo yum-config-manager --enable docker-ce-test
	yum makecache fast
	yum -y install docker-ce

	sudo sh ./assets/get-docker.sh --mirror Aliyun
	sudo systemctl enable docker
	sudo systemctl start docker
	sudo groupadd docker
	sudo usermod -aG docker $USER
	sudo mkdir -p /etc/docker
	sudo echo '{"registry-mirrors": ["https://fw4bni9n.mirror.aliyuncs.com","http://hub-mirror.c.163.com" ]}' > /etc/docker/daemon.json
	sudo systemctl daemon-reload
	sudo systemctl restart docker
	docker run hello-world

}

docker_apt(){
	while [ "$go" != 'y' ] && [ "$go" != 'n' ]
        do
        read -p "请确保版本不低于Ubuntu 16.04!(y/n) " go;
        done
        if [ "$go" == 'n' ];then
            exit
        fi
	sudo apt-get update
	sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
	 curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
	sudo apt-get update
	sudo apt-get install docker-ce
	curl -fsSL get.docker.com -o get-docker.sh
	sudo sh get-docker.sh --mirror Aliyun
	sudo systemctl enable docker
	sudo systemctl start docker
	sudo groupadd docker
	sudo usermod -aG docker $USER
	docker run hello-world
	docker -v
}

yj_compose(){

	sudo gpasswd -a ${USER} docker
	cp assets/package/docker-compose /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	green_info "${successInstall}"

}

yj_lnmp(){
	sudo git clone https://gitee.com/meiyu1992/easylnmp www
	cp www/env.sample www/.env
	cp www/docker-compose.sample.yml www/docker-compose.yml
	cd www && docker-compose up -d
	host_name=`hostname`
	echo "访问地址:$host_name:80"
}

c_change56='cp -f
docker-compose.56.yml www/docker-compose.yml  && \cp -f assets/package/privacy/localhost.56.conf www/services/nginx/conf.d/localhost.conf   && cd www && docker-compose build php56 && docker container stop php  && docker-compose down > /dev/null 2>&1 && docker-compose up -d && docker exec -it nginx nginx -s reload'

c_change7='cp -f assets/package/privacy/docker-compose.72.yml www/docker-compose.yml && cp -f assets/package/privacy/localhost.conf www/services/nginx/conf.d/localhost.conf  && cd www && docker-compose build php > /dev/null 2>&1 && docker container stop php56  > /dev/null 2>&1 && docker-compose down > /dev/null 2>&1 && docker-compose up -d > /dev/null 2>&1 && docker exec -it nginx nginx -s reload > /dev/null 2>&1'

qqrobot_install(){
    sudo echo '{"registry-mirrors": ["https://fw4bni9n.mirror.aliyuncs.com","http://hub-mirror.c.163.com" ]}' > /etc/docker/daemon.json

    sudo systemctl daemon-reload
    sudo systemctl restart docker

    if [ $3 == 'cqa' ];then
    	b=":9000 -p 5700:5700 -v ~/coolq/:/home/user/coolq -e VNC_PASSWD=$2 -e COOLQ_URL=http://dlsec.cqp.me/cqa-tuling -e COOLQ_ACCOUNT=123456"

    else
        b=":9000 -p 5700:5700 -v ~/coolq/:/home/user/coolq -e VNC_PASSWD=$2 -e COOLQ_URL=http://dlsec.cqp.me/cqp-tuling -e COOLQ_ACCOUNT=123456"
    fi
    systemctl daemon-reload
    systemctl restart docker
    sed -i '$a\nameserver 0.0.4.4' /etc/resolv.conf
    sed -i '$a\nameserver 8.8.4.4' /etc/resolv.conf

    mkdir -p ~/coolq
    a="docker run --name=coolq -d -p $1"

    c=" coolq/wine-coolq"

    install=$a$b$c
    eval $install
    if [ $? -ne 0 ];then
	red_error ${errorInstall}

    else
	green_info ${successInstall}
        host_name=`hostname`
        echo "$vnc_passwd:$2"
        echo "访问地址:内网ip:$1"
    fi
}
qqrobot_forget_vnc(){
    green_info ${vnc_passwd}${VNC_PASSWD}
    exit 1
}
qqrobot_uninstall(){
    blue_info ${loading}
    docker container stop  coolq > /dev/null  2>&1
    docker container rm  coolq > /dev/null  2>&1
    docker image rm coolq/wine-coolq
    sudo rm -rf /root/coolq
    green_info ${uninstallSuccess}
    exit 1
}
qqrobot_init(){
    chmod -R 777 /root/coolq/app/
        sudo rm -f /root/coolq/app/com.coxxs.tuling123.cpk
        sudo rm -f /root/coolq/app/com.coxxs.start.cpk
        sudo rm -f /root/coolq/app/com.coxxs.music.cpk
        sudo rm -f /root/coolq/app/moe.min.qa.cpk
        sudo cp assets/package/io.github.richardchien.coolqhttpapi.cpk ~/coolq/app/
        green_info ${zjloading}
}

qqrobot_config(){
    a='\    "host": "0.0.0.0",'
    mjson=".json"
    b=$1$mjson
    c='\    "post_url":"http://'
    e='",'
    d=$c$2$e
    rm -f ~/coolq/data/app/io.github.richardchien.coolqhttpapi/config/${b}
    cp assets/package/privacy/xxxx ~/coolq/data/app/io.github.richardchien.coolqhttpapi/config/${b}
    sed -i "2c${a}" ~/coolq/data/app/io.github.richardchien.coolqhttpapi/config/${b}
    sed -i "14c${d}" ~/coolq/data/app/io.github.richardchien.coolqhttpapi/config/${b}
    dos2unix ~/coolq/data/app/io.github.richardchien.coolqhttpapi/config/${b} > /dev/null 2>&1
    green_info ${qConfig}
}

if [ ! -n "$1" ];then
    readonly author author_qq
    help
    exit 1
fi



command=$1
isPy26=$(python -V 2>&1|grep '2.6.')
if [ "${isPy26}" ];then
        red_error "${isCentos7}";
fi

Get_Pack_Manager(){
    if [ -f "/usr/bin/yum" ] && [ -d "/etc/yum.repos.d" ]; then
            PM="yum"
    elif [ -f "/usr/bin/apt-get" ] && [ -f "/usr/bin/dpkg" ]; then
            PM="apt-get"
    fi
}


docker_install(){
    docker -v > /dev/null 2>&1 
    if [ $? -ne 0 ];then
	while [ "$go" != 'y' ] && [ "$go" != 'n' ]
        do
	read -p "${isDockerInstall}" go;
        done	
	if [ "$go" == 'n' ];then
	    exit
	fi
 
	if [ ${PM} == 'yum' ];then
	    docker_yum	
	fi

	if [ ${PM} == 'apt-get' ];then
	    docker_apt
	fi
    else
	echo "${currentVersion}" && docker -v	
    fi
    return 1	
}

git(){
    if [ ${PM} == 'yum' ];then
	sudo yum -y install git

    fi
    if [ ${PM} == 'apt-get' ];then
	sudo apt-get -y install git
    fi

}

case $command in
port)
    #if [ `distName` != 'CentOS' ];then
#	echo '抱歉,暂不支持cetnos7一下的版本'
#	exit 1
 #   fi
    if [ "$2" == '--help' ];then
	port
	exit 1
    fi

	
    firewall-cmd --zone=public --add-port=80/tcp --permanent > /dev/null 2>&1 &
    if [ !  $? ];then
        green_info "loading firewalld...................."
	yum -y install firewalld && systemctl start firewalld
    fi

    if [ "$2" == '-add' ];then
	if [ ! $3  ];then
            red_error "${paramsError}"	
	fi

	#command="firewall-cmd --zone=public --add-port="
	#commandEnd="/tcp --permanent"
	#eval ${command}$3${commandEnd}

        firewall-cmd --zone=public --add-port=$3/tcp --permanent >/dev/null && firewall-cmd --reload
	exit 1
    fi

    if [ "$2" == '-query' ];then
	if [ ! $3 ];then
	    red_error "${portError}"
	    exit 1		
	fi
        firewall-cmd --zone=public --query-port=$3/tcp --permanent
	exit 1
    fi

    if [ "$2" == '-delete' ];then
	firewall-cmd --zone=public --remove-port=$3/tcp --permanent >/dev/null && firewall-cmd --reload
	exit 1
    fi
    
    if [ "$2" == '-all' ];then
	firewall-cmd --zone=public --list-ports
	exit 1
    fi 

    if [ $2 != '-all' ] && [ ! $3 ];then
        red_error "${paramsError}"
	exit 1
    fi
    red_error "${paramsError}"
    ;; 
docker)

    Get_Pack_Manager
    if [ "$2" == '--help' ];then
        docker_help
        exit 1
    fi

    if [ "$2" == '-check' ];then
        docker_install
	exit 1
    fi	
    
    if [ "$2" == '-compose' ];then
	
        if [ "$3" == '-v' ];then
            docker-compose -v
	    	
            if [ $? -ne 0 ];then
		red_error "${noCompose}"
	    fi	
	    exit 1
        fi	
        yj_compose
	exit 1
    fi	
    if [ "$2" == '-lnmp'  ];then 
	
        docker -v > /dev/null 2>&1 
        if [ $? -ne 0 ];then
	    while [ "$go" != 'y' ] && [ "$go" != 'n' ]
        do
	    read -p "${isDockerInstall}" go;
        done	
	fi
	if [ "$go" == 'n' ];then
           exit
        fi	
	
	if [ "$go" == 'y' ];then
	    if [ ${PM} == 'yum' ];then
	        docker_yum	
	    fi

	    if [ ${PM} == 'apt-get' ];then
	        docker_apt
	    fi
        fi
 
	git

	yj_compose
        yj_lnmp
	exit 1
    fi

    if [ "$2" == '-install'  ];then
        docker_install
	exit 1
    fi

    red_error "${paramsError}"
;;
qqrobot)
    
    if [ "$2" == '--help' ];then
        qrobot_help
        exit 1
    fi
    if [ "$2" == '-install' ];then
        if [ ! $3 ];then
            red_error "${portNo}"
            exit 1
        fi
	if [ ! $4 ];then
            red_error "${passNo}"
            exit 1
    fi

    if [ ! $5 ];then
         coolq="cqa"
    else
        coolq="cqp"
    fi

	qqrobot_install $3 $4 $coolq
	
        exit 1
    fi
    if [ "$2" == '-start' ];then
        docker start coolq
        exit 1
    fi
    if [ "$2" == '-init' ];then
        yum -y install dos2unix > /dev/null 2>&1
        chmod -R 777 /root/coolq/app/
        sudo rm -f /root/coolq/app/com.coxxs.tuling123.cpk
        sudo rm -f /root/coolq/app/com.coxxs.start.cpk
        sudo rm -f /root/coolq/app/com.coxxs.music.cpk
	sudo rm -f /root/coolq/app/moe.min.qa.cpk
        sudo cp assets/package/io.github.richardchien.coolqhttpapi.cpk ~/coolq/app/
        green_info ${zjloading}
        exit 1
    fi
    if [ "$2" == '-config' ];then
	if [ ! $3 ];then
            red_error "${qNumber}"
        fi
	if [ ! $4 ];then
            red_error "${inApi}"
        fi
	qqrobot_config $3 $4	
	exit 1
    fi
    if [ "$2" == '-close' ];then
        docker  stop coolq
        exit 1
    fi
	
    if [ "$2" == '-uninstall' ];then
	qqrobot_uninstall
        exit 1
    fi
    if [ "$2" == '-vncpswd' ];then
        qqrobot_forget_vnc
        exit 1
    fi
    red_error "${paramsError}"
;;
lnmp)

    Get_Pack_Manager
    if [ "$2" == '--help' ];then
        lnmp_help
        exit 1
    fi
    if [ "$2" == '-open' ];then
        cd www && docker-compose up -d
        exit 1
    fi
    if [ "$2" == '-close' ];then
        cd www && docker-compose down
        exit 1
    fi
    if [ "$2" == '-change' ];then
    	if [ "$3" == 'php56' ];then
	    blue_info "loading............................"
	    eval $c_change56
	    green_info "${successChange56}" && exit 1
	fi
    	if [ "$3" == 'php7' ];then
	    blue_info "loading............................"
	    eval $c_change7
	    green_info "${successChange7}" && exit 1			
	fi
    fi
    if [ "$2" == '-yjlnmp'  ];then 
	blue_info "${yjlnmpInstall}"
	echo 3
	sleep 1
	echo 2
	sleep 1
	echo 1 
	sleep 1
        docker -v > /dev/null 2>&1 
        if [ $? -ne 0 ];then
 
	    if [ ${PM} == 'yum' ];then
	        docker_yum	
	    fi

	    if [ ${PM} == 'apt-get' ];then
	        docker_apt
	    fi
     	fi
	git
	yj_compose
        yj_lnmp
	exit 1
    fi
    red_error "${paramsError}"
    ;;
--help)
    yjscript_help
    exit 1

    ;;

*)
    red_error paramsError
    exit 1








esac	
