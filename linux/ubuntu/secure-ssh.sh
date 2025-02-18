#secure-ssh.sh
#author inf
#creates a new ssh user using $username parameter

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
				exit 1
			else
				echo "invalid response"
			fi
		done
		
		echo "begining setup for '$username'"
		
		#adding user
		echo "adding user (1/3)"
		sudo useradd -m -d /home/"$username" -s /bin/bash
		sudo mkdir /home/"$username"/.ssh
		
		#getting pub key
		echo "getting public key (2/3)"
		curl -O https://raw.githubusercontent.com/LeoB1um/SYS-265/refs/heads/main/linux/public-keys/sys265.pub
		
		#using pub key to make the user function.
		echo "configuring user directories (3/3)"
		sudo cp sys265.pub /home/"$username"/.ssh/authorized_keys
		sudo chmod 700 /home/"$username"/.ssh
		sudo chmod 600 /.home/"$username"/.ssh/authorized_keys
		sudo chown -R "$username:$username" /home/"$username"/

		
		
		echo "finished! You can now log into '$username' on web01-leo"
	fi
done


	
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in

#now if I was actually making this for real then there would be a script but I dont have a repo for keys setup

