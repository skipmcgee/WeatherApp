#This script will take user imput and sign (or create and sign) a script with a certificate.
#Author: Cpl Dan Gibson                System Level @ creation: Patch 39/MR 18               Completed on 2020/12/04
#
#Sarcio Sordidus  ---  Patch Dirty
#
#These first commands will set the filepath of the .ps1 that needs signing, the name of the certificate, and if a new certificate needs to be generated. 
#Then it will guide the user through the steps of adding the certificate to trusted publishers and trusted root certification authorities
#
#

$filepath = (read-host -Prompt "The file path to whatever script or .exe you are trying to sign")
$dnsname = (read-host -Prompt "certificate name (creating or selecting) (if creating a certificate it is sugested that you use your USMC.mil address") 
$newcert = (read-host -Prompt "is $dnsname an exisiting certificate? yes or no.")
if ( $newcert -match '^y') { "" } else { {
New-SelfSignedCertificate -DnsName $dnsname -Type CodeSigningCert -CertStoreLocation Cert:\LocalMachine\My\} 

Do {Write-host "open mmc, type y for next step" -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "File>add/remove snap in...>certificates>computer account>next>finsih>ok. type y for next step" -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "certificates (LOCAL COMPUTER)>personal>certificates> copy $dnsname , type y for next step" -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "certificates (LOCAL COMPUTER)>trusted root certification authorities>certificates paste $dnsname , type y for next step" -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "certificates (LOCAL COMPUTER)>trusted publishers>certificates paste $dnsname" -ForegroundColor green
    Write-host "type y to sign $filepath with $dnsname certificate" -ForegroundColor cyan
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')
   }
#
#these next commands will sign the file with the new certificate
#
#
$certPath = Get-ChildItem -Path Cert:\LocalMachine\My\ -CodeSigningCert
Set-AuthenticodeSignature -FilePath $filepath -Certificate $certPath
#
#
#These next commands will help the user to add the certificate to the GP Exemption
#
$gpoexempt = (read-host -Prompt "will $dnsname be signing scripts for use on other workstations or $filepath be used on other workstations? yes or no.")
if ( $gpoexempt -match '^y') { { do { Write-host "do you want to create an exemption for $dnsname in Group Policy for use on other workstations?" -ForegroundColor Yellow 
   $YesOrNo=(Read-host -Prompt "Yes or No") }
   Until ($YesOrNo -match '^y') 
   }
   
Do {Write-host "right-click $dnsname and select all tasks>export..., type y for next step" -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "in the wizard, select next, select No,Do not export the private key, select next, select ... PKCS #7..., select next. type y for next step " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "select browse, navigate to \\dc\C\temp, name your certificate $dnsname, select save, next, finish. type y for next step. " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "console into DC VM and launch Group Policy Management, type y for next step" -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host "Navigate to forest...>Domains>group policy objects and double click (JEXC2) (C) Root & Intermediate Certificates (COMP_DC), type y for next step " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host " go to the setings tab and right click. select edit... , type y for next step " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host " in the group policy Management Editor, navigate to Public Key Policies>Trusted Root Certification Authorities. type y for next step " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host " right click inside of Trusted Root Certification Authorities and select import..., type y for next step " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

   Do {Write-host " click next, select browse... and navigate to \\dc\C\temp\$dnsname (ensure that the dropdown menu on the bottom right is on PKCS #7), type y for next step " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')

Do {Write-host " select open, next, next, finish. Verify $dnsname is in Trusted Root Certificate Authorities. type y to continue. " -ForegroundColor green
   $YesOrNo=(Read-host -Prompt "Yes or No")
   } Until ($YesOrNo -match '^y')
   
Write-host "you are done, verify this worked by attempting to run your signed script on another workstation" -ForegroundColor Cyan
}
else { write-host "Script Signing complete for local machine complete" -foregroundcolor cyan }