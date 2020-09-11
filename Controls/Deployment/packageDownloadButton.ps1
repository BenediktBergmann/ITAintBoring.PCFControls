function New-PCFControlVersion($manifestFilePath){
    $pattern = 'version="(\d+\.)?(\d+\.)?(\*|\d+)" display-name-key'

	$V = Select-String -Path $manifestFilePath -Pattern $pattern
	$currentVersion = [int]$V.Matches[0].Groups[3].Value
	$nextVersion =  [int]$V.Matches[0].Groups[3].Value + 1

	$fileContent = Get-Content $manifestFilePath
	$fileContent = $fileContent.replace("$currentVersion`"",  "$nextVersion`"") 
	Set-Content -Path $manifestFilePath -value $fileContent
}


.\Settings.ps1 -SolutionOnly

cd ..

if((Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe") -eq $True)
{
  $msBuildExe = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe'
}
if((Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\msbuild.exe") -eq $True)
{
  $msBuildExe = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\msbuild.exe'
}
if((Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe") -eq $True)
{
  $msBuildExe = 'C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe'
}

$solutionFolder = "IndividualSolutions\ITAFileDownloadButtonSolution"

if((Test-Path -Path $solutionFolder) -eq $False)
{
   New-Item "$solutionFolder" -itemtype Directory
}

cd .\"$solutionFolder"

#update version number

$manifestFilePath = "..\..\ITAFileDownloadButton\ITAFileDownloadButton\ControlManifest.Input.xml"
New-PCFControlVersion $manifestFilePath

#version number has been updated

pac.exe solution add-reference --path ..\..\ITAFileDownloadButton


& $msBuildExe /t:restore
& $msBuildExe

cd ..\..\Deployment

Copy-Item "..\$($solutionFolder)\bin\Debug\ITAFileDownloadButtonSolution.zip" .\solutions

#ready




