# Install PowerShell
# https://gist.githubusercontent.com/Snozzberries/26b40d579daeb48b37fbef057644a978/raw/03bd775a7b0f7673a83b720ad56669d4198fc3db/Install-PowerShell.sh
# Link local working directory
ln -s /mnt/c/Users/mike/OneDrive/Documents/Git/ /home/mike/git
# Link PowerShell profile
ln -s /mnt/c/Users/mike/OneDrive/Documents/PowerShell/Profile.ps1 /home/mike/.config/powershell/profile.ps1
# Download config file to map fonts from Windows
sudo wget -q https://raw.githubusercontent.com/Snozzberries/Profiles/main/local.conf -P /etc/fonts/
sudo apt install fontconfig
