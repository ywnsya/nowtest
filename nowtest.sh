#!/bin/bash
#try yum/apt
pkg='yum'
type yum
if [ $? == '1' ]
then
pkg='deb'
fi

#try curl
type curl
if [ $? == '1' ]
then
$pkg -y install curl
fi

version='1.0.1';


echo "
____________________________________
|                                   |
|   Now Test--Linux Servers Test    |
|Version $version 
";