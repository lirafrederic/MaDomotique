-- Modifier par Lira Fréderic 2016 sur une base de  Alexandre DUBOIS - 2014 
-- Ce script permet de maintenir la température de confort avec un choix planning Jour ouvré ou vacances.

-- Une consigne de nuit a été ajouté.


 
--------------------------------
------ Variables à éditer ------
--------------------------------
local consigne = string.match(otherdevices_svalues['consigne_chauf_jour'], "(%d+%.*%d*)")  --Choix température de consigne jour
local econuit = string.match(otherdevices_svalues['consigne_chauf_nuit'], "(%d+%.*%d*)")  --Choix température de nuit
local ecojour =string.match(otherdevices_svalues['consigne_presence'],"(%d+%.*%d*)")  --Choix température de consigne presence
local ecoHorsGel =string.match(otherdevices_svalues['Consigne_Hgel'],"(%d+%.*%d*)") --Choix de la temperature pour longue absence
local hysteresis = 0.2 --Valeur seuil pour éviter que le relai ne cesse de commuter dans les 2 sens
local sonde = 'TcAmbiante' --Nom de la sonde de température
local tcsensor = 'TcSensor' --Nom de la deuxieme sonde température
local thermostat = 'Calendrier_chauffage' --Nom de l'interrupteur virtuel programmer aux horaires de jours ouvrés classics
local InterVacance = 'Chauf_Vacances' -- Interupteur virtuel programmer aux horaires de vacances a la maison
local presenceMaison = 'PresenceMaison' -- indicateur de presence pour temp 19
local radiateur = 'Chaudiere' --Nom du radiateur à allumer/éteindre
local choixchauf = 'ModeVacancesChauf' --bouton du choix de chauffage
local Absence = 'Hors_Gel' --bouton chauffage mode nuit pour vacances
--------------------------------
-- Fin des variables à éditer --
--------------------------------
 
commandArray = {}
--La sonde Oregon 'Salon' emet toutes les 40 secondes. Ce sera approximativement la fréquence 
-- d'exécution de ce script.
if (devicechanged[sonde]) or (devicechanged[tcsensor]) then
		local temperature = tonumber (string.sub(otherdevices_svalues[sonde],1,4))
	
	-- mode de reglage horsgel en cas d'absence prolongé
		if(otherdevices[Absence]=='On') then
       print('-- Gestion du thermostat mode Absence--')
 
    	if (temperature < (ecoHorsGel - hysteresis) ) then
            print('--Allumage du chauffage confort Absence--')
            commandArray[radiateur]='On'
 
	     elseif (temperature > (ecoHorsGel + hysteresis)) then
	       print('--Extinction du chauffage confort Absence--')
           commandArray[radiateur]='Off'
 
	    
		end
		
		-- mode normal jour du thermostat
	   else 
	 if (((otherdevices[thermostat]=='On') and (otherdevices[choixchauf]=='Off')) or ((otherdevices[InterVacance]=='On') and (otherdevices[choixchauf]=='On'))) then
        print('-- Gestion du thermostat mode confort --')
 
    	if (temperature < (consigne - hysteresis) ) then
            print('--Allumage du chauffage confort jour--')
            commandArray[radiateur]='On'
 
	     elseif (temperature > (consigne + hysteresis)) then
	        print('--Extinction du chauffage confort jour--')
            commandArray[radiateur]='Off'
 
	    end
		-- mode presence du thermostat pour une mise en route automatique en journée sur detection.
   else 
	if(otherdevices[presenceMaison]=='On') then
       print('-- Gestion du thermostat mode presence--')
 
    	if (temperature < (ecojour - hysteresis) ) then
            print('--Allumage du chauffage confort presence--')
            commandArray[radiateur]='On'
 
	     elseif (temperature > (ecojour + hysteresis)) then
	       print('--Extinction du chauffage confort presence--')
           commandArray[radiateur]='Off'
 
	    
		end
		
		
	-- mode normal nuit du thermostat
	
     elseif (((otherdevices[thermostat]=='Off')and(otherdevices[choixchauf]=='Off'))or((otherdevices[InterVacance]=='Off')and(otherdevices[choixchauf]=='On'))) then
           print('-- Gestion du thermostat mode nuit --')
 
        	if (temperature < (econuit - hysteresis) ) then
            print('--Allumage du chauffage eco nuit--')
            commandArray[radiateur]='On'
 
	        elseif (temperature > (econuit + hysteresis)) then
	       print('--Extinction du chauffage eco nuit--')
           commandArray[radiateur]='Off'
		   
		   end
		   
	 
		   
	
end
		end
	
		end  

		
		end
		
 

	
return commandArray