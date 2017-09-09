#--- Install Resolve-MsBuild, Invoke-MsBuild
Write-Output ("Installing Resolve-MsBuild...")
Install-Script Resolve-MsBuild -Force
Write-Output ("Installing Invoke-MsBuild...")
Install-Module Invoke-MsBuild -Force

#--- Build LevelDB Project
Write-Output ("Start to Build...")
$dir = Resolve-Path .
$target = Resolve-Path .\leveldb_ext.sln
$msbuild_path = Resolve-MSBuild.ps1
Write-Output ("MsBuild Path : $msbuild_path")
Write-Output ("Target Path : $target")
# build
$buildResult = Invoke-MsBuild -Path $target `
-Params "/target:Clean;Build /property:Configuration=Release;Platform=x64;BuildInParallel=true /verbosity:Detailed /maxcpucount" `
-BuildLogDirectoryPath "$dir\buildlogs"

Start-Sleep -s 1

if ($buildResult.BuildSucceeded -eq $true)
{
	Write-Output ("Build completed successfully in {0:N1} seconds." -f $buildResult.BuildDuration.TotalSeconds)
	Write-Output ("Release Path : $dir\x64\Release")
}
elseif ($buildResult.BuildSucceeded -eq $false)
{
	Write-Output ("Build failed after {0:N1} seconds. Check the build log file '$($buildResult.BuildLogFilePath)' for errors." -f $buildResult.BuildDuration.TotalSeconds)
}
elseif ($buildResult.BuildSucceeded -eq $null)
{
	Write-Output "Unsure if build passed or failed: $($buildResult.Message)"
}