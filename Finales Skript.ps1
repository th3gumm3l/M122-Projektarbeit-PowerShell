# Legende
# Titel: Powershell-Backup
# Gruppe: Bernhard-Wang
# Datum/Version: 29.11.21
# Datei-Name: Version 

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""

$TopSrc = Read-Host "Geben Sie das zu speichernde Verzeichnis an"
$TopBack = Read-Host "Geben Sie das Ziel-Verzeichnis an"

$AliasTopBack = $TopBack

Write-Host "Geben Sie 'start-Backup' ein"

$Datum = get-date -Format dd-MM-yyyy_HHmmss      

function write-LogFile {
    
     param            
         (                                                        
           [String]$wichtig = $TopBack
         )  

    
    if (!(Test-Path -Path ($AliasTopBack + "*\Log"))){
        $LogFolder
        $LogFolder = New-Item -Path $AliasTopBack -name "Log" -ItemType Directory

    }

    $LogFileNameC = Read-Host "Geben Sie den Namen für das LogFile ein: "
    
    # Erstellen des LogFiles            
    $Logfile = New-Item -Path ($AliasTopBack + "*\Log") -Name ("$LogFileNameC" + "_" + "$Datum" + "_LogFile.txt") -ItemType File -Force            
                   
    # Überschrift für das LogFile            
    Add-Content $Logfile ("Die LogDatei wurde erstellt am $(get-date -Format "dddd dd. MMMM yyyy HH:mm:ss") Uhr`n").ToUpper()            
            
    # Leerzeilen einfügen            
    Add-Content $Logfile "`n`n"            
            
    # Spaltenüberschrift generieren                       
    $LogInhalt = "{0,-30}{1,-12}" -f "Zeit","Daten"            
                   
    # Überschrift dem Logfile hinzufügen
    Add-Content $Logfile $LogInhalt    
            
    # Generieren des Zeitstempels für die einzelnen LogZeilen            
    $TimeStamp = get-date -Format "[dd.MM.yyyy HH:mm:ss]"            
                
    # Inhalt ausgeben                       
    $Daten = @(Get-ChildItem $TopSrc -Recurse -Force | select -expand fullname)
    $counter = 0

    Get-ChildItem $TopSrc -Recurse -Force -ea 0 | ForEach-Object {
        $counter++
        $LogInhalt = "{0,-30}{1,-12}" -f $TimeStamp,$daten[$counter]
        Add-Content $Logfile $LogInhalt
    }

}


Function start-Backup {
    
    if (Test-Path -Path $TopBack){
    
        $filename = "\Backup-"+ $Datum +"\"
        $TopBack = New-Item -Path $TopBack -name $filename -ItemType Directory

    }


    else {

        New-Item -Path $TopBack -ItemType Directory
        $filename = "\Backup-"+ $Datum +"\"
        $TopBack = New-Item -Path $TopBack -name $filename -ItemType Directory

    }


    Copy-Item $TopSrc -Recurse $TopBack -Force
    $wichtig = $TopBack
    write-LogFile($wichtig)

}