#!/bin/bash
speed_test(){
speedlog=''
speedlog=$(./speedtest --server $1 --csv --csv-delimiter Q)
singlespeed=$(./speedtest --single --server $1 --csv --csv-delimiter Q)
name=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[2]}' )
download=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[7]}' )
upload=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[8]}' )
ping=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[6]}' )
singleupload=$(echo $singlespeed |  awk '{split($1, arr, "Q"); print arr[8]}' )
printf "%-18s %-18s %-18s %-18s %-12s\n" "$name" "$download" "$upload" "$singleupload" "$ping"
}

#try yum/apt
pkg='yum'
type yum
if [ $? == '1' ]
then
pkg='apt'
fi
#try curl
type curl
if [ $? == '1' ]
then
$pkg -y install curl
fi
version='1.0.1';
nversion=$(curl https://laysense.coding.net/p/nowtest/d/nowtest/git/raw/master/version)

echo "
____________________________________
|                                   |
|   Now Test--Linux Servers Test    |
|   Version $version Latest $nversion      |
|  Edit:ENOCH RELEASE:Laysense.com  |
|    Made by LaysenseCloud Global   |
|   https://laysense.com/nowtest/   |
|                                   |
—————————————————————————————————————
Menu:
序号     测试项目               |       快捷指令          |          说明
1. Basic INFO   基础信息检查    |  ./nowtest info        |
2. SpeedTEST    网络测速        |  ./nowtest speedtest   |
3. RAM-TEST     内存测速       |  ./nowtest ramtest      | At least 256Mb memory is required 至少256Mb内存
4. RAM-limit    内存极限测速    | ./nowtest ramlimit     |Prudent use 慎重使用
5. Traceroute(CN)中国方向路由追踪| ./nowtest traceroute   | 

Type the serial number to select
输入序号选择测试内容
";
read todo
if [ $todo == '1' ]
then
cpuname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$(awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
l3cache=$( awk -F: '/cache size/ {cache=$2} END {print cache}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
source /etc/os-release 
#Check vt
vt_kvm=$(dmesg | grep -i kvm)
vt_qemu=$(dmesg | grep -i qemu)
vt_vmware=$(dmesg | grep -i 'VMware Virtual Platform')
vt_vbox=$(dmesg | grep -i VirtualBox )
vt_ms=$(dmesg | grep -i microsoft )
vt_wsl=$(dmesg | grep -i wsl )
vt_parallels=$(dmesg | grep -i Parallels)
vt='No VT'
if [ -n "$vt_kvm" ]; then
vt='KVM'
fi
if [ -n "$vt_qemu" ]; then
vt='QEMU/KVM'
fi
if [ -n "$vt_vmware" ]; then
vt='VMware'
fi
if [ -n "$vt_vbox" ]; then
vt='VirtualBox'
fi
if [ -n "$vt_ms" ]; then
vt='MicroSoft/Hyper-V'
fi
if [ -n "$vt_wsl" ]; then
vt='MicroSoft-WSL'
fi
if [ -n "$vt_parallels" ]; then
vt='Parallels'
fi
if [ -e /proc/xen ]; then
vt='XEN'
fi
fram=$(free -m | awk '/Mem/ {print $4}')
ram=$(free -m | awk '/Mem/ {print $2}')
swap=$( free -m | awk '/Swap/ {print $2}' )
fswap=$( free -m | awk '/Swap/ {print $4}' )
tcpctrl=$( sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}' )
ipinfo=$(curl 'https://api.myip.la/cn?json' )
ip=$(echo $ipinfo | awk '{split($1, arr, "\""); print arr[4]}')
ip_city=$(echo $ipinfo | awk '{split($1, arr, "\""); print arr[10]}')
ip_country=$(echo $ipinfo | awk '{split($1, arr, "\""); print arr[18]}')
isp=$(curl cip.cc/$ip | sed -n '3p' | awk '{print $3}')

echo "
CPU         型号           $cpuname
CPU Cores   核心数量        $cores
CPU Freq    核心频率        $freq     (When in a VM, this value is the base frequency)
CPU L3Cache 三级缓存        $l3cache
Load        负载            $load
VT          虚拟化技术      $vt         For reference only
FreeRAM     空闲内存        $fram MB/ $ram MB
FreeSWAP    空闲虚拟内存    $fswap MB/ $swap MB
TCP-CC      TCP拥堵算法     $tcpctrl
IP          公网IP          $ip
IP Location IP地理位置      $ip_city , $ip_country
ISP                        $isp
"
fi

if [ $todo == '2' ]
then

#官方speedtest不支持单线程
#echo 'Installing Speedtest-cli by ookla'
#echo 'Downloading Speedtest-cli From coding.net Git repo'
#get_arch=`arch`
#if [[ $get_arch =~ "x86_64" ]];then
#arch='amd64';
#elif [[ $get_arch =~ "aarch64" ]];then
#arch='arm64';
#elif [[ $get_arch =~ "i386" ]];then
#arch='i386';
#else
#    echo "Unknow ARCH, choose amd64 by default"
#    arch='amd64'
#fi
#echo "Download form https://laysense.coding.net/p/nowtest/d/nowtest/git/raw/master/speedtest-cli/$arch/speedtestcli.tgz"
#mkdir nowtest
#curl -L "https://laysense.coding.net/p/nowtest/d/nowtest/git/raw/master/speedtest-cli/$arch/speedtestcli.tgz" -o nowtest/speedtest.tgz
#$pkg install tar
#cd nowtest
#tar -zxvf speedtest.tgz
#chmod +x ./speedtest
#使用python版本 https://github.com/sivel/speedtest-cli/
echo 'Installing Speedtest-cli-python by sivel(https://github.com/sivel/speedtest-cli/)'
echo 'Now installing python'
$pkg -y install python3
 ln -s /usr/bin/python3 /usr/bin/python
mkdir nowtest
curl -L "https://laysense.coding.net/p/nowtest/d/nowtest/git/raw/master/speedtest-cli/speedtest.py" -o nowtest/speedtest
cd nowtest
chmod +x ./speedtest
printf "%-18s %-18s %-18s %-18s %-12s\n" "服务器" "上传" "下载" "单线程上传" "延迟"
speedtest '24447'
speedtest '39012'
speedtest '3633'
speedtest '27249'
speedtest '35722'
speedtest '17584'
speedtest '29071'
fi

