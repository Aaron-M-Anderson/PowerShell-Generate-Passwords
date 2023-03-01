Import-Module ActiveDirectory

$passwords = Import-Csv .\export.csv
$passwordList
$passwords | Select-Object Password | ForEach-Object {
  $passwordList += ,$_.Password
}

Get-ADGroupMember -identity <group-name> | Sort-Object name | ForEach-Object -Begin {$counter = 0} -Process { #change <group-name>
  $samAccountName = $._"samAccountName"
  $newPassword = ConvertTo-SecureString -AsPlainText $passwordList[$counter] -Force
  Set-ADAccountPassword -Identity $samAccountName -Reset -NewPassword $newPassword
  $counter++
}
