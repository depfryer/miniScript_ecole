# miniScript_ecole

## usage 
### configuration du script
dans le script il faut modifier les variables presente au debut afin de correspondre a notre configuration
```
$Switch = 'Interne' # nom de la carte trouvable via Get-VMNetworkAdapter -All

$CPU_SRV = 3 # Nombre de CPU a allouer par Serveurs 
$CPU_CLI = 1 # Nombre de CPU a allouer par clients
$DEF_PATH = 'E:\Hyper_V\VHD' # Chemin vers le dossier hyper V
#Groupe sert a pouvoir supprimer toutes les VM concerner facilement (il est present comme argument par defaut)
```
### creation des fichiers maitre 

dans le dossier designé dans DEF_PATH, creer un dossier source (il contiendra les fichiers qui devront etre immuable)
une fois cela fait, il faut créer les 2 fichiers maitre, pour ce faire il faut faire une installation du windows serveur et nommer comme suit : 
serveur : "Source.Windows.SRV.vhdx"
client : "Source.Windows10.Pro.vhdx" 
(il est egalement possible de changer tout cela plus bas dans le script)

installer les VM 
faire les mises a jour
puis rentrer la commande : `C:\windows\system32\sysprep\sysprep.exe /generalize /shutdown /oobe  /mode:vm`
la machine va s'eteindre d'elle même

supprimer la VM (en laissant le disque dur)

### Usage du script :
lancer le script 

rentrer 1 si on veut creer un serveur, 2 un client et 'nettoyage' si l'on veut supprimer toutes les VM ainsi que les disques dur lié

## Avantage 
permet un gain de temps pour creer les machines virtuel (pas besoin de creer a la main les disques dur, changer le nombre de coeur CPU, utiliser l'interface d'hyper V

