# Change Appcontentquota
The script to change Qlik Sense Appcontentquota - maxFileSize and maxLibrarySize
# ReadMe
- The machine from where you run this script must be reachable to the Qlik Sense, and necessary port needs to be opened such as 4242.
- Sense Certificate must be imported into Windows Certificate store Current User > Personal in the machine where you run this script.
   Following public article may be useful on how to export/import certificate.
   https://qliksupport.force.com/articles/000005433
- You may need to change FQDN, UserDirectory and UserId in the script to fit your environment
- You may need to set maxFileSizev and maxLibrarySizev in the script to the value which you want to change
  Default value is: maxFileSizev 524428900 [byte] maxLibrarySizev 209715300[byte]
 
 # Requirement
 Qlik Sesne Server
 
# Instruction
1. Donwload QRS_increaseAppContentQuota.ps1 onto your machine
2. Follow each bullets stated in ReadMe
3. Open Windows Powershell and move to the folder where you saved QRS_increaseAppContentQuota.ps1 on Powershell Console
4. Run .\QRS_increaseAppContentQuota.ps1
5. Execution Finished captures onto Powershell consule. maxFileSize and maxLibrarySize is changed to the value you set in the script
 
 # Disclaimer
The scripts is not supported by Qlik. Please use it on your own risk
# License
This project is provided "AS IS", without any warranty, under the MIT License - see the LICENSE file for details
