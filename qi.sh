# Quick install
sudo apt update
sudo apt install -y git
git clone https://github.com/mohammadali-arjomand/setup-neovim.git
cd setup-neovim
bash setup-neovim.sh
cd ..
rm -f setup-neovim/*
rmdir setup-neovim
echo "Quick Installation Done!"
