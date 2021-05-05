param ($choix, $Nom_Ordinateur, $Groupe='ecole')

#################
##
# Variable
##
##################

$Switch = 'Interne' # nom de la carte trouvable via Get-VMNetworkAdapter -All

$CPU_SRV = 3 # Nombre de CPU a allouer par Serveurs 
$CPU_CLI = 1 # Nombre de CPU a allouer par clients
$DEF_PATH = 'E:\Hyper_V\VHD' # Chemin vers le dossier hyper V
#Groupe sert a pouvoir supprimer toutes les VM concerner facilement

Clear-Host

#################
##
# verification et creation du groupe pour retrouver les Vm plus facilement par la suite
##
##################
$a = $null
$a = Get-VMGroup -Name $Groupe
if ( $a -eq $null) {
    Write-Host  -ForegroundColor Green 'Creation groupe => ' $Groupe 
    New-VMGroup -Name $Groupe -GroupType VMCollectionType
}
Write-Host  -ForegroundColor DarkGray 'Groupe actuel => ' $Groupe

    Write-Host ''


#################
##
# si le choix n'a pas deja été fait, il sera demander ici 
##
##################


if ($choix -eq $null) {
Write-Host 'Nouveaux Serveur : 1'
Write-Host 'Nouveaux Client : 2'
Write-Host 'Nettoyage : nettoyage'

$choix = Read-Host -Prompt 'Choix'

}

if ($Nom_Ordinateur -eq $null -and $choix -ne 'nettoyage') {
$Nom = Read-Host -Prompt 'Nom de lordinateur'

}

#################
##
# changement des variables en fonctions des choix defini lors de l'appel ou de la partie precedente
##
##################

$flag = $false
 
If($choix -eq "1") 
{
    $smallPath = $DEF_PATH + '\Source\Source.Windows.SRV.vhdx'
    $cpu = $CPU_SRV
    $memStart = 3GB
    $flag = $true
}
elseif ($choix -eq "2") 
{
    $smallPath = $DEF_PATH + '\Source\Source.Windows10.Pro.vhdx'
    $cpu = $CPU_CLI
    $memStart = 1GB

    $flag = $true

}
elseif ($choix -eq "nettoyage") 
{
    #################
    ##
    # partie permettant le nettoyage de toute les VM qui ont été faite
    ##
    ##################
    Write-Host -ForegroundColor Green 'debut du nettoyage'
    $ListVM = Get-VMGroup -Name ecole

    Foreach($VM in $ListVM.VMMembers) 
    {
        $pathVHD = Get-VHD -VMId $VM.Id
        Remove-VM $VM -Force
        Remove-Item $pathVHD.Path -Force
    }
    Write-Host -ForegroundColor Green 'Fin nettoyage'


}
Get-VMGroup -Name ecole | ForEach-Object VMMembers


#################
##
# creation du disque de differentiation et de la VM le concernant
# on change en même temps le nombre de CPU + on le rajoute au groupe
##
##################
if($flag)
{
    Write-Host  -ForegroundColor Green 'Creation Disque Dur'
    New-VHD -ParentPath $smallPath -Path $DEF_PATH\$Groupe.$Nom.vhdx -Differencing

    Write-Host  -ForegroundColor Green 'Creation Machine'
    $a = New-VM -VHDPath $DEF_PATH\$Groupe.$Nom.vhdx -Generation 2 -Name $Nom -MemoryStartupBytes $memStart -SwitchName Interne

    Set-VMProcessor -VMName $Nom -Count $CPU_SRV
    Add-VMGroupMember -Name $Groupe -VM $a
}
