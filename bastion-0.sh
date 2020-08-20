#!/bin/bash
software_install_backend() {
   sudo yum install git wget java-1.8.0-openjdk-devel -y
   wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
   sudo tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt
   sudo ln -s /opt/apache-maven-3.6.3/ /opt/maven
   cat <<_EOF >maven.sh
   export JAVA_HOME=/usr/lib/jvm/jre-openjdk
   export M2_HOME=/opt/maven
   export MAVEN_HOME=/opt/maven
   export PATH=/opt/apache-maven-3.6.3/bin:$PATH
_EOF
chmod 777 maven.sh
sudo mv maven.sh /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
sudo setenforce 0
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
}
gitlab_runner_install() {
   curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
   sudo yum install gitlab-runner -y
   sudo service gitlab-runner stop
   sleep 5
   sudo mv /etc/systemd/system/gitlab-runner.service  /etc/systemd/system/gitlab-runner.service.bak
   sudo gitlab-runner install --user=centos --working-directory=/home/centos
   sudo rm /etc/systemd/system/gitlab-runner.service.bak
   sudo service gitlab-runner start
}
software_install_frontend() {
    curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
    sudo yum install httpd nodejs -y
    sudo yum install gcc-c++ make -y
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
    sudo yum install yarn -y
}
gitlab_runner_registry_backend() {
sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "***********************" \
  --executor "shell" \
  --description "my-runner gitlab" \
  --tag-list "my-runner" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
gitlab-runner verify
}
gitlab_runner_registry_frontend() {
sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "***********************" \
  --executor "shell" \
  --description "my-runner gitlab frontend" \
  --tag-list "my-runner-frontend" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
gitlab-runner verify
}

software_install_backend
gitlab_runner_install
gitlab_runner_registry_backend
software_install_frontend
gitlab_runner_registry_frontend