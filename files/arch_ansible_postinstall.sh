#!/bin/sh

# définir des variables
# le repertoire ou trouver les mirroirs
output="/etc/pacman.d"
#output="output"
mirrorlist=$output"/mirrorlist"
backup=$output"/mirrorlist.bak"

# backup du fichier des mirroirs arch
if [ -e $backup ]
then
	echo "backup already here!"
else
	mv $mirrorlist $backup
fi

echo "Server = http://mirror.archlinuxarm.org/\$arch/\$repo" > $mirrorlist

# selectionne le mirroir de dépots que tu veux utiliser

PS3="choisi un mirroir à ajouter: "


mirrors=("Australie : Sydney" "Brésil : Sao Polo" "Danemark : Aalborg" "Allemagne : Aachen" "Allemagne : Berlin" "Allemagne : Coburg" "Allemagne: Falkenstein" "Grèce : Athènes" "Hongrie : Budapest" "Japon : Tokyo" "Singapour" "Afrique du Sud : Jo-bourg" "Taïwan : Hsinchu" "Taïwan : Taïpeï" "UK : Londres" "USA : Californie" "USA : Floride" "USA : Illinois" "USA : New Jersey" "Done")

select mirror in "${mirrors[@]}"
do
	case $REPLY in
		1) echo "mirroir selectionné : $mirror"; echo "Server = http://au.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		2) echo "mirroir selectionné : $mirror"; echo "Server = http://br.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		3) echo "mirroir selectionné : $mirror"; echo "Server = http://dk.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		4) echo "mirroir selectionné : $mirror"; echo "Server = http://de3.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		5) echo "mirroir selectionné : $mirror"; echo "Server = http://de.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		6) echo "mirroir selectionné : $mirror"; echo "Server = http://de4.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		7) echo "mirroir selectionné : $mirror"; echo "Server = http://eu.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist; echo "Server = http://de5.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirorlist;;
		8) echo "mirroir selectionné : $mirror"; echo "Server = http://gr.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		9) echo "mirroir selectionné : $mirror"; echo "Server = http://hu.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		10) echo "mirroir selectionné : $mirror"; echo "Server = http://jp.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		11) echo "mirroir selectionné : $mirror"; echo "Server = http://sg.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		12) echo "mirroir selectionné : $mirror"; echo "Server = http://za.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		13) echo "mirroir selectionné : $mirror"; echo "Server = http://tw2.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		14) echo "mirroir selectionné : $mirror"; echo "Server = http://tw.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		15) echo "mirroir selectionné : $mirror"; echo "Server = http://uk.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		16) echo "mirroir selectionné : $mirror"; echo "Server = http://ca.us.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		17) echo "mirroir selectionné : $mirror"; echo "Server = http://fl.us.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		18) echo "mirroir selectionné : $mirror"; echo "Server = http://il.us.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		19) echo "mirroir selectionné : $mirror"; echo "Server = http://nj.us.mirror.archlinuxarm.org/\$arg/\$repo" >> $mirrorlist;;
		20) echo "We're done!"; break;;
		*) echo "Ooops - unknown choice $REPLY";;
	esac
done

# met à jour Pacman
echo "mise à jour de du système..."
pacman -Syyu --noconfirm 
echo "...OK"

## installe quelques outils de base
pacman -Sy openssl --noconfirm
echo "installation de sudo..."
pacman -Sy --noconfirm sudo
echo "...OK"
echo "installation de python..." # nécessaire pour ansible
pacman -Sy --noconfirm python
echo "...OK"

## backup sudoers
cp /etc/sudoers /etc/sudoers.bak
## ré-écriture
echo "root ALL=(ALL:ALL) ALL" > /etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "@includedir /etc/sudoers.d" >> /etc/sudoers

## ajoute un utilisateur ansible

while true; do
read -p "ajoute un utilisateur ansible? (yes/no) " yn

case $yn in 
	yes ) echo "ajout de l'utilisateur ansible";
		useradd ansible -U -m -G wheel;
		passwd ansible;
		break;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

done

## reboot
while true; do
read -p "reboot? (yes/no) " yn

case $yn in 
	yes ) echo ok, we will reboot;
		sleep 5;
		reboot;
		break;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

done



