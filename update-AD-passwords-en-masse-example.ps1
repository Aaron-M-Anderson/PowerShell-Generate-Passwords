# Import-Module ActiveDirectory

$passwords = Import-Csv .\export.csv
$passwordList
$passwords | Select-Object Password | ForEach-Object {
  $passwordList += ,$_.Password
}

Get-ADGroupMember -identity "Domain Users" | Sort-Object name | ForEach-Object -Begin {$counter = 0} -Process {
  $samAccountName = $._"samAccountName"
  $newPassword = ConvertTo-SecureString -AsPlainText $passwordList[$counter] -Force
  Set-ADAccountPassword -Identity $samAccountName -Reset -NewPassword $newPassword
  $counter++
}
