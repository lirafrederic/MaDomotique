-- 2016 par Lira Fréderic 
 


commandArray = {}
print('Debut ping Smartphone Fred ')
ping_success=os.execute ('ping 192.168.x.xxx -c1 -w1')
if ping_success then
          if (otherdevices['Smartphone Fred'] == 'Off') then
                  print('ping Smartphone Fred success ')
                 ommandArray['Smartphone Fred']='On'
    end

else
     
       if (otherdevices['Smartphone Fred'] == 'On') then
                print('ping Smartphone Fred fail ')
                         
               commandArray['Smartphone Fred']='Off'
      end
end
print(' fin ping Smartphone Fred ')
return commandArray