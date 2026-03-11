
LOG=/tmp/roboshop.log
echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Catalogue Service >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service /etc/systemd/system/catalogue.service  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Mongo Repo >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Disable NodeJS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf module disable nodejs -y &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Enable NodeJS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf module enable nodejs:18 -y  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install NodeJS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf install nodejs -y  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application User >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
useradd roboshop  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Remove Existing Directory>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
rm -rf /app  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application Directory >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
mkdir /app  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Download Catalogue file >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Extract Catalogue Service >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
cd /app
unzip /tmp/catalogue.zip  &>>"${log}"
cd /app
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install NPM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
npm install  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Mongo Client >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
dnf install mongodb-org-shell -y  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Load Schema>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
mongo --host mongodb.anysite.info </app/schema/catalogue.js  &>>"${log}"
echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Start Catalogue Service>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload  &>>"${log}"
systemctl enable catalogue  &>>"${log}"
systemctl restart catalogue  &>>"${log}"