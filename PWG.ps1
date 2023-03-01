$paramsList = $null
$pwLength
$passwords
foreach ($arg in $args) {
  $paramsList += ,$arg
}
for ($i = 0; $i -lt $paramsList.length; $i++) {
  if ($paramsList[$i] -eq '-l') {
    $pwLength = $paramsList[$i + 1]
  }
}
foreach ($param in $paramsList) {
  if ($param -eq '-h') {
    Write-Output "Usage: PS2.ps1 [-h] [-m] [-o]"
    Write-Output "  -h  Display this help message"
    Write-Output "  -m  Generate multiple passwords"
    Write-Output "  -o  Generate one password"
    Write-Output "  -l  Length of password"
    return
  }
}

function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [int] $length
    )
    $charSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{]+-[*=@:)}$^%;(_!&amp;#?>/|.'.ToCharArray()
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[]($length)

    $rng.GetBytes($bytes)

    $result = New-Object char[]($length)

    for ($i = 0 ; $i -lt $length ; $i++) {
        $result[$i] = $charSet[$bytes[$i]%$charSet.Length]
    }
    return (-join $result)

}
for($i = 0 ; $i -lt $paramsList.length; $i++) {
  if($paramsList[$i] -eq '-m') {
    for($j = 0; $j -lt $paramsList.length; $j++) {
      if ($paramsList[$j] -eq '-o') {
        Write-Output "Can't use -m and -o flags together"
        return
      }
    }
    for($k = 0; $k -lt $paramsList[$i + 1]; $k++) {
      $passwords += ,(Get-RandomPassword $pwLength)
    }
  }
  if($paramsList[$i] -eq '-o') {
    Get-RandomPassword $pwLength
  }
}
function passObj {
  for ($i = 0; $i -lt $passwords.length; $i++) {
    [PSCustomObject]@{
      "Index" = $i
      "Password" = $passwords[$i]
    }
  }
}

passObj | Export-Csv -Path .\export.csv -Append -Force
