#!/bin/bash

i=0
#shows initially logged on users
init_users () {
   echo `date` ") initial users logged in"

	for x in `users`
	do
		echo "> $x logged in to `hostname`"
		i=$((i+1))		#increment users per login
	done;
   echo `date` ") # of users: $i"
}

#pings every 10 seconds to check on users
pinger () {
	while true
		do	
			names1=`users`
			temp1=("${names1[@]}")	#copy names1 to temp
			sleep 10
			
			names2=`users`
			temp2=("${names2[@]}")
			
			a1=${temp1[@]};a2=${temp2[@]}

			#finds the differences between two string arrays
			diff(){
   				 a1="$1"
   				 a2="$2"
   				 awk -va1="$a1" -va2="$a2" '
    				 BEGIN{
      					 m= split(a1, A1," ")
       					n= split(a2, t," ")
      					 for(i=1;i<=n;i++) { A2[t[i]] }
      						 for (i=1;i<=m;i++){
           					 if( ! (A1[i] in A2)  ){
                				printf A1[i]" "
           					 }
       					 }
    					}'
					}



			#anyusers gained
			gained=( $(diff "$a2" "$a1") )
			#any users lost 
			lost=( $(diff "$a1" "$a2") )
			
			#if statements to process addition or subtraction of user
			if ((${#gained[@]})); then
  				for a in "${gained[@]}"
					do
						echo "> $a logged in to `hostname`"
						i=$((i+1))
					done
			fi
			
			if ((${#lost[@]})); then
 				 for b in "${lost[@]}"
					do
						echo "> $b logged out of `hostname`"
						i=$((i-1))
					done
			fi
			echo `date` ") # of users: $i"

			
			#clear gained and lost
			gained=()
			lost=()
		done
}

#^C
signal()
{
echo " (SIGINT) ignored. enter ^C 1 more time to terminate program."
trap - INT
}
trap 'signal' INT
#trap '' INT
init_users
pinger
