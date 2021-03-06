###############################################################################
## Get-SpecialPath Function (should be an external function in your profile, really)
##   This is an enhancement of [Environment]::GetFolderPath($folder) to add 
##   support for 8 additional folders, including QuickLaunch, and the common 
##   or "All Users" folders... while still supporting My Documents, Startup, etc.
###############################################################################
param([string]$folder)
BEGIN {
  if ($folder.Length -gt 0) { 
	 return $folder | &($MyInvocation.InvocationName); 
  } else {
	 $WshShellFolders=@{CommonDesktop=0;CommonStartMenu=1;CommonPrograms=2;CommonStartup=3;PrintHood=6;Fonts=8;NetHood=9};
  }
}
PROCESS {
  if($_){
	 ## Eliminate the options that are easiest to eliminate
	 if($_ -eq "QuickLaunch") {
		$f1 = [Environment]::GetFolderPath("ApplicationData")
		return Join-Path $f1 "\Microsoft\Internet Explorer\Quick Launch"
		## Test WshShellFolders first because it's easiest won't throw an exception
	 } elseif($WshShellFolders.Contains($_)){
		if(-not (Test-Path variable:\global:WshShell)) { $global:WshShell = New-Object -com "WScript.Shell" }
		return ([string[]]$global:WshShell.SpecialFolders)[$WshShellFolders[$_]]
	 } else {
		## Finally, try GetFolderPath, and if it throws, change the error message:
		trap
		{
		   throw new-object system.componentmodel.invalidenumargumentexception $(
			  "Cannot convert value `"$_`" to type `"SpecialFolder`" due to invalid enumeration values. " +
			  "Specify one of the following enumeration values and try again. The possible enumeration values are: " +
			  "Desktop, Programs, Personal, MyDocuments, Favorites, Startup, Recent, SendTo, StartMenu, MyMusic, " +
			  "DesktopDirectory, MyComputer, Templates, ApplicationData, LocalApplicationData, InternetCache, Cookies, " +
			  "History, CommonApplicationData, System, ProgramFiles, MyPictures, CommonProgramFiles, CommonDesktop, " +
			  "CommonStartMenu, CommonPrograms, CommonStartup, PrintHood, Fonts, NetHood, QuickLaunch")
		}
		return [Environment]::GetFolderPath($_)
	 }
  }
}
