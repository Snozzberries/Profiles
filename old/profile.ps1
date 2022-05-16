$gitHub = "https://github.com/Snozzberries/PowerShell/blob/master/profile.ps1"
$gitHubRaw = "https://raw.githubusercontent.com/Snozzberries/PowerShell/master/profile.ps1"
$profileVersion = "0.3"

$vimPath = "${env:ProgramFiles(x86)}\Vim\vim80\vim.exe"
$gitPath = "$env:ProgramFiles\Git\bin\git.exe"

Set-Alias vi $vimPath
Set-Alias vim $vimPath
Set-Alias git $gitPath

$host.UI.RawUI.BackgroundColor = "black"
Clear-Host

function Set-Prompt
{
    PARAM
    (
        [Parameter()][ValidateSet("reset","simple")]$prompt
    )
    switch($prompt)
    {
        "simple"
        {
            function global:Prompt
            {
                "PS> "
            }
        }
        "reset"
        {
            function global:Prompt
            {
                $(if (test-path variable:/PSDebugContext) { '[DBG]: ' } else { '' }) + 'PS ' + $(Get-Location) + $(if ($nestedpromptlevel -ge 1) { '>>' }) + '> '
            }
        }
        default
        {
            function global:Prompt
            {
                Write-Host -NoNewLine "PS"
                Write-Host -NoNewLine "[$(((Get-History -Count 1).Id + 1).ToString('0000'))]" -ForegroundColor "green"
                #Write-Host -NoNewLine "[$env:USERNAME@$env:USERDNSDOMAIN]" -ForegroundColor "red"
                Write-Host -NoNewLine "[$(Get-Location)]" -ForegroundColor "yellow"
                '> '
            }
        }
    }
}
Write-Host "`r"
Write-Host "$env:COMPUTERNAME.$((Get-WmiObject Win32_ComputerSystem).Domain)"
Get-NetIPAddress|?{$_.addressState -eq "Preferred" -and $_.suffixOrigin -ne "WellKnown"}|%{$if=$_;"$((Get-NetAdapter -InterfaceIndex $_.ifIndex).Name) - $($_.ipAddress) /$($_.prefixLength) => $(if($_.addressFamily -eq "IPv4"){(Get-NetRoute|?{$_.ifIndex -eq $if.ifIndex -and $_.addressFamily -ne "IPv6" -and $_.NextHop -ne "0.0.0.0"}).NextHop}else{(Get-NetRoute|?{$_.ifIndex -eq $if.ifIndex -and $_.addressFamily -ne "IPv4" -and $_.NextHop -ne "::"}).NextHop})`n`tDNS Servers $((Get-DnsClientServerAddress|?{$_.interfaceIndex -eq $if.ifIndex -and $_.addressFamily -eq $if.addressFamily}).ServerAddresses|%{"- $_"})"}
Write-Host "`r"
Set-Prompt

# Open VIM to profile
function Edit-Profile
{
    vim "$env:UserProfile\Documents\WindowsPowerShell\profile.ps1"
}

# Open VIM to VIM Settings
function Edit-Vimrc
{
    vim $env:UserProfile\_vimrc
}

function Invoke-GitPush
{
    PARAM (
        [Parameter()][string]$target = ".\",
        [Parameter(Mandatory=$true)] $comment
    )
    PROCESS
    {
        git add $target
        git commit -m $comment
        git push -u origin master
    }
}

function Test-Profile
{
    $newProfile = ((Invoke-WebRequest $gitHubRaw).content).trim()
    $existingProfile = (Get-Content -Raw "$env:UserProfile\Documents\WindowsPowerShell\profile.ps1").trim()
    
    if ($newProfile -ne $exsistingProfile)
    {
        $title = "Profile Out of Sync"
        $message = "The current profile is not synced to GitHub, would you like to use the GitHub profile?"
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Update PowerShell Profile from GitHub"
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","Retain exsisting PowerShell Profile"
        $options = [System.Management.Automation.Host.ChoiceDescription[]]($no,$yes)
        $response = $host.ui.PromptForChoice($title,$message,$options,0)
        if ($response)
        {
            #$newProfile | Out-File "$env:UserProfile\Documents\WindowsPowerShell\profile.ps1"
            [io.file]::WriteAllText("$env:UserProfile\Documents\WindowsPowerShell\profile.ps1",$newProfile)
        }
    }
}

Test-Profile
