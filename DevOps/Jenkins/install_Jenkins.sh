#!/bin/bash

ask_before_uninstall() {
    read -p "Do you want to uninstall Jenkins? (y/n) " check_ans
    case "$check_ans" in
        [Yy]* )
            sudo apt-get remove -y jenkins
            sudo apt-get purge -y jenkins
            clear
            echo "Previous Jenkins version uninstalled"
            echo
            sleep 2
            ;;
        [Nn]* )
            clear
            echo "Skipping uninstallation of previous Jenkins version"
            exit
            ;;
        * )
            clear
            echo "Invalid input, please enter y or n"
            ask_before_uninstall
            ;;
    esac
}

install_jenkins() {
    # Install Java
    sudo apt install -y openjdk-11-jdk
    # Set JAVA_HOME for Jenkins
    echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee /etc/profile.d/jdk.sh
    # Reload environment variables
    source /etc/profile.d/jdk.sh
    clear
    java -version
    echo
    echo "Java is installed & configured"
    echo
    sleep 2

    # Install Maven
    sudo apt install -y maven
    clear
    mvn --version
    echo
    echo "Maven is installed"
    echo
    sleep 2

    # Install Git
    sudo apt install -y git
    clear
    git --version
    echo "Git is installed"
    echo
    sleep 2

    # Install Curl
    sudo apt install -y curl
    clear
    curl --version
    echo "Curl is installed"
    echo
    sleep 1

    clear 
    echo "Jenkins Dependencies are installed"
    echo
    echo "Installing Jenkins"
    echo
    sleep 2

    # Installing Jenkins
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-archive-keyring.gpg >/dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-archive-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null
    sudo apt update
    sudo apt install -y jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins

    clear 

    echo "Jenkins is now up & running :)"
    echo 
    echo "You can check its state with the following command:"
    echo "sudo systemctl status jenkins"
    echo 
    echo "To open the web browser, navigate to the Jenkins URL:"
    echo "http://<ip>:8080/ or http://localhost:8080/"
}

# Check if Jenkins is installed
check_jenkins() {
    if [ -x "$(command -v jenkins)" ]; then
        echo "Jenkins is already installed"
        echo
        ask_before_uninstall
    else
        install_jenkins
    fi
}
check_jenkins
