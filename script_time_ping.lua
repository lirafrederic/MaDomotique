-- 2016 par Lira Fréderic sur des récupértions de different Forum Domoticz
-- Ce script permet de detecter la presence d'une personne par rapport à son smartphone
-- pour un script pour windows, il faut remplacer " -c1 -w1 " par " -n3 -w 100>nul "ligne 10 
-- pour un script pour linux il faut remplacer " -n3 -w 100>nul " par " -c1 -w1 "ligne 10
--Le Ping : -c1 = Un seul ping  ,   -w1 délai d'une seconde d'attente de réponse
 


commandArray = {}
-- La commande print fait apparaitre une ligne dans les logs
print('Debut ping Smartphone Fred ')
-- 192.168.1.xxx : correspond à l’adresse IP de mon smartphone sur mon réseau - n3 windows -c1 rpi
ping_success=os.execute ('ping 192.168.x.xxx -c1 -w1')
-- Si le ping est OK
if ping_success then
     -- Si l’état actuel est Off dans domoticz    
     if (otherdevices['Smartphone Fred'] == 'Off') then
                  print('ping Smartphone Fred success ')
                 -- On change l etat du smartphone pour mettre a ON
                 commandArray['Smartphone Fred']='On'
    end
-- Si le ping est en erreur
else
     -- Si l etat actuel est ON dans domoticz 
       if (otherdevices['Smartphone Fred'] == 'On') then
                print('ping Smartphone Fred fail ')
               -- On change l etat du smartphone pour mettre a OFF              
               commandArray['Smartphone Fred']='Off'
      end
end
print(' fin ping Smartphone Fred ')
return commandArray