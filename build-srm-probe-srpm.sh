#!/bin/sh

moduleName="$1"
TAG="$2"
age="$3"

cd srm-probes
cp -r src ${moduleName}-${TAG}
tar -z -c -f ${moduleName}-${TAG}.src.tar.gz ${moduleName}-${TAG} CHANGES README setup.py

mkdir -p /usr/src/redhat/SOURCES
cp ${moduleName}-${TAG}.src.tar.gz /usr/src/redhat/SOURCES/${moduleName}-${TAG}.tgz

rpmbuild --define '_topdir /usr/src/redhat' -ba grid-monitoring-probes-org.sam.spec

cp -r /usr/src/redhat/* .

cd RPMS/noarch

osMajorRel=$(echo `lsb_release -r | awk -F":" '{print $2}' |awk -F"." '{print $1}'` | tr -d ' ')

case "$osMajorRel" in
  5)  export osType=""
    echo "osType set to SL5"
    ;;
  6)  echo "This is SL6";
    export osType="el6.";
    ;;
  *)  echo "Unknown operating system"
    ;;
esac

rpm2cpio ${moduleName}-${TAG}-${age}.${osType}noarch.rpm| cpio -id
tar -czf ${moduleName}-${TAG}-${age}.${osType}noarch.tar.gz usr

