get_postman() {
	curl -https://dl.pstmn.io/download/latest/linux64 | tar xvz
	}

get_go() {
  # [get_golang.sh](https://gist.github.com/n8henrie/1043443463a4a511acf98aaa4f8f0f69)
	# Download latest Golang release for AMD64
	# https://dl.google.com/go/go1.10.linux-amd64.tar.gz

	set -euf -o pipefail
	# Install pre-reqs
	# sudo apt-get install python3 git -y
	sudo apt-get install git -y #removed python3 to use miniconda3
	o=$(python3 -c $'import os\nprint(os.get_blocking(0))\nos.set_blocking(0, True)')

	#Download Latest Go
	GOURLREGEX='https://dl.google.com/go/go[0-9\.]+\.linux-amd64.tar.gz'
	echo "Finding latest version of Go for AMD64..."
	url="$(wget -qO- https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 )"
	latest="$(echo $url | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2 )"
	echo "Downloading latest Go for AMD64: ${latest}"
	wget --quiet --continue --show-progress "${url}"
	unset url
	unset GOURLREGEX

	# Remove Old Go
	sudo rm -rf /usr/local/go

	# Install new Go
	sudo tar -C /usr/local -xzf go"${latest}".linux-amd64.tar.gz
	echo "Create the skeleton for your local users go directory"
	mkdir -p ~/go/{bin,pkg,src}
	echo "Setting up GOPATH"
	echo "export GOPATH=~/go" >> ~/.bash_profile && source ~/.bash_profile
	echo "Setting PATH to include golang binaries"
	echo "export PATH='$PATH':/usr/local/go/bin:$GOPATH/bin" >> ~/.bash_profile && source ~/.bash_profile
	echo "Installing dep for dependency management"
	go get -u github.com/golang/dep/cmd/dep

	# Remove Download
	rm go"${latest}".linux-amd64.tar.gz

	# Print Go Version
	/usr/local/go/bin/go version
	python3 -c $'import os\nos.set_blocking(0, '$o')'
}

get_code() {
	set -euf -o pipefail

	sudo apt-get install gpg -y
	curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
	sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

	sudo apt-get update -y
	sudo apt-get install code -y
	sudo apt-get install libxss1 libasound2 -y

	#code --install-extension ms-python.python
	#code --install-extension mauve.terraform
	#code --install-extension erd0s.terraform-autocomplete
	#code --install-extension run-at-scale.terraform-doc-snippets
	#code --install-extenstion tsandall.opa
	#code --install-extension quicktype.quicktype
	#code --install-extension eamodio.gitlens
	#code --install-extension ms-vscode.go
	#code --install-extension peterjausovec.vscode-docker
	#code --install-extension yzhang.markdown-all-in-one
	#code --install-extension shd101wyy.markdown-preview-enhanced
	
	# code --install-extension Zignd.html-css-class-completion
	# code --install-extension ecmel.vscode-html-css
	# code --install-extension redhat.vscode-yaml
	# code --install-extension codezombiech.gitignore
	# code --install-extension IBM.output-colorizer
	# code --install-extension donjayamanne.git-extension-pack
	# code --install-extension formulahendry.docker-extension-pack
	# code --install-extension foxundermoon.shell-format
	# code --install-extension donjayamanne.githistory
	# code --install-extension Shan.code-settings-sync
	# code --install-extension Equinusocio.vsc-material-theme
	# code --install-extension anseki.vscode-color
	# code --install-extension PKief.material-icon-theme
	# code --install-extension robertohuertasm.vscode-icons
	code --list-extensions --show-versions	
}

get_docker() {
	sudo apt-get install \
     		apt-transport-https \
     		ca-certificates \
     		curl \
     		gnupg2 \
     		software-properties-common -y

	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

	sudo add-apt-repository \
   		"deb [arch=amd64] https://download.docker.com/linux/debian \
   		$(lsb_release -cs) \
   		stable"

	sudo apt-get update
	sudo apt-get install docker-ce -y
	me=`whoami`
	sudo usermod -aG docker ${me}
}

get_miniconda3() {
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
	chmod +x Miniconda3-latest-Linux-x86_64.sh
	./Miniconda3-latest-Linux-x86_64.sh -b
	echo 'export PATH=~/miniconda3/bin:$PATH' >>.bash_profile
}

create_profile() {
	echo 'if [ -f ~/.bashrc ]; then
  	 source ~/.bashrc
	fi' >>.bash_profile
}

#### Begin installation ####
echo '=================='
echo 'update and upgrade'
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install wget curl bzip2 -y

printf "\n================\nmake _code directory\n"
cd ~
mkdir _code

printf "\n================\ncreate profile\n"
create_profile

printf "\n================\ninstall docker\n"
get_docker

printf "\n================\ninstall miniconda3\n"
get_miniconda3	#install before go

printf "\n================\ninstall go\n"
get_go

printf "\n================\ninstall vs-code and extensions\n"
get_code

printf "\n================\ninstall postman\n"
#get_postman

sudo apt-get install nano
conda install -c conda-forge awscli
