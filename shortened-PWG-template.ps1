$passwords

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
  for($i = 0; $i -lt <amount_of_passwords>; $i++) { #change <amount_of_passwords> to the amount of passwords you want to generate
    $passwords += ,(Get-RandomPassword <password_length>) #change <password_length> to the length of the passwords you want to generate
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
