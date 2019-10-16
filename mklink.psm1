# +-----------------------+-----------------------------------------------------------+
# | mklink syntax         | Powershell equivalent                                     |
# +-----------------------+-----------------------------------------------------------+
# | mklink Link Target    | New-Item -ItemType SymbolicLink -Name Link -Target Target |
# | mklink /D Link Target | New-Item -ItemType SymbolicLink -Name Link -Target Target |
# | mklink /H Link Target | New-Item -ItemType HardLink -Name Link -Target Target     |
# | mklink /J Link Target | New-Item -ItemType Junction -Name Link -Target Target     |
# +-----------------------+-----------------------------------------------------------+

function mklink
{
    Param(
        [Parameter(Mandatory=$true)][string]$link,
        [Parameter(Mandatory=$true)][string]$target,
        [switch]$watch = $false
    )

    if ($watch -and !(Get-Module "pswatch")) {
        Write-Error "pswatch is not installed. see: https://github.com/Beej126/pswatch"
        Return
    }

    Resolve-Path $target -ErrorAction Stop
    #$isSymLink = (get-item $link).linktype -eq "SymbolicLink"
    if ((test-path $link) -and !(test-path "$link`.bak")) { Move-Item $link "$link`.bak" }

    if (test-path $link) { Remove-Item $link }
    New-Item -ItemType SymbolicLink -Name $link -Target $target

    if ($watch -and (Get-Module "watch")) {
        watch $target | ForEach-Object{
            Remove-Item $link
            New-Item -ItemType SymbolicLink -Name $link -Target $target
        }
    }
}
