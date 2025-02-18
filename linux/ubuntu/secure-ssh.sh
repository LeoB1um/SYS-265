#secure-ssh.sh
#author inf
#creates a new ssh user using $username parameter
logger "Starting username add script"


echo "---------------------------------------------------------------------------------------------------------------------"
echo "this script requires curl. please ensure it is installed on your system by running 'curl --version' before continuing"
echo "---------------------------------------------------------------------------------------------------------------------"
echo " "

while true; do 
	#prompting username
	read -p "Select a username: " username
	echo " "
	#checks if the user exsists 
	if grep -q "^$username:" /etc/passwd; then
		echo "'$username' exists, try again\n"
		exit 1
	else

		echo "beginning setup for '$username'"

		#adding user
		echo "adding user (1/3)"
		sudo useradd -m -d /home/"$username"/ -s /bin/bash "$username"
		sudo mkdir /home/"$username"/.ssh/


		#getting pub key
		echo "getting public key (2/3)"
		curl -O https://raw.githubusercontent.com/LeoB1um/SYS-265/refs/heads/main/linux/public-keys/sys265.pub
		sleep 2

		#in case the file doesn't download
		if [ ! -f sys265.pub ]; then
			echo "Error: sys265.pub not found"
			echo "Removing user: '$username'..."
			sudo userdel -r "$username"
			logger "username script could not find sys265.pub. stopping"
			exit 1

		fi

		#using pub key to make the user function.
		echo "configuring user directories (3/3)"
		sudo cp sys265.pub /home/"$username"/.ssh/authorized_keys
		sudo chmod 700 /home/"$username"/.ssh/
		sudo chmod 600 /home/"$username"/.ssh/authorized_keys
		sudo chown -R "$username:$username" /home/"$username"/



		echo "finished! You can now log into '$username' on web01-leo"


		logger "Username add script finished successfully"
		logger "Added user '$username'"
		exit 1
	fi
done

