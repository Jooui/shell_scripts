#!/bin/bash
#Advertisement if u aren't sudo
if [ "$(whoami)" != "root" ]
then
	echo "Start the script as superuser!!"
	exit
fi

function menu
{
	#Show network interfaces configuration
	ipstaticnic=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f8` #name static nic
	ipdynamicnic=`ip addr | grep "scope global dynamic" | tr -s " " | cut -d" " -f9` #name dynamic nic
	#IPs
	ipstaticmenu=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3`
	ipdynamicmenu=`ip addr | grep "scope global dynamic" | tr -s " " | cut -d" " -f3`
	ipstaticdots=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3 | tr -d [0-9] | wc -c`
	if [ "$ipstaticdots" = "5" ]
	then
		staticnicecho="2- $ipstaticnic: `tput setaf 2`$ipstaticmenu`tput sgr 0`"
	else
		staticnicecho="2- $ipstaticnic `tput setaf 1`not configured`tput sgr 0`"
	fi
	dynamiciecho="1- $ipdynamicnic: `tput setaf 2`$ipdynamicmenu`tput sgr 0`"
	#dhcp state
	dhcpstate=`service isc-dhcp-server status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$dhcpstate" != "active" ] && [ "$dhcpstate" != "failed" ]
	then
	dhcpstate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$dhcpstate" = "active" ]
		then
		Vdhcpstate="`tput setaf 2`$dhcpstate`tput sgr 0`"
		dhcpstate=$Vdhcpstate
		elif [ "$dhcpstate" = "failed" ]
		then
		Fdhcpstate="`tput setaf 1`$dhcpstate`tput sgr 0`"
		dhcpstate=$Fdhcpstate
	fi
	#dns state
	dnsstate=`service bind9 status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$dnsstate" != "active" ] && [ "$dnsstate" != "failed" ]
	then
	dnsstate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$dnsstate" = "active" ]
		then
		Vdnsstate="`tput setaf 2`$dnsstate`tput sgr 0`"
		dnsstate=$Vdnsstate
		elif [ "$dnsstate" = "failed" ]
		then
		Fdnsstate="`tput setaf 1`$dnsstate`tput sgr 0`"
		dnsstate=$Fdnsstate
	fi
	#ldap state
	ldapstate=`service slapd status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$ldapstate" != "active" ] && [ "$ldapstate" != "failed" ]
	then
	ldapstate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$ldapstate" = "active" ]
		then
		Vldapstate="`tput setaf 2`$ldapstate`tput sgr 0`"
		ldapstate=$Vldapstate
		elif [ "$ldapstate" = "failed" ]
		then
		Fldapstate="`tput setaf 1`$ldapstate`tput sgr 0`"
		ldapstate=$Fldapstate
	fi
	#webmin state
	webminstate=`service webmin status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$webminstate" != "active" ] && [ "$webminstate" != "failed" ]
	then
	webminstate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$webminstate" = "active" ]
		then
		Vwebminstate="`tput setaf 2`$webminstate`tput sgr 0`"
		webminstate=$Vwebminstate
		ip1=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3 | cut -d/ -f1`
		ip2=`ip addr | grep "scope global dynamic" | tr -s " " | cut -d" " -f3 | cut -d/ -f1`
		green=`tput setaf 2`
		closec=`tput sgr 0`

		showips=`echo "  -$green https://$ip1:10000
$closec		                              |   -$green https://$ip2:10000 $closec"`
		
		elif [ "$webminstate" = "failed" ]
		then
		Fwebminstate="`tput setaf 1`$webminstate`tput sgr 0`"
		webminstate=$Fwebminstate
	fi

	#FTP Server state
	ftpstate=`service vsftpd status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$ftpstate" != "active" ] && [ "$ftpstate" != "failed" ]
	then
	ftpstate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$ftpstate" = "active" ]
		then
		Vftpstate="`tput setaf 2`$ftpstate`tput sgr 0`"
		ftpstate=$Vftpstate
		elif [ "$ftpstate" = "failed" ]
		then
		Fftpstate="`tput setaf 1`$ftpstate`tput sgr 0`"
		ftpstate=$Fftpstate
	fi

	#SAMBA Server state
	sambastate=`service smbd status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$sambastate" != "active" ] && [ "$sambastate" != "failed" ]
	then
	sambastate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$sambastate" = "active" ]
		then
		Vsambastate="`tput setaf 2`$sambastate`tput sgr 0`"
		sambastate=$Vsambastate
		elif [ "$sambastate" = "failed" ]
		then
		Fsambastate="`tput setaf 1`$sambastate`tput sgr 0`"
		sambastate=$Fsambastate
	fi

    clear
	echo "Basic server configuration.                   |-------- STATUS --------"
    echo "  OS: Ubuntu Server 18.04                     |         "
    echo "  Author: Joel Revert Vila                    | DHCP  state: $dhcpstate"
    echo "                                              | DNS   state: $dnsstate"
    echo "                                              | LDAP  state: $ldapstate"
	echo "                                              | FTP   state: $ftpstate"
	echo "                                              | SAMBA state: $sambastate"
    echo "1- Configuration Network Interfaces           |------------------------"
    echo "2- Configuration DHCP                         | $dynamiciecho"
    echo "3- Configuration LDAP                         | $staticnicecho"
	echo "4- Configuration DNS                          |------------------------"
	echo "5- Webmin's Installation                      | Webmin's state: $webminstate by:"
	echo "6- Samba's Installation                       | $showips"
	echo "7- Lock file repair                           | Samba's state: $sambastate"
	echo "8- Running processes"
	echo "9- FTP Server"
	echo ""
    read optionmenu
    case $optionmenu in
        1)
        script;;
        2)
        comprobardhcp;;
        3)
        ldapmenu;;
		4)
		dnsmenu;;
		5)
		webminmenu;;
		6)
		sambamenu;;
		7)
		lockrepair;;
		8)
		ps all
		#ps all | grep bash | tr -s [:blank:] | cut -d" " -f14
		echo ""
		echo "Press enter to go back..."
		read back
		menu;;
		9)
		ftpservermenu;;
        *)
        menu;;
    esac
}

function ftpservermenu
{
	#FTP Server state
	ftpstate=`service vsftpd status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$ftpstate" != "active" ] && [ "$ftpstate" != "failed" ]
	then
	ftpstate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$ftpstate" = "active" ]
		then
		Vftpstate="`tput setaf 2`$ftpstate`tput sgr 0`"
		ftpstate=$Vftpstate
		elif [ "$ftpstate" = "failed" ]
		then
		Fftpstate="`tput setaf 1`$ftpstate`tput sgr 0`"
		ftpstate=$Fftpstate
	fi

	clear
	echo "---FTP Server Configuration---  State: $ftpstate"
	echo ""
	echo "1 - Install FTP Server"
	echo "2 - Allow anonymous users"
	echo "3 - Virtual Users"
	echo "4 - General configuration"
	echo "5 - Back"

	read ftpoptionmenu
	case $ftpoptionmenu in
		1)
			apt-add-repository multiverse
			apt update
			sudo apt install -y vsftpd libpam-pwdfile apache2 apache2-utils
			sed -i 's/listen_ipv6=YES/listen_ipv6=NO/g' "/etc/vsftpd.conf"
			sed -i 's/listen=NO/listen=YES/g' "/etc/vsftpd.conf"
			sed -i 's/#local_umask=022/local_umask=077/g' "/etc/vsftpd.conf"
			echo "anon_other_write_enable=NO" >> /etc/vsftpd.conf
			service vsftpd restart
			ftpservermenu;;
		2)
		anon_users;;
		3)
		virtualusersftp;;
		4)
		echo "nada";;
		5)
		menu;;
		*)
		ftpservermenu;;
	esac
}

function virtualusersftp
{
	clear
	#user_write_enable status
	vuser_write_enable_status=`cat /etc/vsftpd.conf | grep write_enable | head -1`
	if [ $vuser_write_enable_status = "#write_enable=YES" ] || [ $vuser_write_enable_status = "write_enable=NO" ]
	then
		vuser_write_enable_status="`tput setaf 1`Deny`tput sgr 0`"	
	else
		vuser_write_enable_status="`tput setaf 2`Allow`tput sgr 0`"
	fi


	echo "----Virtual Users Configuration----"
	echo ""
	echo "1 - Install required files"
	echo "2 - Add new user"
	echo "3 - [ $vuser_write_enable_status ] Allow/Deny Upload or Delete files/folders"
	echo "4 - Back"
	read vuser_menu
	case $vuser_menu in
		1)
			check_installation=`cat /etc/vsftpd.conf | grep '#installation_vusers_doned=1'`
			if [ "$check_installation" != "#installation_vusers_doned=1" ]
			then
				echo "----Installation----"
				echo ""
				echo "Make a directory to store your users: (Ex: /etc/vsftpd)"
				read -p">  " vusers_path
				echo "local_root=$vusers_path" >> /etc/vsftpd.conf
				echo "chroot_local_user=YES" >> /etc/vsftpd.conf
				echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
				echo "hide_ids=YES" >> /etc/vsftpd.conf
				echo "user_config_dir=/etc/vsftpd_user_conf" >> /etc/vsftpd.conf
				echo "guest_enable=YES" >> /etc/vsftpd.conf
				echo "virtual_use_local_privs=YES" >> /etc/vsftpd.conf
				echo "nopriv_user=vsftpd" >> /etc/vsftpd.conf
				echo "guest_username=vsftpd" >> /etc/vsftpd.conf
				sed -i 's/#write_enable=YES/write_enable=YES/g' "/etc/vsftpd.conf"
				mkdir /etc/vsftpd
				mkdir -p $vusers_path
				mkdir /etc/vsftpd_user_conf
				echo "#vusers_directory:$vusers_path" >> /etc/vsftpd.conf
				echo "#count_add_vuser=0" >> /etc/vsftpd.conf
				echo "#installation_vusers_doned=1" >> /etc/vsftpd.conf
				echo "auth	sufficient	pam_pwdfile.so pwdfile /etc/vsftpd/ftpd.passwd" >> /etc/pam.d/vsftpd
				echo "auth	sufficient	pam_shells.so" >> /etc/pam.d/vsftpd
				echo "account sufficient pam_permit.so" >> /etc/pam.d/vsftpd
				useradd --home /home/vsftpd --gid nogroup -m --shell /bin/false vsftpd
				service vsftpd restart
				echo "Configurated correctly.... wait.."
				sleep 2
				clear
				virtualusersftp
			else
				echo "You've already installed the virtual users' configuration"
				sleep 2
				clear
				virtualusersftp
			fi
		;;
		2)
			check_installation=`cat /etc/vsftpd.conf | grep '#installation_vusers_doned=1'`
			if [ $check_installation = "#installation_vusers_doned=1" ]
			then
				echo "----Add new Virtual User----"
				echo ""
				read -p"Write the username:  > " vusername
				check_count=`cat /etc/vsftpd.conf | grep "#count_add_vuser="`
				check_dir=`cat /etc/vsftpd.conf | grep "#vusers_directory:" | cut -d: -f2`
				if [ $check_count = "#count_add_vuser=1" ]
				then
					htpasswd -d /etc/vsftpd/ftpd.passwd $vusername
					mkdir -p $check_dir/$vusername
					final_path=$check_dir/$vusername
					echo "local_root=$final_path" > /etc/vsftpd_user_conf/$vusername
					chown vsftpd:nogroup $final_path
					service vsftpd restart
					echo "$vusername added correctly..."
					sleep 1.5
					virtualusersftp
				else
					htpasswd -cd /etc/vsftpd/ftpd.passwd $vusername
					sed -i 's/#count_add_vuser=0/#count_add_vuser=1/g' "/etc/vsftpd.conf"
					mkdir -p $check_dir/$vusername
					final_path=$check_dir/$vusername
					echo "local_root=$final_path" > /etc/vsftpd_user_conf/$vusername
					chown vsftpd:nogroup $final_path
					service vsftpd restart
					echo "$vusername added correctly..."
					sleep 1.5
					virtualusersftp
				fi
			else
				echo "You have to configure it first!!"
				sleep 1
				clear
				virtualusersftp
			fi
		;;
		3)
			vuser_write_enable=`cat /etc/vsftpd.conf | grep write_enable | head -1`
			if [ $vuser_write_enable = "#write_enable=YES" ] || [ $vuser_write_enable = "write_enable=NO" ]
			then
				sed -i "s/$vuser_write_enable/write_enable=YES/g" "/etc/vsftpd.conf"
				service vsftpd restart
				virtualusersftp
				elif [ $vuser_write_enable = "write_enable=YES" ]
				then
					sed -i "s/$vuser_write_enable/write_enable=NO/g" "/etc/vsftpd.conf"
					service vsftpd restart
					virtualusersftp
			fi
		;;
		4)
		ftpservermenu;;
		*)
		virtualusersftp;;
	esac
}

function anon_users
{
	#anonymous state Active | Inactive
	anonymous_yes=`cat /etc/vsftpd.conf | grep anonymous_enable=`
	if [ $anonymous_yes = "anonymous_enable=YES" ]
	then
		anonymous_state="`tput setaf 2`Allow`tput sgr 0`"
	else
		anonymous_state="`tput setaf 1`Deny`tput sgr 0`"
	fi

	#anonymous allow/deny UPLOAD FILES
	anonymous_upload_yes=`cat /etc/vsftpd.conf | grep anon_upload_enable=`
	if [ $anonymous_upload_yes = "anon_upload_enable=YES" ]
	then
		upload_anon_state="`tput setaf 2`Allow`tput sgr 0`"
	else
		upload_anon_state="`tput setaf 1`Deny`tput sgr 0`"
	fi

	#anonymous allow/deny CREATE MKDIR
	mkdirenable=`cat /etc/vsftpd.conf | grep anon_mkdir_write_enable=`
	if [ $mkdirenable = "#anon_mkdir_write_enable=YES" ] || [ $mkdirenable = "anon_mkdir_write_enable=NO" ]
	then
	create_anon_state="`tput setaf 1`Deny`tput sgr 0`"
	else
	create_anon_state="`tput setaf 2`Allow`tput sgr 0`"
	fi

	#anonymous delete files and folders
	anon_delete=`cat /etc/vsftpd.conf | grep "anon_other_write_enable="`
		if [ "$anon_delete" = "anon_other_write_enable=YES" ]
		then
			delete_files_anon_state="`tput setaf 2`Allow`tput sgr 0`"
		else
			delete_files_anon_state="`tput setaf 1`Deny`tput sgr 0`"
		fi

	#anonymous directory path
	dir_anon_path=`tput setaf 2``getent passwd | grep "ftp:" | cut -d: -f6``tput sgr 0`

	#anonymous umask number
	actual_umask=`tput setaf 2``cat /etc/vsftpd.conf | grep "local_umask="``tput sgr 0`

	clear
	echo "----Anonymous Users Configuration----"
	echo ""
	echo "1 - [ $anonymous_state ] Allow/Deny anonymous users"
	echo "2 - [ $upload_anon_state ] Allow/Deny upload files"
	echo "3 - [ $create_anon_state ] Allow/Deny create folders"
	echo "4 - [ $delete_files_anon_state ] Allow/Deny delete files and folders"
	echo "5 - FTP Directory [ $dir_anon_path ]"
	echo "6 - Change Umask [ $actual_umask ]"
	echo "7 - Back"
	read anon_users_option
	case $anon_users_option in
		1)
			anonymous_yes=`cat /etc/vsftpd.conf | grep anonymous_enable=`
			if [ $anonymous_yes = "anonymous_enable=YES" ]
			then
				sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' "/etc/vsftpd.conf"
				service vsftpd restart
				anon_users
			else
				sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' "/etc/vsftpd.conf"
				service vsftpd restart
				anon_users
			fi;;
			#ALLOW UPLOAD FILES AND WRITE ENABLE
		2)
			writeenable=`cat /etc/vsftpd.conf | grep write_enable | head -1`
			if [ $writeenable = "#write_enable=YES" ]
			then
				sed -i 's/#write_enable=YES/write_enable=YES/g' "/etc/vsftpd.conf"
				elif [ $writeenable = "write_enable=YES" ]
				then
					sed -i 's/write_enable=YES/write_enable=NO/g' "/etc/vsftpd.conf"
					elif [ $writeenable = "write_enable=NO" ]
					then
						sed -i 's/write_enable=NO/write_enable=YES/g' "/etc/vsftpd.conf"
			fi
			writeenable=`cat /etc/vsftpd.conf | grep write_enable | head -1`
			if [ $writeenable = "write_enable=YES" ]
			then
				anonup="`cat /etc/vsftpd.conf | grep anon_upload_enable`"
				sed -i "s/$anonup/anon_upload_enable=YES/g" "/etc/vsftpd.conf"
				service vsftpd restart
				anon_users
			fi
			anonup="`cat /etc/vsftpd.conf | grep anon_upload_enable`"
			if [ $writeenable = "write_enable=NO" ] && [ "$anonup" = "anon_upload_enable=YES" ]
			then
				sed -i 's/anon_upload_enable=YES/anon_upload_enable=NO/g' "/etc/vsftpd.conf"
				service vsftpd restart
				anon_users
			fi
			if [ $writeenable = "write_enable=YES" ] && [ "$anonup" = "anon_upload_enable=NO" ]
			then
				sed -i 's/anon_upload_enable=NO/anon_upload_enable=YES/g' "/etc/vsftpd.conf"
				service vsftpd restart
				anon_users
			fi
		;;
		#ALLOW CREATE FOLDERS 
		3)
		mkdirenable=`cat /etc/vsftpd.conf | grep anon_mkdir_write_enable=`
		if [ "$mkdirenable" = "#anon_mkdir_write_enable=YES" ] || [ "$mkdirenable" = "anon_mkdir_write_enable=NO" ]
		then
			sed -i "s/$mkdirenable/anon_mkdir_write_enable=YES/g" "/etc/vsftpd.conf"
			service vsftpd restart
			anon_users
			elif [ "$mkdirenable" = "anon_mkdir_write_enable=YES" ]
			then
				sed -i "s/$mkdirenable/anon_mkdir_write_enable=NO/g" "/etc/vsftpd.conf"
				service vsftpd restart
				anon_users
		fi
		;;
		4)
		anon_delete=`cat /etc/vsftpd.conf | grep "anon_other_write_enable="`
		if [ "$anon_delete" = "anon_other_write_enable=YES" ]
		then
			sed -i "s/$anon_delete/anon_other_write_enable=NO/g" "/etc/vsftpd.conf"
			service vsftpd restart
			anon_users
		else
			sed -i "s/$anon_delete/anon_other_write_enable=YES/g" "/etc/vsftpd.conf"
			service vsftpd restart
			anon_users
		fi
		;;
		5)
		echo "Write your full directory path (Ex: /srv/files/ftp):"
		read -p">  " anon_path
		sudo mkdir -p $anon_path
		sudo usermod -d $anon_path ftp
		#anon_root on vsftpd.conf
		anon_path_words=`echo "$anon_path" | tr "/" " " | wc -w`
		anon_path2=`echo "$anon_path" | cut -d/ -f1-$anon_path_words`
		echo "anon_root=$anon_path2" >> /etc/vsftpd.conf
		chmod 755 $anon_path2
		chmod 777 $anon_path
		service vsftpd restart
		anon_users
		;;
		6)
		umaskk=`cat /etc/vsftpd.conf | grep "local_umask="`
		echo "Write the Umask that you want apply: (Ex: 077)"
		read -p"Nº >  " umasknumber
		sed -i "s/$umaskk/local_umask=$umasknumber/g" "/etc/vsftpd.conf"
		service vsftpd restart
		anon_users
		;;
		7)
		ftpservermenu;;
		*)
		anon_users;;
	esac
}

function lockrepair
{
	clear
	sudo rm /var/lib/apt/lists/lock
	echo "[  `tput setaf 2`OK`tput sgr 0`  ] Deleting /var/lib/apt/lists/lock..."
	sleep 0.2
	sudo rm /var/cache/apt/archives/lock
	echo "[  `tput setaf 2`OK`tput sgr 0`  ]  Deleting /var/cache/apt/archives/lock..."
	sleep 0.2
	sudo rm /var/lib/dpkg/lock
	echo "[  `tput setaf 2`OK`tput sgr 0`  ]  Deleting /var/lib/dpkg/lock..."
	sleep 0.2
	echo ""
	dpkg --configure -a
	echo "Lock repaired correctly"
	sleep 0.4
	menu
}

function sambamenu
{
	#SAMBA Server state
	sambastate=`service smbd status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$sambastate" != "active" ] && [ "$sambastate" != "failed" ]
	then
	sambastate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$sambastate" = "active" ]
		then
		Vsambastate="`tput setaf 2`$sambastate`tput sgr 0`"
		sambastate=$Vsambastate
		elif [ "$sambastate" = "failed" ]
		then
		Fsambastate="`tput setaf 1`$sambastate`tput sgr 0`"
		sambastate=$Fsambastate
	fi

	clear
	echo "----SAMBA CONFIGURATION----  SAMBA State: $sambastate"
	echo ""
	echo "1- Install Samba"
	echo "2- Create new Shared Folder"
	echo "3- Delete Shared Folder"
	echo "4- Show Shared Folders"
	echo "5- Back"
	read optionsambamenu
	case $optionsambamenu in
		1)
		sudo apt install -y samba
		mkdir -p /srv/samba
		namewho=`who | cut -d" " -f1`
		sed -i "s/workgroup = WORKGROUP/workgroup = $namewho/g" "/etc/samba/smb.conf"
		echo "Samba installed correctly"
		sleep 0.5
		sambamenu;;
		2)
		newsharedfolder;;
		3)
		deletesharedfolder;;
		4)
		showsharedfolders;;
		5)
		menu;;
		*)
		sambamenu;;
	esac
}

function showsharedfolders		#Show all the Shared Folder
{
	clear
	echo "THESE ARE YOUR SHARED FOLDERS"
	echo ""
	numberlistfolders=`ls /srv/samba/ | wc -w`
	for x in `seq $numberlistfolders`
	do
		echo "$x- `ls /srv/samba | tr -s " " "\n" | head -$x | tail -1` "
	done
	echo ""
	echo "Press enter to back..."
	read kakita
	sambamenu
}

function deletesharedfolder		#Delete a Shared Folder
{
	echo "DELETE SHARED FOLDER"
	echo ""
	numberlistfolders=`ls /srv/samba/ | wc -w` #List the number of folders
	for x in `seq $numberlistfolders`
	do
		echo "$x- `ls /srv/samba | tr -s " " "\n" | head -$x | tail -1` " #List the folders' name
	done
	echo ""
	read -p"Choose the shared folder: > " numdelete #Select the number of folder that you want delete
	deletefolder=`ls /srv/samba | tr -s " " "\n" | head -$numdelete | tail -1` #name of the selected folder
	echo "You are going to delete permanently the folder `tput setaf 5`\"$deletefolder\"`tput sgr 0`. Are you sure? S/n"
	read -p"> " sinodelete
	case $sinodelete in
		S|s)
		rm -r /srv/samba/$deletefolder
		linesmb=`cat /etc/samba/smb.conf | grep -n "\[ruben\]" | cut -d: -f1`
		finishlinesmb=0
		let finishlinesmb=linesmb+6
		sed -i "$linesmb,$finishlinesmb d" /etc/samba/smb.conf
		echo "Your shared folder have been deleted. Press enter to continue..."
		read kakota
		sambamenu;;
		N|n)
		sambamenu;;
	esac
}
	
function newsharedfolder		#create a Shared Folder
{
	echo "Write the name of the shared folder:"
	read -p">" foldername
#create the folder on samba's path
	mkdir -p /srv/samba/$foldername

#add the shared folder to samba configuration
	cat << EOC >> /etc/samba/smb.conf

[$foldername]
  comment = Ubuntu File Server $foldername
  path = /srv/samba/$foldername
  browsable = yes
  guest ok = yes
  read only = yes
  create mask = 0755
EOC
#give permissions and restart the service
chmod 755 /srv/samba/$foldername
sudo chown nobody:nogroup /srv/samba/$foldername/
sudo systemctl restart smbd.service nmbd.service
read -p"Shared folder created correctly. Press enter to continue..."
sambamenu
}
function webminmenu
{
	#Install new repositories
	echo "adding adding new repositories: universe, multiverse, webmin..."
	sleep 0.5
	sudo apt-add-repository universe
	sudo apt-add-repository multiverse
	echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
	wget http://www.webmin.com/jcameron-key.asc
	sudo apt-key add jcameron-key.asc
	sudo apt update
	sudo apt install webmin 
}

function ldapmenu
{
	clear
    echo "LDAP MENU CONFIGURATION"
    echo ""
    echo "1- Installation and configuration"
    echo "2- Add users"
	echo "3- Install phpldapadmin"
	echo "4- Create Backup files"
	echo "5- Import Backup files"
	echo "6- Send Backup files"
	echo "7- Replication"
	echp "8- Samba installation for LDAP"
    echo "9- Back"
    read optionldapmenu
    case $optionldapmenu in
        1)
        install_ldap;;
        2)
		selectfile;;
		3)
		installphpldapadmin;;
		4)
		backupldap;;
		5)
		importbackup;;
		6)
		sendfiles;;
		7)
		replicationmenu;;
		8)
		sambaldap;;
        9)
        menu;;
        *)
        ldapmenu;;
    esac
}

function sambaldap
{
	sudo apt install -y samba smbldap-tools
	zcat /usr/share/doc/samba/examples/LDAP/samba.ldif.gz | sudo ldapadd -Q -Y EXTERNAL -H ldapi:///
	cat << EOC > samba_indices.ldif
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcDbIndex
olcDbIndex: objectClass eq
olcDbIndex: uidNumber,gidNumber eq
olcDbIndex: loginShell eq
olcDbIndex: uid,cn eq,sub
olcDbIndex: memberUid eq,sub
olcDbIndex: member,uniqueMember eq
olcDbIndex: sambaSID eq
olcDbIndex: sambaPrimaryGroupSID eq
olcDbIndex: sambaGroupType eq
olcDbIndex: sambaSIDList eq
olcDbIndex: sambaDomainName eq
olcDbIndex: default sub,eq
EOC
	sudo ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f samba_indices.ldif
	global_line=`cat /etc/samba/smb.conf | grep -n "\[global\]" | cut -d: -f1`
	next_global_line=0
	echo "Select your workgroup and netbios name:"
	read -p"> " namesambaldap
	let next_global_line=global_line+1
	sed -i "$next_global_line\netbios name =  $namesambaldap"
	sed -i "s/workgroup = WORKGROUP/workgroup = $namesambaldap/g" "/etc/samba/smb.conf"

	
}

function sendfiles
{
	read -p"Write remote username: " userscp
	read -p"Wirte remote IP: " ipscp
	scp -r backup_files $userscp@$ipscp:/home/$userscp
	sleep 4
	ldapmenu
}
function replicationmenu
{
	clear
	echo "LDAP REPLICATION MENU"
	echo ""
	echo "1- Configure LDAP Provider (Master)"
	echo "2- Configure LDAP Consumer (Secondary)"
	echo "3- Back"
	read optionreplication
	case $optionreplication in
		1)
		replication_provider;;
		2)
		replication_consumer;;
		3)
		menu;;
	esac
}

function replication_provider
{
	domainldap=`cat /etc/domainldap`
cat << EOC > provider_sync.ldif

dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: entryCSN eq
-
add: olcDbIndex
olcDbIndex: entryUUID eq

dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: syncprov
-
add: olcModuleLoad
olcModuleLoad: accesslog

dn: olcDatabase={2}mdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: {2}mdb
olcDbDirectory: /var/lib/ldap/accesslog
olcSuffix: cn=accesslog
olcRootDN: cn=admin,$domainldap
olcDbIndex: default eq
olcDbIndex: entryCSN,objectClass,reqEnd,reqResult,reqStart

dn: olcOverlay=syncprov,olcDatabase={2}mdb,cn=config
changetype: add
objectClass: olcOverlayConfig
objectClass: olcSyncProvConfig
olcOverlay: syncprov
olcSpNoPresent: TRUE
olcSpReloadHint: TRUE

dn: olcOverlay=syncprov,olcDatabase={1}mdb,cn=config
changetype: add
objectClass: olcOverlayConfig
objectClass: olcSyncProvConfig
olcOverlay: syncprov
olcSpNoPresent: TRUE

dn: olcOverlay=accesslog,olcDatabase={1}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcAccessLogConfig
olcOverlay: accesslog
olcAccessLogDB: cn=accesslog
olcAccessLogOps: writes
olcAccessLogSuccess: TRUE

olcAccessLogPurge: 07+00:00 01+00:00
EOC

	sudo -u openldap mkdir /var/lib/ldap/accesslog
	sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f provider_sync.ldif
	
	echo "Provider configurated correctly"
	sleep 2
	ldapmenu
}

function replication_consumer
{
rm consumer_sync.ldif
clear
	echo "IP of LDAP Master (provider):"
	read -p"> " ipconsumer
	echo "Write the domain name: "
	read -p"> " domainconsumer
	echo 'Write the admin user: (Should be "admin")'
	read -p"> " adminuser
	echo 'Write the admin password: '
	read -p"> " adminpassword
	domain1=`echo "$domainconsumer" | cut -d. -f1`
	domain2=`echo "$domainconsumer" | cut -d. -f2`
	#replication configuration
cat << EOC > consumer_sync.ldif
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: syncprov

dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcDbIndex
olcDbIndex: entryUUID eq
-
add: olcSyncRepl
olcSyncRepl: rid=1 provider=ldap://$ipconsumer bindmethod=simple
  binddn="cn=admin,dc=$domain1,dc=$domain2"
   credentials=$adminpassword searchbase="dc=$domain1,dc=$domain2" logbase="cn=accesslog"
   logfilter="(&(objectClass=auditWriteObject)(reqResult=0))" schemachecking=on
   type=refreshAndPersist retry="60 +" syncdata=accesslog
-
add: olcUpdateRef
olcUpdateRef: ldap://$ipconsumer
EOC

sudo ldapadd -Q -Y EXTERNAL -H ldapi:/// -f consumer_sync.ldif


	echo "Consumer configurated correctly"
	sleep 1
	read cacaca
	ldapmenu
}

function backupldap
{
	mkdir backup_files
	slapcat -n 0 -l backup_files/config.ldif
	slapcat -n 1 -l backup_files/data.ldif
	echo "BACKUP FILES EXTRACTED CORRECTLY"
	sleep 1
	ldapmenu
}
function importbackup
{
	echo "THE FOLDER MUST BE IN THE SAME DIRECTORY"
	sleep 1.5
	sudo systemctl stop slapd.service
	rm -r /etc/ldap/slapd.d/*
	slapadd -n 0 -F /etc/ldap/slapd.d -l backup_files/config.ldif
	chown -R openldap:openldap /etc/ldap/slapd.d
	rm -r /var/lib/ldap/*
	slapadd -n 1 -F /etc/ldap/slapd.d -l backup_files/data.ldif
	chown -R openldap:openldap /var/lib/ldap
	sudo systemctl start slapd.service
	echo "BACKUP COMPLETED"
	sleep 1
	ldapmenu
}

#STARTS THE SCRIPT "ADD USERS" FOR LDAP
function selectfile
{
	clear
startdir="$HOME"
filext='txt'
menutitle="$filext File Selection Menu"

Filebrowser "$menutitle" "$startdir"

exitstatus=$?
if [ $exitstatus -eq 0 ]; then
    if [ "$selection" == "" ]; then
        echo "User Pressed Esc with No File Selection"
    else
        whiptail --title "File was selected" --msgbox " \

        File Selected information

        Filename : $filename
        Directory: $filepath

        \
        " 0 0 0
        fichero="$filepath/$filename"
    fi
else
    echo "User Pressed Cancel. with No File Selected."
	ldapmenu
fi
	domainldap=`cat /etc/domainldap`
	comprobarPeople
}

function Filebrowser()
{
# first parameter is Menu Title
# second parameter is optional dir path to starting folder
# otherwise current folder is selected

    if [ -z $2 ] ; then
        dir_list=$(ls -lhp  | awk -F ' ' ' { print $9 " " $5 } ')
    else
        cd "$2"
        dir_list=$(ls -lhp  | awk -F ' ' ' { print $9 " " $5 } ')
    fi

    curdir=$(pwd)
    if [ "$curdir" == "/" ] ; then  # Check if you are at root folder
        selection=$(whiptail --title "$1" \
                              --menu "PgUp/PgDn/Arrow Enter Selects File/Folder\nor Tab Key\n$curdir" 0 0 0 \
                              --cancel-button Cancel \
                              --ok-button Select $dir_list 3>&1 1>&2 2>&3)
    else   # Not Root Dir so show ../ BACK Selection in Menu
        selection=$(whiptail --title "$1" \
                              --menu "PgUp/PgDn/Arrow Enter Selects File/Folder\nor Tab Key\n$curdir" 0 0 0 \
                              --cancel-button Cancel \
                              --ok-button Select ../ BACK $dir_list 3>&1 1>&2 2>&3)
    fi

    RET=$?
    if [ $RET -eq 1 ]; then  # Check if User Selected Cancel
       return 1
    elif [ $RET -eq 0 ]; then
       if [[ -d "$selection" ]]; then  # Check if Directory Selected
          Filebrowser "$1" "$selection"
       elif [[ -f "$selection" ]]; then  # Check if File Selected
          if [[ $selection == *$filext ]]; then   # Check if selected File has .jpg extension
            if (whiptail --title "Confirm Selection" --yesno "DirPath : $curdir\nFileName: $selection" 0 0 \
                         --yes-button "Confirm" \
                         --no-button "Retry"); then
                filename="$selection"
                filepath="$curdir"    # Return full filepath  and filename as selection variables
            else
                Filebrowser "$1" "$curdir"
            fi
          else   # Not jpg so Inform User and restart
             whiptail --title "ERROR: File Must have .txt Extension" \
                      --msgbox "$selection\nYou Must Select a jpg Image File" 0 0
             Filebrowser "$1" "$curdir"
          fi
       else
          # Could not detect a file or folder so Try Again
          whiptail --title "ERROR: Selection Error" \
                   --msgbox "Error Changing to Path $selection" 0 0
          Filebrowser "$1" "$curdir"
       fi
    fi
}

function comprobarPeople
{
	lsldif=`ls | grep add_content.ldif`
	if [ "$lsldif" = "add_content.ldif" ]
	then
		rm add_content.ldif
	fi
    groupPeople="`ldapsearch -x -LLL -b $domainldap | grep -o "dn: ou=People"`"
    if [ "$groupPeople" = "dn: ou=People" ]
    then
        comprobarGroups
    else
        echo "" > add_content.ldif
        echo "dn: ou=People,$domainldap" > add_content.ldif
        echo "objectClass: organizationalUnit" >> add_content.ldif
        echo "ou: People" >>add_content.ldif
        echo "" >> add_content.ldif
        comprobarGroups
    fi
}

function comprobarGroups
{
    groupGroups="`ldapsearch -x -LLL -b $domainldap | grep -o "dn: ou=Groups"`"
    if [ "$groupGroups" = "dn: ou=Groups" ]
    then
        comprobarUsers
    else
        echo "" >> add_content.ldif
        echo "dn: ou=Groups,$domainldap" >> add_content.ldif
        echo "objectClass: organizationalUnit" >> add_content.ldif
        echo "ou: Groups" >> add_content.ldif
        echo "" >> add_content.ldif
        comprobarUsers
    fi
}

function comprobarUsers
{
    groupUsers="`ldapsearch -x -LLL -b $domainldap | grep -o "dn: cn=Usuaris"`"
    if [ "$groupUsers" = "dn: cn=Usuaris" ]
    then
        agregarusuarios
    else
        echo "" >> add_content.ldif
        echo "dn: cn=Usuaris,ou=Groups,$domainldap" >> add_content.ldif
        echo "objectClass: posixGroup" >> add_content.ldif
        echo "cn: Usuaris" >> add_content.ldif
        echo "gidNumber: 5000" >> add_content.ldif
        echo "" >> add_content.ldif
        agregarusuarios
    fi
}
function agregarusuarios
{
    maxu=`cat $fichero | cut -d: -f2 | tr "," "\n" | wc -l`
    uidNumber=`ldapsearch -x -LLL -b $domainldap | grep uidNumber: | cut -d: -f2 | tr -d " " | sort | tail -1`
    for x in `seq $maxu`
    do
        nombreusu=`cat $fichero | cut -d: -f2 | tr "," "\n" | head -$x | tail -1`
        nombreusulowercase=`cat $fichero | cut -d: -f2 | tr "," "\n" | head -$x | tail -1 | tr [A-Z] [a-z]`
        comprobarnombre="`ldapsearch -x -LLL -b $domainldap | grep -o "dn: uid=$nombreusulowercase" | grep -o $nombreusulowercase`"
        let uidNumber=uidNumber+1
            if [ "$nombreusulowercase" != "$comprobarnombre" ]
            then
                echo "" >> add_content.ldif
                echo "dn: uid=$nombreusulowercase,ou=People,$domainldap" >> add_content.ldif
                echo "objectclass: inetOrgPerson" >> add_content.ldif
                echo "objectclass: posixAccount" >> add_content.ldif
                echo "objectclass: shadowAccount" >> add_content.ldif
                echo "uid: $nombreusulowercase" >> add_content.ldif
				echo "sn: ldap" >> add_content.ldif
                echo "givenName: $nombreusu" >> add_content.ldif
                echo "cn: $nombreusu" >> add_content.ldif
                echo "displayName: $nombreusu" >> add_content.ldif
                echo "uidNumber: $uidNumber" >> add_content.ldif
                echo "gidNumber: 5000" >> add_content.ldif
                echo "userPassword: "$nombreusu"ldap" >> add_content.ldif
                echo "gecos: $nombreusu" >> add_content.ldif
                echo "loginShell: /bin/bash" >> add_content.ldif
                echo "homeDirectory: /home/$nombreusu" >> add_content.ldif
                echo "" >> add_content.ldif
            else
                nombreRepetido[$x]="$nombreusu"
            fi
    done
    agregarGrupos
}

function agregarGrupos
{
    maxg=`cat $fichero | wc -l`
    gidNumber=`ldapsearch -x -LLL -b $domainldap | grep gidNumber: | cut -d: -f2 | tr -d " " | sort | tail -1`
    for y in `seq $maxg`
    do
        nombregrupo=`cat $fichero | cut -d: -f1 | head -$y | tail -1`
        comprobarNomGrupo=`ldapsearch -x -LLL -b $domainldap | grep -o "dn: cn=$nombregrupo" | grep -o $nombregrupo`
        let gidNumber=gidNumber+1
            if [ "$nombregrupo" != "$comprobarNomGrupo" ]
            then
				echo "" >> add_content.ldif
                echo "dn: cn=$nombregrupo,ou=Groups,$domainldap" >> add_content.ldif
                echo "objectClass: posixGroup" >> add_content.ldif
				echo "objectClass: top" >> add_content.ldif
                echo "cn: $nombregrupo" >> add_content.ldif
				maxmembers=`cat $fichero | head -$y | tail -1 | cut -d: -f2 | tr "," " " | wc -w`
				for z in `seq $maxmembers`
				do
					namemember=`cat $fichero | head -$y | tail -1 | cut -d: -f2 | cut -d, -f$z`
					numline1=`cat add_content.ldif | grep -n "displayName: $namemember" | cut -d: -f1`
					numline2=0
					let numline2=numline1+1
					membruid=`cat add_content.ldif | head -$numline1 | tail -1 | tr -d " " | cut -d: -f2`
					echo "memberUid: $membruid" >> add_content.ldif
				done
                	echo "gidNumber: $gidNumber" >> add_content.ldif
					echo "" >> add_content.ldif
            else
                grupoRepetido[$y]="$nombregrupo"
            fi
    done
añadirldapadd
}

function añadirldapadd
{
    ldapadd -x -D cn=admin,$domainldap -W -f add_content.ldif
    repetidos
}

function repetidos
{
    totalgrupos=`echo ${grupoRepetido[@]} | wc -c`
    if [ "`echo $totalgrupos`" != "1" ]
    then
        echo ""
        echo ""
        echo "Estos grupos ya están añadidos: ${grupoRepetido[@]}"
    fi

    totalusers=`echo ${nombreRepetido[@]} | wc -c`
    if [ "`echo $totalusers`" != "1" ]
    then
        echo ""
        echo ""
        echo "Estos Usuarios ya están añadidos"
    fi
	read -p "Press enter to back.."
	ldapmenu
}
#FINISH ADD USERS LDAP
function install_ldap
{
	sudo apt-get -y install php php-cgi libapache2-mod-php php-common php-pear php-mbstring a2enconf php7.0-cgi
	clear
	echo "--------LDAP CONFIGURATION &--------"
	echo "    --------INSTALATION---------"
	echo ""
	echo "Select your admin password:"
	read -p">" adminpass1
	echo "Repeat your admin password:"
	read -p">" adminpass2
	if [ "$adminpass1" != "$adminpass2" ]
	then
		echo "Password do not match! Wirte them again.."
		sleep 0.8
		install_ldap
	fi
	echo "Write your domain:"
	read -p">" domainn
	echo "Enter your organization name:"
	read -p">" org_name
	echo "Applying..."
	sleep 1.3
	#slapd non-interactive
export DEBIAN_FRONTEND='non-interactive'
echo -e "slapd slapd/root_password password $adminpass2" |debconf-set-selections
echo -e "slapd slapd/root_password_again password $adminpass2" |debconf-set-selections

echo -e "slapd slapd/internal/adminpw password $adminpass2" |debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw password $adminpass2" |debconf-set-selections
echo -e "slapd slapd/password2 password $adminpass2" |debconf-set-selections
echo -e "slapd slapd/password1 password $adminpass2" |debconf-set-selections
echo -e "slapd slapd/domain string $domainn" |debconf-set-selections
echo -e "slapd shared/organization string $org_name" |debconf-set-selections
echo -e "slapd slapd/backend string MDB" |debconf-set-selections
echo -e "slapd slapd/purge_database boolean true" |debconf-set-selections
echo -e "slapd slapd/move_old_database boolean true" |debconf-set-selections
echo -e "slapd slapd/allow_ldap_v2 boolean false" |debconf-set-selections
echo -e "slapd slapd/no_configuration boolean false" |debconf-set-selections

apt-get install -y slapd ldap-utils
domain1=`echo $domainn | cut -d. -f1`
domain2=`echo $domainn | cut -d. -f2`
echo "dc=$domain1,dc=$domain2" >> domainldap
chown root:root domainldap
chmod 700 domainldap
mv domainldap /etc
echo "LDAP configurated correctly"
ldapmenu
}

function installphpldapadmin
{
	apt install -y apache2 php php7.2 php7.2-ldap php7.2-xml git
	sudo git clone https://github.com/breisig/phpLDAPadmin.git
	mv phpLDAPadmin phpldapadmin
	mv phpldapadmin /var/www/html
	cp /var/www/html/phpldapadmin/config/config.php.example /var/www/html/phpldapadmin/config/config.php
	service apache2 restart
	domainldap=`slapcat | grep dc | head -1 | cut -d" " -f2`
	staticip=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3 | cut -d/ -f1`
	sed -i "s/\/\/\ \$servers->setValue('server','host','127.0.0.1');/\$servers->setValue('server','host','$staticip');/g" "/var/www/html/phpldapadmin/config/config.php"
	sed -i "s/\/\/\ \$servers->setValue('server','base',array(''));/\$servers->setValue('server','base',array('$domainldap'));/g" "/var/www/html/phpldapadmin/config/config.php"
	sed -i "s/\/\/\ \$servers->setValue('server','tls',false);/\$servers->setValue('server','tls',false);/g" "/var/www/html/phpldapadmin/config/config.php"
	sed -i "s/\/\/\ \$servers->setValue('login','anon_bind',true);/\$servers->setValue('login','anon_bind',false);"
	service apache2 restart
	ldapmenu

}

function dnsmenu
{
	#repeat DNSstate for keep actualized the DNS menu. 
	dnsstate=`service bind9 status | grep Active: | tr -s " " | cut -d" " -f3`
	if [ "$dnsstate" != "active" ] && [ "$dnsstate" != "failed" ]
	then
	dnsstate=`tput setaf 1`"Not installed"`tput sgr 0`
	fi
	if [ "$dnsstate" = "active" ]
		then
		Vdnsstate="`tput setaf 2`$dnsstate`tput sgr 0`"
		dnsstate=$Vdnsstate
		elif [ "$dnsstate" = "failed" ]
		then
		Fdnsstate="`tput setaf 1`$dnsstate`tput sgr 0`"
		dnsstate=$Fdnsstate
	fi
	clear
	echo "DNS Configuration             DNS  state: $dnsstate"
	echo "------------------"
	echo "1- Install necessary packets"
	echo "2- Configuration Caching Nameserver"
	echo "3- Configuration Primary Master"
	echo "4- Configuration Seconday Master"
	echo "5- DNS Status"
	echo "6- Back"
	read optiondnsmenu

	case $optiondnsmenu in
		1)
		install_dns_packets;;
		2)
		caching_ns_dns;;
		3)
		primarydns;;
		5)
		dnsstatus;;
		6)
		menu;;
		*)
		dnsmenu;;			
	esac
}
#Show DNS/BIND9 status
function dnsstatus
{
	service bind9 status
	echo "Press enter to go back"
	read babababa
	dnsmenu
}

#Shiw Primary DNS menu
function primarydns
{
	clear
	echo "Primary DNS"
	echo "------------"
	echo "1- Forward Zone"
	echo "2- Reverse Zone"
	echo "3- Add registers"
	echo "4- Show registers"
	echo "5- Back"
	read optionprimarydns
	case $optionprimarydns in
	1) #FORWARD ZONE CONFIGURATION
	#search static ip
	ipstaticdns=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3 | cut -d/ -f1`
	#edit file: /etc/bind/named.conf.local
	clear
	echo "Write your domain name. (Ex: cocacola.com)"
	read -p">" domainname
	echo "" >> /etc/bind/named.conf.local
	echo "zone \"$domainname\" {" >> /etc/bind/named.conf.local
	echo "	type master;" >> /etc/bind/named.conf.local
	echo "		file \"/etc/bind/db.$domainname\";" >> /etc/bind/named.conf.local
	echo "};" >> /etc/bind/named.conf.local
	#create the file from db.local
	sudo cp /etc/bind/db.local /etc/bind/db.$domainname
	#edit created file
	nserial=`cat /etc/bind/db.$domainname | head -6 | tail -1 | grep -o [0-9]`
	let nserial=nserial+1
	echo ";" > /etc/bind/db.$domainname
	echo "; BIND data file for $domainname" >> /etc/bind/db.$domainname
	echo ";" >> /etc/bind/db.$domainname
	echo '$TTL 604800' >> /etc/bind/db.$domainname
	echo "@	IN	SOA	ns1.$domainname. root.$domainname. (" >> /etc/bind/db.$domainname
	echo "			$nserial		; Serial" >> /etc/bind/db.$domainname
	echo "			604800		; Refresh" >> /etc/bind/db.$domainname
	echo "			86400		; Retry" >> /etc/bind/db.$domainname
	echo "			2419200		; Expire" >> /etc/bind/db.$domainname
	echo "			604800 )	; Negative Cache TTL" >> /etc/bind/db.$domainname
	echo "" >> /etc/bind/db.$domainname
	echo ";" >> /etc/bind/db.$domainname
	echo "@			IN		NS		ns1.$domainname." >> /etc/bind/db.$domainname
	echo "ns1.$domainname.	IN		A		$ipstaticdns" >> /etc/bind/db.$domainname
	echo "$domainname.		IN		A		$ipstaticdns" >> /etc/bind/db.$domainname
	echo "www.$domainname.	IN		CNAME		ns1.$domainname." >> /etc/bind/db.$domainname
	clear
	service bind9 restart
	sed -i "s/option domain-name \"example.org\";/option domain-name \"$domainname\";/g" "/etc/dhcp/dhcpd.conf"
	echo "Forward zone configurated correctly!!"
	echo ""
	echo "Do you want to install Apache2 to verify that it works correctly from the client?(S/n)"
	read apachesino
	case $apachesino in
		S|s)
		#install apache2 for enter to default apache's page from another pc (client)
		sudo apt-get install apache2
		echo "Forward zone and Apache2 configurated correctly"
		sleep 1.5
		service isc-dhcp-server restart
		dnsmenu;;
		N|n)
		echo "Forward zone configurated correctly"
		sleep 1.5
		service isc-dhcp-server restart
		dnsmenu;;
	esac;;
	
	2)
		#REVERSE DNS CONFIGURATION
		#add the reverse zone into named.conf.local
		ipstaticmenudns=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3 | cut -d/ -f1`
		p1_ipstatica=`echo $ipstaticmenudns | cut -d. -f1`
		p2_ipstatica=`echo $ipstaticmenudns | cut -d. -f2`
		p3_ipstatica=`echo $ipstaticmenudns | cut -d. -f3`
		p321_ipstatica="$p3_ipstatica.$p2_ipstatica.$p1_ipstatica"
		check=`cat /etc/bind/named.conf.local | grep -o "zone \"$p321_ipstatica.in-addr.arpa\" {"`
		if [ "zone \"$p321_ipstatica.in-addr.arpa\" {" != "$check" ]
		then
			echo "" >> /etc/bind/named.conf.local
			echo "zone \"$p321_ipstatica.in-addr.arpa\" {"  >> /etc/bind/named.conf.local
			echo "	type master;" >> /etc/bind/named.conf.local
			echo "	file \"/etc/bind/db.$p1_ipstatica\";" >> /etc/bind/named.conf.local
			echo "};" >> /etc/bind/named.conf.local
			#copy default reverse file 
			sudo cp /etc/bind/db.127 /etc/bind/db.$p1_ipstatica
			#edit db file created
			domainname=`cat /etc/bind/named.conf.local | grep "zone " | head -1 | cut -d" " -f2 | tr -d "\""`
			echo ";" > /etc/bind/db.$p1_ipstatica
			echo "; BIND reverse data file for local loopback interface" >> /etc/bind/db.$p1_ipstatica
			echo ";" >> db.$p1_ipstatica
			echo '$TTL	604800' >> /etc/bind/db.$p1_ipstatica
			echo "@	IN	SOA	ns1.$domainname. root.$domainname. (" >> /etc/bind/db.$p1_ipstatica
			echo "			2		; Serial" >> /etc/bind/db.$p1_ipstatica
			echo "			604800		; Refresh " >> /etc/bind/db.$p1_ipstatica
			echo "			86400		; Retry" >> /etc/bind/db.$p1_ipstatica
			echo "			2419200		; Expire" >> /etc/bind/db.$p1_ipstatica
			echo "			604800 )	; Negative Cache TTL" >> /etc/bind/db.$p1_ipstatica
			echo ";" >> /etc/bind/db.$p1_ipstatica
			echo "@	IN	NS	ns1.$domainname." >> /etc/bind/db.$p1_ipstatica
			echo "1	IN	PTR	ns1.$domainname." >> /etc/bind/db.$p1_ipstatica
			sudo service bind9 restart
			clear 
			echo "Reverse DNS configurated correctly!"
			sleep 1.5
			dnsmenu
		else
		#if u have the reverse zone, u can delete it.
			echo "You've already add the reverse zone. Do you want delete it? S/n"
			read sinoreverse
			numlinea1=`cat /etc/bind/named.conf.local | grep -no "zone \"0.1.10.in-addr.arpa\" {" | cut -d: -f1`
			numlineafin=0
			let numlineafin=numlinea1+4
			case $sinoreverse in
			S|s)
				sed "$numlinea1,$numlineafind" /etc/bind/named.conf.local
				echo "Done"
				sleep 1
				sudo service bind9 restart
				dnsmenu;;
			N|n)
				dnsmenu;;
			esac
		fi
	;;
	3)
	#Add registers to forward zone
		clear
		domainname=`cat /etc/bind/named.conf.local | grep "zone " | head -1 | cut -d" " -f2 | tr -d "\""`
		cat /etc/bind/db.$domainname
		echo ""
		echo ""
		echo ""
		echo "What type of register do you want to add?"
		echo "1- CNAME"
		echo "2- A (IP Register)"
		read optionaddregisters
		#Select register's type
		case $optionaddregisters in
			1)
				clear
				cat /etc/bind/db.$domainname
				echo ""
				read -p"Name:" registername
				read -p"IP/Name:" registerIPname
				echo ""
				echo "The register will be like this: S/n?"
				echo "$registername	IN	CNAME	$registerIPname"
				read sinoregister
				case $sinoregister in
					S|s)
						echo "$registername			IN	CNAME	$registerIPname" >> /etc/bind/db.$domainname
						echo "Added!"
						sudo service bind9 restart
						sleep 1
						primarydns;;
					N|n)
						primarydns;;
				esac
			;;
			2)
				clear
				cat /etc/bind/db.$domainname
				echo ""
				read -p"Name:" registername
				read -p"IP:" registerIP
				echo ""
				echo "The register will be like this: S/n?"
				echo "$registername	IN	A	$registerIP"
				read sinoregister
				case $sinoregister in
					S|s)
						echo "$registername			IN	A	$registerIP" >> /etc/bind/db.$domainname
						echo "Added!"
						sudo service bind9 restart
						sleep 1
						primarydns;;
					N|n)
						primarydns;;
				esac;;
		esac
;;
	4) #Show Registers of forward zone and reverse dns
	domainname=`cat /etc/bind/named.conf.local | grep "zone " | head -1 | cut -d" " -f2 | tr -d "\""`
	ipstaticmenudns=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3 | cut -d/ -f1`
	p1_ipstatica=`echo $ipstaticmenudns | cut -d. -f1`
	echo "--------------- Forward Zone ---------------"
	echo ""
	echo "`cat /etc/bind/db.$domainname | tail -n+13`"
	echo ""
	echo "--------------- Reverse Zone ---------------"
	echo ""
	echo "`cat /etc/bind/db.$p1_ipstatica | tail -n+11`"
	echo ""
	echo "Press enter to go back..."
	read gobackk
	dnsmenu;;
	5)
	dnsmenu;;
	esac
}

function caching_ns_dns
{
	echo "Enter your preferred primary DNS.(Ex: 8.8.8.8)"
	read -p">" dns1
	echo ""
	echo "Do you want to add $dns1 for caching nameserver dns? S/n"
	read optioncachingns
	case $optioncachingns in
		S|s)
			clear
			#replace lines in /etc/bind/named.conf.options
				sed -i 's/\/\/ forwarders {/forwarders {/g' "/etc/bind/named.conf.options"
				sed -i "s/\/\/ 	0.0.0.0;/	$dns1;/g" "/etc/bind/named.conf.options"
				sed -i 's/\/\/ };/ };/g' "/etc/bind/named.conf.options"
				sed -i 's/dnssec-validation auto;/dnssec-validation no;/g' "/etc/bind/named.conf.options"
			service bind9 restart
			service isc-dhcp-server restart
			echo "Caching Name Server added successfully"
			sleep 1
			dnsmenu;;
		N|n)
			echo "Operation cancelled"
			sleep 1
			dnsmenu;;
		esac
}

function install_dns_packets
{
		ipstaticdns=`ip addr | grep "scope global" | grep -v dynamic | tr -s " " | cut -d" " -f3 | cut -d/ -f1`
		sudo apt-get install bind9 dnsutils
		clear
		echo "Dnsutils and Bind9 successfully installed!!"
		echo ""
		echo "Do you want to update your DHCP configuration to indicate your DNS?(S/n)"
		read sinoinstalldns
		case $sinoinstalldns in
			S|s)
			sed -i "s/option domain-name-servers ns1.example.org, ns2.example.org;/option domain-name-servers $ipstaticdns;/g" "/etc/dhcp/dhcpd.conf"
			service isc-dhcp-server restart
			echo "Configuration Updated"
			sleep 1.5
			dnsmenu
			;;
			N|n)
			clear
			echo "Dnsutils and Bind9 successfully installed!!"
			sleep 2
			dnsmenu;;
		esac
}

function comprobardhcp
{
    echo "Are network cards pre-installed? S/n"
    read optionnics
    case $optionnics in
        S|s)
            clear
            #Comprobar que el servidor dhcp esté instalado
            comprobardhcpserver=`dpkg --get-selections | grep -o isc-dhcp-server`
            if [ "$comprobardhcpserver" = "isc-dhcp-server" ]
                then
                clear
                crearserdhcp
                else
                sudo apt-get install -y isc-dhcp-server
                crearserdhcp
            fi;;
        N|n)
            script;;
            esac
}

function script
{
    clear
	#Comprobar que hay dos tarjetas de red instaladas 
	numnic=`lspci | grep Ethernet | wc -l`
	if [ $numnic -lt 2 ]
	then
		echo "You only have 1 network card installed. Please insert another network card and restart the server ..."
		exit
	fi
	nic1=`ifconfig | head -1 | cut -d: -f1`
	nic2=`ifconfig | head -10 | tail -1 | cut -d: -f1`
	ipdhcp=`ifconfig | head -2 | tail -1 | tr -s " " | cut -d" " -f3`
	ipdynamicmenu=`ip addr | grep "scope global dynamic" | tr -s " " | cut -d" " -f3`
    #elegir NIC que obtiene IP desde un servidor dhcp externo
	echo "What network card gets IP by DHCP?"
	echo "1- $nic1`tput setaf 2` - $ipdynamicmenu`tput sgr 0`"
	echo "2- $nic2"
	read -p "Nº:" nicdhcp
	if [ "$nicdhcp" = "1" ]
		then
		nicdhcp=$nic1
		nicstatica=$nic2
		else
		nicdhcp=$nic2
		nicstatica=$nic1
	fi
	echo "Escribe direción IP y Máscara de la segunda tarjeta de red:  Ej: 192.168.1.1/24 .. 10.0.0.1/24"
	read -p ">" ipstatica
	clear
	echo "La configuración es correcta? S/n"
	echo "network:"
	echo "    ethernets:"
	echo "        `tput setaf 5`$nicdhcp`tput sgr 0`:"
	echo "             addresses: []"
	echo "             dhcp4: true"
	echo "        `tput setaf 5`$nicstatica`tput sgr 0`:"
	echo "             addresses:"
	echo "              - `tput setaf 5`$ipstatica`tput sgr 0`"
	echo "    version: 2"
	read sino
    #sustituir documento netplan
	case $sino in
		S|s)
            var=`ls /etc/netplan/* | cut -d"/" -f4`
			echo "network:" > /etc/netplan/$var
			echo "    ethernets:" >> /etc/netplan/$var
			echo "        $nicdhcp:" >> /etc/netplan/$var
			echo "             addresses: []" >> /etc/netplan/$var
			echo "             dhcp4: true" >> /etc/netplan/$var
			echo "        $nicstatica:" >> /etc/netplan/$var
			echo "             addresses:" >> /etc/netplan/$var
			echo "              - $ipstatica" >> /etc/netplan/$var
			echo "    version: 2" >> /etc/netplan/$var
		echo "Espere...."
        #aplicar cambios netplan
		sudo netplan apply
		clear
        echo "Configurado correctamente"
        sleep 1
		menu
		;;
		N|n)
			clear
            echo "Operación cancelada"
            sleep 1
			menu
		;;
	esac
}
function ipforwtables
{
	#activar IP Forward
	echo "1" > /proc/sys/net/ipv4/ip_forward

	#Añadir iptables
	sudo iptables -t nat -A POSTROUTING -s $ipstatica -o $nicdhcp -j MASQUERADE

	#Crear script de inicio
	echo '#!/bin/bash' > scriptinicio.sh
	echo 'ipstatica=`ip addr | grep "global e" | tr -s " " | cut -d" " -f3`' >> scriptinicio.sh
	echo 'nicdhcp=`ip addr | grep dynamic | tr -s " " | cut -d" " -f9`' >> scriptinicio.sh
	echo 'ipdhcp=`ip addr | grep dynamic | tr -s " " | cut -d" " -f3 | cut -d"/" -f1`' >> scriptinicio.sh
	echo "sudo service isc-dhcp-server start" >> scriptinicio.sh
	echo 'sudo echo "1" > /proc/sys/net/ipv4/ip_forward' >> scriptinicio.sh
	echo 'sudo iptables -t nat -A POSTROUTING -s $ipstatica -o $nicdhcp -j MASQUERADE' >> scriptinicio.sh
    #Le damos permisos al script creado
	sudo chmod 777 scriptinicio.sh
    #Lo movemos a init.d
	sudo mv scriptinicio.sh /etc/init.d/scriptinicio.sh
    #Creamos un enlace con la carpeta de inicio rc3.d
	sudo ln -s /etc/init.d/scriptinicio.sh /etc/rc3.d/S98scriptinicio.sh
	clear
	echo "Se ha configurado correctamente!"
	menu
}

function crearserdhcp
{
	clear
	    nicstatica1=`ip addr show | grep "global e" | tr -s " " | cut -d" " -f8`
	    ipgateway=`ifconfig | head -11 | tail -1 | tr -s " " | cut -d" " -f3`
	    nicinter4=`ifconfig | head -11 | tail -1 | tr -s " " | cut -d" " -f3 | cut -d"." -f1-3`
	    nicinter41="$nicinter4.0"
    	nicinter4broad="$nicinter4.255"
	    netmask1="`ifconfig | head -11 | tail -1 | tr -s " " | cut -d" " -f5`"
	#elejimos la tarjeta de red que se encargará de repartir IPs
		echo "INTERFACES=\"$nicstatica1\"" > /etc/default/isc-dhcp-server
		clear
	#cumplimentamos la configuración del archivo principal
		echo "Selecciona el rango de IPs que se usarán:"
		read -p "(Ej-100) Mínimo: " rango1
		read -p "(Ej-200) Máximo: " rango2
		echo ""
		echo "Escribe los DNS. (Ej. 127.13.15.44, 165.45.32.55"
		read -p ">" dnss
		echo 'option domain-name "example.org";' > /etc/dhcp/dhcpd.conf
		echo 'option domain-name-servers ns1.example.org, ns2.example.org;' >> /etc/dhcp/dhcpd.conf
		echo 'default-lease-time 600;' >> /etc/dhcp/dhcpd.conf
		echo 'max-lease-time 7200;' >> /etc/dhcp/dhcpd.conf
		echo 'ddns-update-style none;' >> /etc/dhcp/dhcpd.conf
		echo "subnet $nicinter41 netmask $netmask1 {" >> /etc/dhcp/dhcpd.conf
		echo "  range $nicinter4.$rango1 $nicinter4.$rango2;" >> /etc/dhcp/dhcpd.conf
		echo "  option routers $ipgateway;" >> /etc/dhcp/dhcpd.conf
		echo "  option broadcast-address $nicinter4broad;" >> /etc/dhcp/dhcpd.conf
		echo "}" >> /etc/dhcp/dhcpd.conf
    #reiniciamos servicio dhcp
		service isc-dhcp-server restart
        ipforwtables
}
menu
