#!/bin/bash
set -u

echo "[i] Ask for sudo password"
sudo -v

os="$(uname)"

if [ "$os" = "Darwin" ]; then
    # install Command Line Tools
    if [[ ! -x /usr/bin/gcc ]]; then
        echo "[i] Install macOS Command Line Tools"
        xcode-select --install
    fi

    # install Homebrew
    if [[ ! -x /usr/local/bin/brew ]]; then
        echo "[i] Install Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    # install ansible
    if [[ ! -x /usr/local/bin/ansible ]]; then
        echo "[i] Install Ansible"
        brew install ansible
    fi

    ansible-playbook --ask-become-pass \
        -i hosts \
        -e 'ansible_python_interpreter=/usr/bin/python3' \
        mac.yml
elif [ "$os" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
		. /etc/os-release

		if [ "$os" = "debian" ]; then
			if [[ ! -x /usr/bin/ansible ]]; then
				echo "[i] Install Ansible"
				sudo apt-get install -y ansible
			fi
		elif [ "$os" = "archlinux" ]; then
			if [[ ! -x /usr/bin/ansible ]]; then
				echo "[i] Install Ansible"
				sudo pacman -S ansible --noconfirm
			fi
		else
			echo "[!] Unsupported Linux Distribution: $ID"
			exit 1
		fi
	else
		echo "[!] Unsupported Linux Distribution"
		exit 1
	fi

    ansible-playbook --ask-become-pass -i hosts linux.yml
else
    echo "[!] Unsupported OS"
    exit 1
fi

# if [ -f "$HOME/.bashrc" ] && [ ! -h "$HOME/.bashrc" ]
# then
#     echo "[i] Move current ~/.bashrc to ~/bashrc_backup"
#     mv "$HOME/.bashrc" "$HOME/bashrc_backup"
# fi

# if [ -f "$HOME/.bash_profile" ] && [ ! -h "$HOME/.bash_profile" ]
# then
#     echo "[i] Move current ~/.bash_profile to ~/bash_profile_backup"
#     mv "$HOME/.bash_profile" "$HOME/bash_profile_backup"
# fi

echo "[i] From now on you can use $ dotfiles to manage your dotfiles"
echo "[i] Done."
