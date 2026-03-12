# THis remi repos is not working any more, So ignroe this step and move to next step directly. Run the commands from next step.
# dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module disable redis -y
dnf module enable redis:6 -y
dnf install redis -y
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
#sed -i 's/127.0.0.1/0.0.0.0' /etc/redis.conf /etc/redis/redis.conf
systemctl enable redis
systemctl restart redis