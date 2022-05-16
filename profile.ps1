if ($IsWindows)
{
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $identity
    $isAdmin = ($principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
}
if ($IsLinux)
{
    $principal = & id -u
    $isAdmin = $principal -eq 0
}
if (-not $isAdmin)
{
    if ($IsWindows)
    {
        [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")|Out-Null
        if (-not ((New-Object System.Drawing.Text.InstalledFontCollection).Families -contains "CaskaydiaCove NF"))
        {
            Write-Error "CaskaydiaCove NF font family not installed - https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
            break
            <# Run as Administrator
            iwr https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip -OutFile $env:TEMP\CascadiaCode.zip
            Expand-Archive $env:TEMP\CascadiaCode.zip $env:TEMP\CascadiaCode
            gci $env:TEMP\CascadiaCode\|%{
                ((New-Object -ComObject Shell.Application).Namespace(0x14)).CopyHere($_.FullName)
                cp $_.FullName $env:windir\Fonts\
            }
            #>
        }
        if (-not ((Get-Command oh-my-posh|measure).Count -gt 0))
        {
            Write-Error "Oh My Posh not available"
            break
            <# Run as Administrator
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
            [Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";$($env:LOCALAPPDATA)\Programs\oh-my-posh\bin", [EnvironmentVariableTarget]::Machine)
            #>
        }
    }
    if ($IsLinux)
    {
        if (-not (& fc-list|?{$_ -like "*Caskaydia*"}|measure).Count -gt 0)
        {
            Write-Error "CaskaydiaCove NF font family not installed - https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
            break
        }
        if (-not ((& which oh-my-posh)|measure).Count -gt 0)
        {
            sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
            sudo chmod +x /usr/local/bin/oh-my-posh
        }
        $env:TEMP = "/tmp"
    }
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
    if ($null -eq (Get-Module -ListAvailable "PSReadLine")|?{$_.Version -eq "2.2.0"}) {Install-Module "PSReadLine" -Scope CurrentUser -AllowPrerelease -Force -MinimumVersion 2.2.0-beta3}
    if ($null -eq (Get-Module -ListAvailable "CompletionPredictor")) {Install-Module -Name CompletionPredictor -Repository PSGallery -Scope CurrentUser}
    if ($null -eq (Get-Module -ListAvailable "Terminal-Icons")) {Install-Module "Terminal-Icons" -Scope CurrentUser}
    iwr https://raw.githubusercontent.com/Snozzberries/Profiles/main/ohmyposh.json -OutFile $env:TEMP\ohmyposh.json
    oh-my-posh init pwsh -c $env:TEMP\ohmyposh.json|Invoke-Expression
    Import-Module -Name Terminal-Icons
    Import-Module -Name PSReadLine -MinimumVersion 2.2.0 -Force
    Import-Module -Name CompletionPredictor
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
}
