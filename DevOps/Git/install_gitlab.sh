#!/bin/bash

# Read the external URL from an environment variable or prompt the user
EXTERNAL_URL=${EXTERNAL_URL:-$(read -p "Enter the external URL for GitLab: " EXTERNAL_URL && echo $EXTERNAL_URL)}

update_and_install_common() {
    # Common packages and steps for both RH and UB
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

RH(){
    sudo yum upgrade -y
    sudo yum update -y

    # Install and configure the necessary dependencies
    sudo yum install -y curl policycoreutils-python openssh-server perl
    sudo systemctl enable --now sshd
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo systemctl reload firewalld

    # Add the GitLab package repository and install the package
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
    sudo EXTERNAL_URL="http://$EXTERNAL_URL:80" yum install -y gitlab-ee

    # Install and configure GitLab Runner
    curl -sSL https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
    sudo yum install -y gitlab-runner
}

UB(){
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

    # Add the GitLab package repository and install the package
    curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
    sudo EXTERNAL_URL="http://$EXTERNAL_URL:80" apt install -y gitlab-ee

    # Install and configure GitLab Runner
    curl -sSL https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
    sudo apt-get install -y gitlab-runner
}

if [ -f /etc/debian_version ]; then
    echo "Distro is Ubuntu or Debian"
    UB
    update_and_install_common
elif [ -f /etc/redhat-release ]; then
    echo "Distro is CentOS or RHEL"
    RH
    update_and_install_common
fi

# Common post-installation steps
sudo gitlab-ctl reconfigure
sudo gitlab-ctl restart
sudo gitlab-runner register -n \
  --url "http://$EXTERNAL_URL" \
  --registration-token $REG_TOKEN \
  --executor docker \
  --description "My Docker Runner" \
  --docker-image "docker:20.10.16" \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock

username="User: root"
password=$(sudo cat /etc/gitlab/initial_root_password | grep Password:)
echo -e "\nopen http://$EXTERNAL_URL in your browser and login with the following credentials:"
echo -e "\n$username\n$password"
