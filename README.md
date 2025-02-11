# Introducing the project
This was a project that I did that introduced me to the fundamentals of using docker. 

In this project I created and hosted a docker image of a program called `chibisafe`.

Chibisafe is essentially an open source alternative for programs like dropbox and google drive that you can host on your server.

# Changes
My config combo that I have in this branch is a set of docker files that are designed to work on a closed LAN system I had in Vcenter. 

I didn't change that much but I did change some. 

The first change is that I just changed the directory where the `uploads`, `database`, and `log` directorys were stored on the host machine. This was just personal prefrence and doesn't have an impact on performance.
I also did the same for the directory locations that the caddy server depended on.

The 2nd change I made was to the `caddyfile`. Origianlly it came with a variable that was supposed to communicate with the .yml file. However I couldn't get this to work so I hard coded in my hostname which let me connect via hostname. 

#troubleshooting
I spent a good amount of hours trying to figure out why my connection would not resolve my hostname to an IP. I am fairly sure that DNS was the problem, just not with my Windows AD server. It had to do with how `caddy` interpreted the hostname how it was getting its information. 

The first thing I tried was to get the caddy server to communicate with my DNS server. I tried to do this a couple of ways. Firstly I had seen an option to put in a DNS server into the .yml file under the caddy config file but this didn't seem to do anything that was useful to me. The 2nd thing I tried was to create a reverse lookup zone in side the `caddyfile` but this ended up bricking both the functioning connection I had, which was just to an IP address, and not fixing the issue with not being able to connect to the hostname of my machine.
THe thing that finally fixed it was me hard coding in to the config file what I wanted my caddy server to point towards, which in this case was `docker01-leo`. Once I put that in the server stopped redirecting to the IP and only allowed connections in from the hostname. 

One last thing that I will mention is to make sure that you are using the correct config file. I started this project scratching my head when I found a .yml that didn't work in my case. I think it may have worked in the past for older versions of the program, or I was doing something wrong to run it, but I couldn't get it to work and lost a ton of time it.
