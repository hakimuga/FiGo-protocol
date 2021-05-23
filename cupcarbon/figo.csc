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

loop 

cprint  clock =  $clock

cprint  nextBroaadcast =  $nextBroaadcast

cprint  refractoryPeriod =  $refractoryPeriod

cprint  cyclelenght =  $cyclelenght

cprint  sameCount =  $sameCount

cprint  OVEREHEARD =  $OVEREHEARD

set modulo ($nextBroaadcast +$refractoryPeriod) %$cyclelenght 


if (   ($clock == $nextBroaadcast) | |   ( ($clock == $modulo) && ($sameCount< $Threshhold)   )           )

		set sameCount 0

	rand metadata

	cprint  metadata =  $metadata

	data MESSAGE $metadata $clock  1

	send $MESSAGE



else

set OVEREHEARD 0

read MESSAGE

cprint  MESSAGE =  $MESSAGE


rdata $MESSAGE EXTERN_MEATADATA EXTERN_CLOCK  OVEREHEARD


cprint  OVEREHEARD =  $OVEREHEARD


if ( $clock <= $cyclelenght   )

	if (  $OVEREHEARD >=1)

		print   EXTERN_MEATADATA =  $EXTERN_MEATADATA

		cprint  EXTERN_MEATADATA =  $EXTERN_MEATADATA


		if ( $clock > $refractoryPeriod ) 

			min $clock  clock EXTERN_CLOCK

		end

		if (   $EXTERN_MEATADATA > $metadata ) 

			set metadata $EXTERN_MEATADATA 
		else

			if( $EXTERN_MEATADATA < $metadata  &&  $sameCount<1  )

				data MESSAGE $metadata $clock 1

				send $MESSAGE 
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

print  clock =  $clock

if( $clock==$cyclelenght)

	set clock 0
	set sameCount 0

else

	inc clock 

	

end

delay 10000
