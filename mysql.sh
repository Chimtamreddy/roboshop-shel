mysql_root_passwd=$1
if [ -z "${mysql_root_passwd}" ]; then
  echo MySQL Input Password Missing
  exit 1
fi
cp mysql.repo /etc/yum.repos.d/mysql.repo
dnf module disable mysql -y
dnf install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass ${mysql_root_passwd}  #RoboShop@1