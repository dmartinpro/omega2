#!/bin/sh                                            
                                                      
###                                                   
# Simple script to test Power Dock battery indicator  
#                                                     
# Requires additional package:                        
#       opkg install coreutils-sleep                  
###                                                   
                                                      
                                                      
                                                      
IC_CTRL_GPIO=19                                       
IC_CTRL_SLEEP1=0.1                                    
IC_CTRL_SLEEP2=0.2                                    
BL0_GPIO=16                                           
BL1_GPIO=18                                           
PLUGDETECT_GPIO=15                                    
                                                      
ActivateBatteryLevel () {                             
#       echo "> Pulse, $r"                            
        gpioctl dirout-low $IC_CTRL_GPIO >& /dev/null 
        /usr/bin/sleep $IC_CTRL_SLEEP2                
        gpioctl dirout-high $IC_CTRL_GPIO >& /dev/null
        /usr/bin/sleep $IC_CTRL_SLEEP1               
        gpioctl dirout-low $IC_CTRL_GPIO >& /dev/null
}                                                  
                                                   
ReadGpio () {                                              
        val=$(gpioctl get $1 | grep LOW)                   
                                                             
        if [ "$val" != "" ]; then                            
                ret="0"                                      
        else                                                 
                ret="1"                                      
        fi                                                   
                                                             
        echo "$ret"                                          
}                                                            
                                                             
CheckBatteryLevel () {                                       
        charge=$(ReadGpio $PLUGDETECT_GPIO)                  
        echo "> Charging status: $charge"                    
                                                             
        battery1=$(ReadGpio $BL1_GPIO)                       
        battery0=$(ReadGpio $BL0_GPIO)                       
#       echo "> Battery Level: $battery0 $battery1"          
                                                             
        batteryLevel=0                                       
        if [ "$battery1" -eq 1 -a "$battery0" -eq 0 ]; then  
                batteryLevel=4                               
        elif [ "$battery1" -eq 1 -a "$battery0" -eq 1 ]; then
                batteryLevel=3                               
        elif [ "$battery1" -eq 0 -a "$battery0" -eq 1 ]; then
                batteryLevel=2                               
        elif [ "$battery1" -eq 0 -a "$battery0" -eq 0 ]; then
                batteryLevel=1                 
        fi                                     
        echo "> Battery Level: $batteryLevel/4"
}                                          
                                           
#echo "> Enabling Battery LEDs"            
                                                             
#while [ 1 ]                                                 
#do                                                          
#       gpioctl dirout-low $IC_CTRL_GPIO                     
#       /usr/bin/sleep $IC_CTRL_SLEEP                        
#       gpioctl dirout-high $IC_CTRL_GPIO                    
#                                                            
#       /usr/bin/sleep 0.1                                   
#done                                                        
                                                             
# gpio setup                                                 
gpioctl dirin $BL0_GPIO >& /dev/null                         
gpioctl dirin $BL1_GPIO >& /dev/null                         
gpioctl dirin $PLUGDETECT_GPIO >& /dev/null                  
                                                             
ActivateBatteryLevel                           
                                               
/usr/bin/sleep 0.5                             
CheckBatteryLevel                          
                                           
#/usr/bin/sleep 1                          
#echo "> Next battery check"               
#CheckBatteryLevel
