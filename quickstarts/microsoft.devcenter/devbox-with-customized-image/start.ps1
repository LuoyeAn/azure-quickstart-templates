$userPrincipalName = Read-Host "Please enter user principal name e.g. alias@xxx.com"
$resourceGroupName = Read-Host "Please enter resource group name e.g. rg-devbox-dev"
$location = Read-Host "Please enter region name e.g. eastus"
$userPrincipalId=(Get-AzADUser -UserPrincipalName $userPrincipalName).Id
if($userPrincipalId){
    Write-Host "Start provisioning..."
    az group create -l $location -n $resourceGroupName
    az group deployment create -g $resourceGroupName -f main.bicep --parameters userPrincipalId=$userPrincipalId

# 卸载 Microsoft Teams
Get-AppxPackage -AllUsers Microsoft.Teams | Remove-AppxPackage -AllUsers

  # 卸载 OneDrive
  taskkill /f /im OneDrive.exe
  %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
  %SystemRoot%\SysWOW32\OneDriveSetup.exe /uninstall

  # 创建 Excel 快捷方式
   $WshShell = New-Object -comObject WScript.Shell
   $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Excel Link.lnk")
   $Shortcut.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
   $Shortcut.Arguments = "https://bopoda-my.sharepoint.com/:x:/r/personal/jzfjteacherlab_geekcopilot_net/_layouts/15/doc2.aspx?sourcedoc={80B38B64-13DF-4CFE-B66C-D46DA8665C71}&file=%25u5b66%25u5458%25u4fe1%25u606f%25u767b%25u8bb0%25u8868.xlsx&action=default&mobileredirect=true&wdLOR=c4E1EDFE8-BADA-4939-8807-C0AC130D12B8"
   $Shortcut.Save()

  # 安装中文输入法
    $LangList = New-WinUserLanguageList zh-CN
   Set-WinUserLanguageList $LangList
   $LangList[0].InputMethodTips.Add("0409:00000804") # Microsoft Pinyin
   Set-WinUserLanguageList $LangList -Force
}else {
    Write-Host "User Principal Name cannot be found."
}

Write-Host "Provisioning Completed."