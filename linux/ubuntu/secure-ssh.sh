#secure-ssh.sh
#author inf
#creates a new ssh user using $username parameter
logger "Starting username add script"

while true; do 
	#prompting username
	read -p "Select a username:" username
	
	#checks if the user exsists 
	if id "$username" &> /dev/null; then
		echo "'$username' exists, try again"
	else 
		
		#making sure you have the correct username and you didn't make a typo
	
		while true; do
		echo "is '$username' the correct username or did you make a typo (y/n): " ans
			if [[ "$ans" =~ ^(y|Y|yes|YES)$ ]]; then
				echo "Confirmed"
				break

			elif [[ "$ans" =~ ^(n|N|no|NO)$ ]]; then
				echo "Stopping..."
				logger "user add program, user had the wrong username. Stopping"
				exit 1
			else
				echo "invalid response"
			fi
		done
		
		echo "beginning setup for '$username'"
		
		#adding user
		echo "adding user (1/3)"
		sudo useradd -m -d /home/"$username" -s /bin/bash
		sudo mkdir /home/"$username"/.ssh
		

		#making sure curl is installed
		if ! command -v curl &>/dev/null; then 
			echo "curl not installed. Please install it and run again." 
			logger "Username add script: curl not installed. Stopping"
			exit 1
		fi
		
		#getting pub key
		echo "getting public key (2/3)" curl -O 
		https://raw.githubusercontent.com/LeoB1um/SYS-265/refs/heads/main/linux/public-keys/sys265.pub
		
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
		sudo chmod 700 /home/"$username"/.ssh
		sudo chmod 600 /home/"$username"/.ssh/authorized_keys
		sudo chown -R "$username:$username" /home/"$username"/

		
		
		echo "finished! You can now log into '$username' on web01-leo"
		

		logger "Username add script finished successfully"
		logger "Added user '$username'"
	fi
done
