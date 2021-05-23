set clock 0

set cyclelenght 100

set nextBroaadcast 50

set metadata 0

set sameCount 0

set refractoryPeriod 60

set Threshhold 2

set EXTERN_MEATADATA 0

set EXTERN_CLOCK 0

set OVEREHEARD 0

set ENERGY_RX 0

set ENERGY_TX 0	

set TX 11

set RX 19.7

set BROADCASTING 0

set CYCLE 0

loop 

cprint  clock =  $clock

cprint  nextBroaadcast =  $nextBroaadcast

cprint  refractoryPeriod =  $refractoryPeriod

cprint  cyclelenght =  $cyclelenght

cprint  sameCount =  $sameCount

cprint  OVEREHEARD =  $OVEREHEARD

plus modulo $nextBroaadcast $refractoryPeriod

set modulo $modulo % $cyclelenght 

cprint  modulo =  $modulo





if (   ($clock == $nextBroaadcast) | |   ( ($clock == $modulo) && ($sameCount< $Threshhold)   )           )
then
	set sameCount 0

	plus E_TX $ENERGY_TX $TX 

	set ENERGY_TX $E_TX

	rand metadata

	cprint metadata = $metadata

	inc BROADCASTING

        cprint BROADCASTING = $BROADCASTING


else

set OVEREHEARD 0

read MESSAGE

cprint  MESSAGE = $MESSAGE


rdata $MESSAGE EXTERN_MEATADATA EXTERN_CLOCK OVEREHEARD



cprint  OVEREHEARD =  $OVEREHEARD


if ( $clock <= $cyclelenght   )
then
	if (  $OVEREHEARD >=1)
	then
		plus E_RX $ENERGY_RX $RX 

		set ENERGY_RX $E_RX

		print   EXTERN_MEATADATA =  $EXTERN_MEATADATA

		cprint  EXTERN_MEATADATA =  $EXTERN_MEATADATA


		if ( $clock > $refractoryPeriod ) 
		then
			min $clock clock EXTERN_CLOCK

		end

		if (   $EXTERN_MEATADATA > $metadata ) 
		then
			set metadata $EXTERN_MEATADATA 
		else

			if( $EXTERN_MEATADATA < $metadata  &&  $sameCount<1  )
				
					inc BROADCASTING
			else
			if (  $EXTERN_MEATADATA ==$metadata   && $clock== $EXTERN_CLOCK )
				inc sameCount 
			end

		end

		cprint checked 1   

	else

		cprint checked 0   
	end

end

end

end



cprint  ENERGY_TX =  $ENERGY_TX

cprint  ENERGY_RX =  $ENERGY_RX

time t

battery LEVEL_BATTERY

print  clock =  $clock


if( $clock==$cyclelenght)
then
	set clock 0
	set sameCount 0
	plus TOTAL $ENERGY_RX $ENERGY_TX
	printfile  $CYCLE , $TOTAL

	inc CYCLE

else

	inc clock 	

end


cprint  BROADCASTING =  $BROADCASTING

if ( $BROADCASTING >=1) 	
then
	set BROADCASTING 0

data MESSAGE $metadata $clock 1

send $MESSAGE

end

delay 1000
