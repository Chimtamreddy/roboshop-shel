# THis remi repos is not working any more, So ignroe this step and move to next step directly. Run the commands from next step.
# dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
source common.sh

echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Disable Redis>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf module disable redis -y &>>${log}
func_exit_status

echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Enable Redis>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf module enable redis:6 -y &>>${log}
func_exit_status
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Redis>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf install redis -y &>>${log}
func_exit_status
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Update Redis Listen Address>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log}
func_exit_status
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Restart Redis>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl enable redis &>>${log}
systemctl restart redis &>>${log}
func_exit_status
