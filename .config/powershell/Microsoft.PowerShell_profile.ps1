Set-ExecutionPolicy Bypass -Scope Process
Import-Module PSReadline
Import-Module Get-ChildItemColor
Set-PoshPrompt -Theme spaceship

Set-Alias -Name l -Value Get-ChildItemColor -Option AllScope
Set-Alias -Name ls -Value Get-ChildItemColorFormatWide -Option AllScope

Set-Alias -Name acro -Value "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
Set-Alias -Name ff -Value "$env:USERPROFILE\AppData\Local\Mozilla Firefox\firefox.exe"

Set-Alias -Name "nvim" -Value "C:\Portable\neovim\Neovim\bin\nvim.exe"
#Set-Alias -Name "emacs" -Value "C:\Portable\emax64\bin\runemacs"

Set-Alias -Name "ec" -Value Edit-Config

function Get-ADDetails($User){
	return Get-AzureADUser -ObjectId $User | select GivenName, Surname, TelephoneNumber, Mobile, Mail, MailNickname
}

function Find-ADUser($SearchString){
    $results = Get-AzureADUser -SearchString $SearchString
    foreach ($result in $results) {
        $result | select GivenName, Surname, TelephoneNumber, Mobile, Mail, MailNickname
    }
}

function Export-HotfixList() {
	$date = Get-Date -Format "yyyyMMdd-HHmmss"
	Get-HotFix | Select-Object PSComputerName, InstalledOn, __SERVER, __NAMESPACE, Caption, CSName, Description, HotFixID, InstalledBy | Export-Excel -Path $env:USERPROFILE\Desktop\"Hotfix-$date.xlsx" -AutoFilter -AutoSize -TableStyle Light12 -Show -ClearSheet
}

function Get-HtmlViaPandoc($MarkdownFile) {
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    $RenderFileName = (Get-Item -Path $MarkdownFile).BaseName + ".html"
	Out-Default $MarkdownFile
    Start-Process -FilePath "pandoc.exe" -ArgumentList "-f markdown -t html5 -s --self-contained --data-dir `"$env:Pandoc_Datadir`" --template=GitHub --toc -o `"$RenderFileName`" `"$MarkdownFile`" -F $env:Pandoc_Datadir\pandoc-filter\pandoc_plantuml_filter.py -F pandoc-latex-environment" -NoNewWindow -Wait
	Out-Default $RenderFileName
    Invoke-Item -Path "$RenderFileName"
    $stopwatch | Select-Object -Property Elapsed
}

function Get-PdfViaPandoc($MarkdownFile){
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
    $RenderFileName = (Get-Item -Path $MarkdownFile).BaseName + ".pdf"
	Out-Default $MarkdownFile
    Start-Process -FilePath "pandoc.exe" -ArgumentList "-f markdown -t latex --number-sections --data-dir `"$env:Pandoc_Datadir`" --template eisvogel --pdf-engine=xelatex -V colorlinks --listings -o `"$RenderFileName`" `"$MarkdownFile`" -F $env:Pandoc_Datadir\pandoc-filter\pandoc_plantuml_filter.py -F pandoc-latex-environment" -NoNewWindow -Wait
    Invoke-Item -Path "$RenderFileName"
	Out-Default $RenderFileName
    $stopwatch | Select-Object -Property Elapsed
}

function Start-Emacs($File) {
    $run_emacs = "C:\Portable\emax64\bin\emacsclientw.exe"
    $params = "-f C:\Users\Martin\AppData\Roaming\.emacs.d\server\server $File"
    Start-Process -FilePath $run_emacs -ArgumentList $params
}

function Get-Puml($PumlFile) {
	Write-Host "Working on $PumlFile"
    Start-Process -File "java.exe" -ArgumentList "-jar C:\Portable\plantuml\plantuml.jar -charset utf-8 `"$PumlFile`" -tsvg" -Wait
    Start-Process -File "java.exe" -ArgumentList "-jar C:\Portable\plantuml\plantuml.jar -charset utf-8 `"$PumlFile`" -tpng" -Wait
    Start-Process -File "java.exe" -ArgumentList "-jar C:\Portable\plantuml\plantuml.jar -charset utf-8 `"$PumlFile`" -tpdf" -Wait
}

function Get-Slides($MarkdownFile) {
    $stopwatch =  [system.diagnostics.stopwatch]::StartNew()
	$slides_header = "$env:Pandoc_Datadir\templates\headers\slides.tex"
	$pandoc_opts = "--slide-level=2 -V aspectratio:169 -V colorlinks"
    $RenderFileName = (Get-Item -Path $MarkdownFile).BaseName + ".pdf"
	Out-Default $MarkdownFile
    Start-Process -FilePath "pandoc.exe" -ArgumentList "-f markdown -t beamer -H $slides_header $pandoc_opts -o `"$RenderFileName`" `"$MarkdownFile`"" -NoNewWindow -Wait
	Out-Default $RenderFileName
    Invoke-Item -Path "$RenderFileName"
    $stopwatch | Select-Object -Property Elapsed
}

<#
.SYNOPSIS 
    Downloads a generated markdown file with dummy content.
.DESCRIPTION
    Downloads a generated markdown file from the internet with random dummy content.
    Default filename is markdown.md, if not specified differently by -TargetFile.
    Web url is https://jaspervdj.be/lorem-markdownum/markdown.txt
    The download requires your machine to have curl.exe installed.
#>
function Get-MarkdownLorem {
    param(
        [PSDefaultValue(Help = 'markdown.md')]
        [string]
        $TargetFile = 'markdown.md'
    )
    curl.exe https://jaspervdj.be/lorem-markdownum/markdown.txt | Out-File -Encoding UTF8 $TargetFile
}

<#
.SYNOPSIS
    Edit config files in my profile.
.DESCRIPTION
    Shorcut to edit my configuration files using Neovim or Emacs.
    Default is the PowerShell profile.
    Other options are 'WindowsTerminal', 'Emacs', 'Neovim'.
#>
function Edit-Config {
    [CmdletBinding()]
    param(
        [PSDefaultValue(Help = 'PowerShellProfile')]
        [string]
        $SelectedConfig = 'PowerShellProfile'
    )
    $WindowsTerminalConfigFile = $env:USERPROFILE + '\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
    $EmacsConfigOrgFIle = $env:USERPROFILE + '\Documents\git\dotfiles\.emacs.d\Emacs.org'
    $NeovimConfigLua = $env:USERPROFILE + '\AppData\Local\nvim\init.lua'

    switch($SelectedConfig) {
        'PowerShellProfile' {
            nvim $PROFILE; Break
        }
        'WindowsTerminal' {
            nvim $WindowsTerminalConfigFile; Break
        }
        'Emacs' {
            runemacs $EmacsConfigOrgFile; Break
        }
        'Neovim' {
            nvim $NeovimConfigLua; Break
        }
    }
}
Clear-Host
