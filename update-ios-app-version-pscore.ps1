<#
.SYNOPSIS
	Sets up iOS app version (c) 2020 Plain Concepts
.DESCRIPTION
    This script sets up iOS app version for different platforms.
    Can be useful to use locally, or inside an automated build environment.
.EXAMPLE
	.\<script_name> -PathToInfoPlist src/Info.plist -BundleShortVersion 1.0.288 -BundleVersion 1028875
.LINK
	https://dev.azure.com/plainconcepts
#>

param
(  
  [Parameter(Mandatory=$true)][string]$BundleShortVersion,
  [Parameter(Mandatory=$true)][string]$BundleVersion,
  [string]$PathToInfoPlist,
  [string]$PathToSecondaryInfoPlist
)

##### UTILITY FUNCTIONS #################################

function LogError($line) { Write-Host "##[error] $line" -Foreground Red -Background Black }
function LogWarning($line) { Write-Host "##[warning] $line" -Foreground DarkYellow -Background Black }
function LogDebug($line) { Write-Host "##[debug] $line" -Foreground Blue -Background Black }

########################################################## 

if ($null -eq $PathToInfoPlist -Or $PathToInfoPlist -eq '') {
    LogError "Path to Info.plist must be set. Exiting..."
    return
}

# Debug
Write-Host "Path to Info.plist: $PathToInfoPlist"
Write-Host "Bundle short version: $BundleShortVersion"
Write-Host "Bundle version: $BundleVersion"

if (-Not (Test-Path $PathToInfoPlist)) {
    LogError "Info.plist not found on $PathToInfoPlist. Exiting..."
    return
}

# Apple wants xxx.xxx.xxx
LogDebug "START updating Info.plist in $PathToInfoPlist, will set shortVersion $BundleShortVersion, version $BundleVersion"
& plutil -replace CFBundleShortVersionString -string $BundleShortVersion $PathToInfoPlist
& plutil -replace CFBundleVersion -string $BundleVersion $PathToInfoPlist
LogDebug "END updating Info.plist"

if ($PathToSecondaryInfoPlist) {
    LogDebug "START updating secondary Info.plist in $PathToSecondaryInfoPlist, will set shortVersion $BundleShortVersion, version $BundleVersion"
    & plutil -replace CFBundleShortVersionString -string $BundleShortVersion $PathToSecondaryInfoPlist
    & plutil -replace CFBundleVersion -string $BundleVersion $PathToSecondaryInfoPlist
    LogDebug "END updating secondary Info.plist"
}
