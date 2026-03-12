log=/tmp/roboshop.log

func_schema_setup(){
  if [ "${schema_setup}" == "mongodb" ]; then
    echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Mongo Client >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
    dnf install mongodb-org-shell -y   &>>${log}
    echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Load Schema>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
    mongo --host mongodb.anysite.info </app/schema/${component}.js   &>>${log}

  fi

  if [ "${schema_setup}" == "mysql" ]; then
    echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install MySQL Client >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
    dnf install mysql -y &>>${log}
    echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Load Schema >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
    mysql -h mysql.anysite.info -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

  fi
}
func_appreq(){
  echo -e "\e[32m>>>>>>>>>>>>>>>>>>>>>>>>>>>>Create ${component} Service >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application User >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  useradd roboshop   &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Remove Existing Directory>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  rm -rf /app   &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Application Directory >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  mkdir /app   &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Download ${component} file >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip   &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Extract Catalogue Service >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  cd /app
  unzip /tmp/${component}.zip   &>>${log}
  cd /app
}

func_systemd(){
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Start ${component} Service>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  systemctl daemon-reload   &>>${log}
  systemctl enable catalogue   &>>${log}
  systemctl restart catalogue   &>>${log}
}

func_nodejs(){
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create Mongo Repo >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo   &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Disable NodeJS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  dnf module disable nodejs -y   &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Enable NodeJS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  dnf module enable nodejs:18 -y   &>>${log}
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install NodeJS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  dnf install nodejs -y   &>>${log}
  func_appreq
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install NPM >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  npm install   &>>${log}

  func_schema_setup
  func_systemd
}

func_java(){
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Install Maven >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  dnf install maven -y &>>${log}
  func_appreq
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Create ${component} Package >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  mvn clean package &>>${log}
  mv target/shipping-1.0.jar shipping.jar &>>${log}
  func_schema_setup
  func_systemd
}

func_python(){
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Start Python Service>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  dnf install python36 gcc python3-devel -y &>>${log}
  func_appreq
  echo -e "\e[32m >>>>>>>>>>>>>>>>>>>>>>>>>>>>Download Python Dependencies>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_systemd

}