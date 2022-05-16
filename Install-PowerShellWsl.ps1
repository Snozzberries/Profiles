# https://packages.ubuntu.com/focal/libssl1.1
wget -q http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.13_amd64.deb
sudo apt install ./libssl1.1_1.1.1f-1ubuntu2.13_amd64.deb
wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.2.3/powershell_7.2.3-1.deb_amd64.deb
sudo dpkg -i powershell_7.2.3-1.deb_amd64.deb
# pwsh
# chsh -s /usr/bin/pwsh
