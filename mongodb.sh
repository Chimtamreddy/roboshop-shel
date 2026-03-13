
source common.sh

echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Mongo Repo>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
func_exit_status

echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Mongo Client>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf install mongodb-org -y &>>${log}
func_exit_status
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Update Listen Address>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
func_exit_status
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Restart Mongod Service>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
systemctl enable mongod &>>${log}
systemctl restart mongod &>>${log}
func_exit_status



