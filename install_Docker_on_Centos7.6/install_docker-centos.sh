#!/bin/bash
#Mettre à jour la liste des dépots
sudo yum -y update

# install git
sudo yum install -y git
#Récupération du script d'installation de docker
curl -fsSL https://get.docker.com -o get-docker.sh
#Exécution du script
sh get-docker.sh
#Ajout de l'utilisateur vagrant au groupe docker
sudo usermod -aG docker vagrant
#Activer le démarrage automatique du service docker au démarrage de la machine
sudo systemctl enable docker
#Démarrer le service docker
sudo systemctl start docker

#---INSTALLATION DE DOCKER-COMPOSE----------------------------
#Récupération du script d'installation de docker-compose
#sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo curl -SL "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo curl -SL "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#Donner le droit d'exécution sur le script à l'utilisateur
sudo chmod +x /usr/local/bin/docker-compose

if [[ !(-z "$ENABLE_ZSH") && ($ENABLE_ZSH == "true") ]]
then
    echo "We are going to install zsh"
    sudo yum -y install zsh git
    echo "vagrant" | chsh -s /bin/zsh vagrant
    su - vagrant -c 'echo "Y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    su - vagrant -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    sed -i 's/^plugins=/#&/' /home/vagrant/.zshrc
    echo "plugins=(git docker docker-compose colored-man-pages aliases copyfile copypath dotenv zsh-syntax-highlighting jsontools)" >> /home/vagrant/.zshrc
    sed -i "s/^ZSH_THEME=.*/ZSH_THEME='agnoster'/g" /home/vagrant/.zshrc
  else
    echo "The zsh is not installed on this server"    
fi

echo "For this Stack, you will use $(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"