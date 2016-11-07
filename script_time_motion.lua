-- 2015 par Lira Fréderic sur des récupértions de different Forum Domoticz
-- Ce script permet de de mettre un temps de coupure après une detection presence
-- il faut absolument mettre " script_time_xxxx.lua " en titre pour que le compteur s'increment de 1 minute

--------------------------------
------ Fonction ------
--------------------------------
-- Utilisé pour la remise a zéro du compteur
local debugging = false
function crache_des_log (s)
    if (debugging) then 
        print (s);
    end
end


--------------------------------
------ Variables à éditer ------
--------------------------------
local motion_switch = 'Sensor1' -- Detecteur de mouvement
local boost = 'Boost' --ajout 1 heure de chauffage
local virtual_device_name= "PresenceMaison" -- Nom du périphérique virtuel représentant la présence
local user_variable_name = "TempsPresence" -- Nom de la variable utilisateur représentant le temps d'absence a créer dans Variables utilisateur
local PlanningPresence = "PlanningPresence" -- Nom du peripherique plannig pour le motion sensor

local temps_latence = 30 -- Temps de latence admis pour passer la présence à Off
crache_des_log ("temps_latence : " .. temps_latence)

--------------------------------
------ Nepas modifier ------
--------------------------------
local TempsPresence = tonumber(uservariables[user_variable_name]) 
local last_update = otherdevices_lastupdate[virtual_device_name]
local device_presence = otherdevices[virtual_device_name]
crache_des_log ("device_presence : " .. device_presence)

 
commandArray = {}

print "=========== Script de détection de présence des habitants (v1.0) ==========="
print ("Derniere mise à jour de la presence : "..last_update.."....")   


if (otherdevices[motion_switch] == 'On' and otherdevices[PlanningPresence] =='On')or(otherdevices[boost] =='On') then -- detection de la présence

    TempsPresence = 0
    crache_des_log ("motion_switch=on or boost=on! ==> TempsPresence = 0" )-- temps remis a zéro
	    crache_des_log ("device presence "..device_presence)
    if (device_presence=='Off') then
        crache_des_log ("device presence "..device_presence.. " otherdevices[virtual_device_name] : "..otherdevices[virtual_device_name])
       
        -- On passe le périphérique virtuel à On
        commandArray[virtual_device_name]='On'
        crache_des_log ("Présence On")
    else 
        crache_des_log ("déja présent avant ... on ne change rien")
    end
else
    TempsPresence = TempsPresence + 1    
    if (TempsPresence >= temps_latence and device_presence=='On') then 
               
        -- On passe le périphérique virtuel à Off
        commandArray[virtual_device_name]='Off'
        crache_des_log ("Présence Off")
    end
 
end
if (TempsPresence == 0) then 
    print (" ==> Présent")
else    
    print (" ==> Absent depuis " .. TempsPresence .. " minute(s)")
end
commandArray['Variable:TempsPresence'] = tostring(TempsPresence)
print "=========== Fin Script de détection de présence ==========="
return commandArray
