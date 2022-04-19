#!/bin/bash
speed_test(){
speedlog=''
beee=1048576
speedlog=$(./speedtest --no-pre-allocate --server $1 --csv --csv-delimiter Q)
singlespeed=$(./speedtest --no-pre-allocate --single --no-download --server $1 --csv --csv-delimiter Q)
name=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[2]}' )
download=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[7]}' )
download=$(echo "sclae=2; $download/$beee" | bc)
upload=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[8]}' )
upload=$(echo "sclae=2; $upload/$beee" | bc)
ping=$(echo $speedlog |  awk '{split($1, arr, "Q"); print arr[6]}' )
singleupload=$(echo $singlespeed |  awk '{split($1, arr, "Q"); print arr[8]}' )
singleupload=$(echo "sclae=2; $singleupload/$beee" | bc)
printf "%-18s %-18s %-18s %-18s %-12s\n" "$name" "$upload Mbps" "$download Mbps" "$singleupload Mbps" "$ping ms"
}
trace(){
route=''
traceput=$( nowtest/besttrace -w 2 -m 15 $1 -T)
echo $traceput | grep AS4134 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS4134 ChinaNet CT 中国电信163"
fi
echo $traceput | grep AS4809 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS4809 CN2 CT 中国电信CN2"
fi
echo $traceput | grep AS23764 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS23764 CTG.NET CT 中国电信国际网"
fi
echo $traceput | grep AS36678 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS36678 CTA CT 中国电信美洲网"
fi
echo $traceput | grep AS4811 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS4811 ChinaNet-ShanghaiIDC CT 中国电信上海IDC网"
fi
echo $traceput | grep AS4812 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS4812 ChinaNet-Shanghai CT 中国电信上海市网"
fi
echo $traceput | grep AS4538 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS4538 CERNET CE 中国教育网"
fi
echo $traceput | grep AS4808 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS4808 China169-Beijin CU 中国联通169北京市网"
fi
echo $traceput | grep AS4837 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS4837 China169 CU 中国联通169"
fi
echo $traceput | grep AS9808 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS9808 CHINAMOBILE CM 中国移动9808"
fi
echo $traceput | grep AS9929 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS9929 CUII(Industrial Internet) CU 中国联通A网9929"
fi
echo $traceput | grep AS23910 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS23910 CNGI-CERNET2 CE 下一代教育网(CEII)"
fi
echo $traceput | grep AS58834 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS58834 GCableNET 广电网"
fi
#企业、云
echo $traceput | grep AS45062 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS45062 Netease-Network 网易"
fi
echo $traceput | grep AS45090 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS45090 TENCENT-NET-IX 腾讯IX"
fi
echo $traceput | grep AS55990 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS55990 HWCSNET 华为云"
fi
echo $traceput | grep AS58519 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS58519 CHINATELECOM-Ctcloud CT 电信天翼云"
fi
echo $traceput | grep AS37963 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS37963 ALIBABA 阿里云"
fi
echo $traceput | grep AS59077 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS59077 UCLOUD-NET UCLOUD"
fi
echo $traceput | grep AS131486 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS131486 JDCOM 京东"
fi
echo $traceput | grep AS132203 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS132203 TENCENT-NET 腾讯云境外"
fi
echo $traceput | grep AS137753 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS137753 JD 京东"
fi
echo $traceput | grep AS137753 >/dev/null 2>&1
if [ $? == '0' ]
then
route="$route \n AS137753 JD 京东"
fi
route="$route \n _____________________________"

echo -e "$route"
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
type bc
if [ $? == '1' ]
then
$pkg -y install bc
fi
type unzip
if [ $? == '1' ]
then
$pkg -y install unzip
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
type python3
if [ $? == '1' ]
then
$pkg -y install python3
fi
ln -s /usr/bin/python3 /usr/bin/python
mkdir nowtest
curl -L "https://laysense.coding.net/p/nowtest/d/nowtest/git/raw/master/speedtest-cli/speedtest.py" -o nowtest/speedtest
cd nowtest
chmod +x ./speedtest
clear
echo "本脚本将测试单线程上传,因此耗时较长,如服务器用于建站,则单线程上传最具有参考意义"
echo "如出现urlopen error timed out为Speedtest.Net服务器抽风,请稍后再尝试运行"
echo "CT=中国电信 CU=中国联通 CM=中国移动"
printf "%-22s %-18s %-18s %-18s %-12s\n" "服务器" "上传" "下载" "单线程上传" "延迟"
speed_test '24447'
speed_test '39012'
speed_test '3633'
speed_test '27249'
speed_test '35722'
speed_test '17584'
speed_test '29071'
cd ../
fi

if [ $todo == '3' ]
then
dd if=/dev/zero of=/dev/null bs=10M count=1024
echo "以上即为内存速度(仅供估算参考)"
echo "内存一般峰值速度 = 频率 *8 *通道数 如 1600mhz双通道为25.6GB/s"
fi

if [ $todo == '4' ]
then
echo "即将开始极限内存测试(超开检测)"
echo "程序将通过写入随机数据占用内存来测试真实内存,每一次将写入256MB数据,直到服务器无法运行时所得即为真实内存"
echo "可能带来风险,请备份好重要数据并准备重启,低于256MB内存的服务器请不要进行本测试
Do not perform this test on servers with less than 256MB memory
"
echo "输入TEST(大写)进行测试。其他任意退出
Enter TEST(uppercase) to TEST. Any other exit
"
read iftest
if [ $iftest == 'TEST' ]
then 
ramtest='yes'
ramtestnum=0
while (($ramtest == 'yes'))
do
ramtestnum=$(($ramtestnum+256))
ramtestnumsize="$ramtestnum"'M'
mkdir /tmp/memory
mount -t tmpfs -o size=$ramtestnumsize tmpfs /tmp/memory
dd if=/dev/urandom of=/tmp/memory/block
fram=$(free -m | awk '/Mem/ {print $4}')
ram=$(free -m | awk '/Mem/ {print $2}')
swap=$( free -m | awk '/Swap/ {print $2}' )
fswap=$( free -m | awk '/Swap/ {print $4}' )

echo "
Now tested 当前已占用   $ramtestnumsize 内存
Free Ram   剩余内存     $fram MB/ $ram MB
Free Swap  剩余swap     $fswap MB/ $swap MB
Enter yes to test next 256MB . Any other exit
输入yes继续测试，增加256MB，其余退出
"
read ramtest
rm /tmp/memory/block
umount /tmp/memory
rmdir /tmp/memory
done
echo "Tested RAM 已测试内存占用 $ramtestnumsize"
fram=$(free -m | awk '/Mem/ {print $4}')
ram=$(free -m | awk '/Mem/ {print $2}')
echo "Now tested 现在内存占用   $fram MB/ $ram MB "
echo "程序已自动清理测试数据,如当前内存异常请尝试手动删除/tmp/memory/block文件并卸载/tmp/memory以释放内存"
fi
fi

if [ $todo == '5' ]
then
echo "即将下载 BestTrace Form IPIP.net"
echo "仅支持amd64架构。ARM架构请自行手动测试"
mkdir nowtest
curl -L "https://cdn.ipip.net/17mon/besttrace4linux.zip" -o nowtest/besttrace4linux.zip
cd nowtest
unzip besttrace4linux.zip
cd ../
chmod +x nowtest/besttrace
clear
echo "全部使用TCP测试,AS库不全,只检测较有特色的骨干网,测试点来源于网络,不保证可用以及不保证是否包含国内CN2等优化线路"
echo "上海电信";
trace '203.156.197.66'
echo "广东电信";
trace '14.18.190.181'
echo "北京电信";
trace '103.85.164.1'
echo "上海联通";
trace '219.158.112.225'
echo "广东联通";
trace '27.38.199.172'
echo "北京联通";
trace '125.33.186.218'
echo "上海移动";
trace '203.156.197.66'
echo "广东移动";
trace '120.230.8.153'
echo "北京移动";
trace '223.72.76.106'
fi