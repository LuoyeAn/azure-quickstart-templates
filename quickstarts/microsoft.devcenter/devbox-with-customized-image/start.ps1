$userPrincipalName = Read-Host "Please enter user principal name e.g. alias@xxx.com"
$resourceGroupName = Read-Host "Please enter resource group name e.g. rg-devbox-dev"
$location = Read-Host "Please enter region name e.g. eastus"
$userPrincipalId=(Get-AzADUser -UserPrincipalName $userPrincipalName).Id
if($userPrincipalId){
    Write-Host "Start provisioning..."
    az group create -l $location -n $resourceGroupName
    az group deployment create -g $resourceGroupName -f main.bicep --parameters userPrincipalId=$userPrincipalId

# 卸载 Microsoft Teams
  Get-AppxPackage -AllUsers | Where-Object { $_.Name -match MicrosoftTeams } | Remove-AppxPackage -AllUsers

  # 卸载 OneDrive
  taskkill /f /im OneDrive.exe
  Start-Process "$env:SYSTEMROOTSysWOW64OneDriveSetup.exe "/uninstall -NoNewWindow -Wait
  Start-Process "$env:SYSTEMROOTSystem32OneDriveSetup.exe "/uninstall -NoNewWindow -Wait

  # 创建 Excel 快捷方式
  $WScriptShell = New-Object -ComObject WScript.Shell
  $Shortcut = $WScriptShell.CreateShortcut("$env:PUBLICDesktopExcel.lnk)
  $Shortcut.TargetPath = C:Program FilesMicrosoft OfficerootOfficeXXEXCEL.EXE # 请根据实际情况替换 XX 为你的 Office 版本号
  $Shortcut.Save()

  # 安装中文输入法
  $LangList = New-WinUserLanguageList en-US
  $LangList.Add(zh-CN)
  Set-WinUserLanguageList $LangList -Force

  # 设置中文输入法为默认
  $InputMethod = New-WinUserLanguageList zh-CN
  $InputMethod[0].InputMethodTips.Add(0409:00000409) # 英语 (美国) 键盘
  $InputMethod[0].InputMethodTips.Add(0804:00000804) # 中文 (简体，中国) - 微软拼音
  Set-WinUserLanguageList $InputMethod -Force
}else {
    Write-Host "User Principal Name cannot be found."
}

Write-Host "Provisioning Completed."