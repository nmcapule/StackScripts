#!/bin/bash -e
exec > >(tee -i /var/log/stackscript.log)
set -xeo pipefail

# <UDF name="username" label="The username of the default non-root user." default="user" example="user" />
# <UDF name="password" label="The password of the default non-root user." default="" example="lollipop" />
# <UDF name="ssh_authorized_key" label="Default entry for authorized keys." default="" example="ssh-rsa abcdefg...qwertyuoip user@gmail.com" />

# Refresh repositories.
apt update

# Install: git, zsh, byobu, tree.
apt install git zsh byobu tree --yes

# Create a password-less user $USERNAME with sudo. 
# Note: You can set a password after the script execution w/ `sudo passwd ${USERNAME}`
adduser --disabled-password --gecos "" ${USERNAME}
usermod -aG sudo ${USERNAME}
echo "${USERNAME}:${PASSWORD}" | chpasswd

# Change default shell of $USERNAME to zsh.
chsh -s /usr/bin/zsh ${USERNAME}
touch /home/${USERNAME}/.zshrc

# Setup SSH things.
su - ${USERNAME} <<EOF
# Setup new SSH keys.
ssh-keygen -q -t ed25519  -N '' -f ~/.ssh/id_ed25519 <<<y 2>&1 >/dev/null
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
# Setup ~/.ssh/authorized_keys.
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo ${SSH_AUTHORIZED_KEY} >> ~/.ssh/authorized_keys
# Setup SSH agent.
echo 'eval "\$(ssh-agent -s)"' >> ~/.zprofile
EOF

# Setup terminal things.
su - ${USERNAME} <<EOF
# Install: oh-my-zsh
sh -c "\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install: oh-my-zsh autocomplete
git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/plugins=(\(\w\+\))/plugins=(\1 zsh-autosuggestions)/g' ~/.zshrc
# Enable byobu in bash.
byobu-enable
# Enable byobu in zsh.
echo "_byobu_sourced=1 . /usr/local/bin/byobu-launch 2>/dev/null || true" >> ~/.zprofile
# Set zsh as default shell of byobu.
echo "set -g default-shell /usr/bin/zsh" >> ~/.byobu/.tmux.conf
echo "set -g default-command /usr/bin/zsh" >> ~/.byobu/.tmux.conf
EOF

# Setup linuxbrew.
su - ${USERNAME} <<EOF
# Install: linuxbrew.
/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Install: node and npm.
# brew install node
EOF
