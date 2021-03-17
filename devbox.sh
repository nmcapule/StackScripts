#!/bin/bash

# <UDF name="username" label="The username of the default non-root user." default="user" example="user" />
# <UDF name="password" label="The password of the default non-root user." default="" example="lollipop" />
# <UDF name="ssh_authorized_key" label="Default entry for authorized keys." default="" example="ssh-rsa abcdefg...qwertyuoip user@gmail.com" />

# Refresh repositories.
apt update

# Install: git, zsh, byobu, tree.
apt install git zsh byobu tree --yes

# Create a password-less user $USERNAME with sudo. 
# Note: You can set a password after the script execution w/ `sudo passwd ${USERNAME}`
adduser --disabled-password --gecos "" ${USERNAME} sudo
echo "${USERNAME}:${PASSWORD}" | chpasswd

# Change default shell of $USERNAME to zsh.
chsh -s /usr/bin/zsh ${USERNAME}
touch /home/${USERNAME}/.zshrc

# Login as user $USERNAME.
su ${USERNAME}

# Setup new SSH keys.
ssh-keygen -q -t ed25519  -N '' -f ~/.ssh/id_ed25519 <<<y 2>&1 >/dev/null
eval "$(ssh-agent -s)"
ssh-add /home/${USERNAME}/.ssh/id_ed25519

# Setup ~/.ssh/authorized_keys.
mkdir /home/${USERNAME}/.ssh
echo ${SSH_AUTHORIZED_KEY} >> /home/${USERNAME}/.ssh/authorized_keys

# Setup SSH agent.
echo 'eval "$(ssh-agent -s)"' >> /home/${USERNAME}/.zprofile

# Install: oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Enable byobu in bash.
byobu-enable
# Enable byobu in zsh.
echo "_byobu_sourced=1 . /usr/local/bin/byobu-launch 2>/dev/null || true" >> /home/${USERNAME}/.zprofile

# Set zsh as default shell of byobu.
echo "set -g default-shell /usr/bin/zsh" >> /home/${USERNAME}/.byobu/.tmux.conf
echo "set -g default-command /usr/bin/zsh" >> /home/${USERNAME}/.byobu/.tmux.conf

# Install: linuxbrew.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/${USERNAME}/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install: node and npm.
# brew install node
