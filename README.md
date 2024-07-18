# Configurations

```bash
# step1: clone plugin repository to your oh-my-zsh folder
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
zsh

# clone zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# clone zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# step2: open the zsh file and set the plugin inside
vim ~/.zshrc
```

## Implement ./install.sh

```bash
./install.sh
```