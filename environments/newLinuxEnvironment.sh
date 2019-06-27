#!/bin/bash

# update and upgrade all packages
echo "Updating APT"
sudo apt -y update
sudo apt -y upgrade


echo "Installing utilities and applications"
# Install utilities and apps
sudo apt -y install curl                        # curl
sudo apt -y install git			                # git
sudo apt -y install awscli		                # aws command line
sudo apt -y install python3		                # python 3
sudo apt -y install python3-pip		            # pip3
sudo apt -y install fonts-powerline             # powerline fonts
sudo apt install -y libcanberra-gtk-module      # required for okta awscli
sudo apt install -y libcanberra-gtk3-module     # required for okta awscli
sudo snap install vscode --classic	            # visual studio code
sudo snap install slack --classic	            # slack
sudo snap install chromium		                # chromium
sudo snap install postman                    # postman

curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
sudo apt install -y nodejs                        # install node js server

echo "INSTALL OMZSH"
# Install oh my zsh
sudo apt -y install zsh             # ZSH 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's:env zsh -l::g' | sed 's:chsh -s .*$::g')"


echo "INSTALL ZSH SYNTAX HIGHLIGHTING"
# Install ZSH Syntax Highlighting
sudo apt install zsh-syntax-highlighting
sed -i '$ a\source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ~/.zshrc


echo "INSTALL AND CONFIGURE POWERLEVEL9K"
# Add powerlevel 9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
# Change the ZSH theme to powerlevel9k
sed -i 's#ZSH_THEME="robbyrussell"#ZSH_THEME="powerlevel9k/powerlevel9k"#g' ~/.zshrc
# Add the following line to the top of the .zshrc file
echo "source $HOME/.oh-my-zsh/custom/themes/powerlevel9k" >> ~/.zshrc
# Setup the look of Powerlevel9k
cat << 'EOF' > ~/.powerlevel9k
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator aws background_jobs history time)
EOF


echo "INSTALL SOLARIZED DARK STYLE"
# Install solaraized style
mkdir -p ~/.solarized
cd ~/.solarized
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized
# TODO:  This needs a switch to not prompt.  The --skip-dircolors doesn't work
~/.solarized/gnome-terminal-colors-solarized/set_dark.sh 


echo "INSTALL THE SOURCE CODE PRO FONTS"
# Install the source code pro fonts
FONT_HOME=~/.local/share/fonts
echo "installing fonts at $PWD to $FONT_HOME"
mkdir -p "$FONT_HOME/adobe-fonts/source-code-pro"
find "$FONT_HOME" -iname '*.ttf' -exec echo '{}' \;
(git clone \
   --branch release \
   --depth 1 \
   'https://github.com/adobe-fonts/source-code-pro.git' \
   "$FONT_HOME/adobe-fonts/source-code-pro" && \
fc-cache -f -v "$FONT_HOME/adobe-fonts/source-code-pro")


echo "INSTALL ORACLE JAVA"
# Seems to be required for the okta awscli to work properly
# TODO: fix this so that it grabs the latest and isn't hardcoded
cd ~/Downloads
wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz" -O jdk-8u191-linux-x64.tar.gz
tar xvzf jdk-8u191-linux-x64.tar.gz


echo "ADD JAVA TO PROFILE"
echo 'JAVA_HOME=/home/t/Downloads/jdk1.8.0_191
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export PATH' | sudo tee -a /etc/profile


echo "RUN THE OKTA AWSCLI INSTALLER"
# Install the okta awscli
export PREFIX=/usr/local
wget 'https://raw.githubusercontent.com/oktadeveloper/okta-aws-cli-assume-role/master/bin/install.sh'
chmod +x install.sh
sudo ./install.sh
read -p "Press key to continue.. " -n1 -s

# Replace the settings below as needed
echo "UPDATE THE CONFIG.PROPERTIES FILES WITH REQUIRED SETTINGS"
echo 'OKTA_ORG=NAME HERE
OKTA_AWS_APP_URL=URL HERE
OKTA_USERNAME=
OKTA_PASSWORD=
OKTA_AWS_ROLE_TO_ASSUME=
OKTA_PROFILE=
OKTA_STS_DURATION=3600' | sudo tee -a ~/.okta/config.properties
read -p "Press key to continue.. " -n1 -s


echo "INSTALL TERRAFORM"
# Install terraform
wget 'https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_freebsd_amd64.zip'
unzip terraform_0.11.10_freebsd_amd64.zip
mv terraform /usr/local/bin
chmod +x terraform

