# MIT License
# 
# Copyright (c) 2019 Yoichi Hirotake
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE`
# SOFTWARE.




$FQDN = "QlikServer1.domain.local"
$maxFileSizev = 52442890 #Default value is 524428900 [byte]
$maxLibrarySizev = 209715300 #Default value is 209715300[byte]


$hdrs = @{}
$hdrs.Add("X-Qlik-Xrfkey","examplexrfkey123")
$hdrs.Add("X-Qlik-User", "UserDirectory=Domain;UserId=Administrator")
#$hdrs
$xrfkey="examplexrfkey123"
#$xrfkey
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where {$_.Subject -like '*QlikClient*'}
#$cert


add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy


$quota1of2 = Invoke-RestMethod -Uri "https://$($FQDN):4242/qrs/appcontentquota/full?xrfkey=$($xrfkey)" -Method Get -Headers $hdrs -ContentType 'application/json' -Certificate $cert
#$quota1of2

$return = $quota1of2 | Out-String

$rtn = $return  -replace "`r`n",','
$rtn = $rtn -replace "\s", ''
$rtn = $rtn.Remove(0,2)
$rtn = $rtn.Split(",")
$rtn = $rtn.Split(":")
$id = $rtn[0] #$id
$idv = $rtn[1] #$idv
$createDate = $rtn[2]
$createDatev = $rtn[3] + ':' + $rtn[4] + ':' + $rtn[5] #$createDatev
$modifiedDate = $rtn[6] #$modifiedDate
$modifiedDatev = $rtn[7] + ':' + $rtn[8] + ':' + $rtn[9] #$modifiedDatev
$modifiedByUserName = $rtn[10] #$modifiedByUserName
$modifiedByUserNamev = $rtn[11]  -replace "\\", "\\" #$modifiedByUserNamev
$customeProperties = $rtn[12] #$customeProperties
$customePropertiesv = $rtn[13]
$customePropertiesv ="[]" #$customePropertiesv
$maxFileSize = $rtn[14] #$maxFileSize
#$maxFileSizev = $rtn[15] #$maxFileSizev
$maxLibrarySize = $rtn[16] #$maxLibrarySize 
#$maxLibrarySizev = $rtn[17] #$maxLibrarySizev
$privileges = $rtn[18] #$privileges
#$privilegesv = $rtn[19] 
$privilegesv = "null" #$privilegesv
$schemapath = $rtn[20] #$schemapath
$schemapathv = $rtn[21] #$schemapathv

$merge = "{"+ "`"$($id)`":"+"`"$($idv)`""+","+"`"$($createDate)`":"+"`"$($createDatev)`""+","+"`"$($modifiedDate)`":"+"`"$($modifiedDatev)`""+","+"`"$($modifiedByUserName)`":"+"`"$($modifiedByUserNamev)`""+","+"`"$($customeProperties)`":"+"$($customePropertiesv)"+","+"`"$($maxFileSize)`":"+$($maxFileSizev)+","+"`"$($maxLibrarySize)`":"+$($maxLibrarySizev)+","+"`"$($privileges)`":"+"$($privilegesv)"+","+"`"$($schemapath)`":"+"`"$($schemapathv)`"" +"}"
#$merge
$body = $merge
#$body

$quota2of2 = Invoke-RestMethod -Uri "https://$($FQDN):4242/qrs/appcontentquota/$($idv)?xrfkey=$($xrfkey)" -Method PUT -Headers $hdrs  -Body $body -ContentType 'application/json' -Certificate $cert
#$quota2of2

Write-Host "Execution Finished"


