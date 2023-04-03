<<doc
    
   Name          = Nikhil R Dhoke
   Date          =  
   Description   = Monitoring Ram ,Cpu ,Memory usage of a Server and Display 
   Sample input  = df -h , top  commands
   Sample output = display warning
doc
  #!/bin/bash
#------ features to be implemented ----------#
  # ----Server Utilization-----
  # Uptime             DONE
  # Cpu_Usage          DONE
  # Memory_Usage       memoryname remaining
  # Disk_usage         hard codeded
  # temp_of_components DONE
  # mail alert 
  # ne -"String update on only one line \r" not done
  # logsof all comp. 
  # oem errors        NOt working
  # last logins       DONE
  # blinking warning  DONE
  
  #!/bin/bash
  
  cpu_threshold='2'                        # MAX_CPU_USAGE THRESHOLD VALUE (should not cross this limit)
  
  mem_remain_threshold='2000'    # 2GB      # REMAINING MEMORY_USAGE THRESHOLD VALUE (MB) if fell below this warning
  
  disk_threshold='60'                       # DISK_USAGE THRESHOLD VALUE(disk should not fill above 60)

  cpu_temp_threshold='70'                   # CPU_TEMPERATURE
  # you should install lm-sensor to use above featue ( sudo apt install lm-sensors)

  cpu_name=`lscpu | grep 'Model name'`      # GETS NAME OF CPU  

  red='\033[31;5m'
  green='\033[0;32m'
  clear='\033[0m'
  yellow='\033[0;33m'
  magenta='\033[0;35m'
  cyan='\033[0;36m'
  Underline
  Background_Bold_blue='\033[1;94m'
  High_intensity_purple='\033[0;95m'
  blink='\033[33m'
  #----------------------------------------# LAST LOGINS and UPTIME--------------------= OOM Errors not working
  other_feature()
  {
     echo -e "<<<<<<<< ${Background_Bold_blue}WELCOME TO SERVER MONITORING SYSTEM ${clear}>>>>>>>>"
     echo 
     echo `date`
     echo
     echo "------------------------------------------------------"
     echo -ne "${High_intensity_purple}Uptime: ${clear}" 
     uptime
     echo "------------------------------------------------------"
     echo -ne "${green}Currently Connected${clear}"
     w
     echo "------------------------------------------------------"
     echo  -e "${cyan}Last Logins:${clear}"
     last -a | head -3
     echo "------------------------------------------------------"

#     start_logs=`head -1 /var/log/messages |cut -c 1-12`
#    errors=`grep -ci kill /var/log/messages`
#    #echo -n "OOM errors Since $start_logs : "$errors                # out of Memory errors
#    echo ""

  
  }
  
  #---------------------------------------- # CPU----------------------------- all working
  
  filename=
  cpu_usage ()
  {
    echo
    cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $8}'|cut -f 1 -d "."`
    cpu_use=`expr 100 - $cpu_idle`
    echo -ne "CPU\n"
    echo -ne "${yellow} $cpu_name${clear}"
    echo
    echo -ne " ${green}Cpu utilization: $cpu_use ${clear}%\n"
    temp=`cat /sys/class/thermal/thermal_zone*/temp | head -2 | tail -1`    # GETS 3 values extracted 1 value
    cpu_temp=$(($temp/1000)) 
  
      if [ $cpu_temp -gt $cpu_temp_threshold ]
      then
          echo -ne "${red} CPU Temperature HIGH $cpu_temp${clear} \n"
      else
          echo -ne "${green} CPU Temp: $cpu_temp *C ${clear}\n"
    fi
      if [ $cpu_use -gt $cpu_threshold ]
      then
          echo -ne "\r${red} CPU WARNING !!!${clear} \n\c"
      else
          echo -ne "${green} CPU OK ..${clear}\n\c"
      fi
  }
  
  #---------------------------------------- # MEMORY ------------------------ all working
  
   mem_usage ()
   {
     #MB units
     mem_free=`free -m | grep "Mem" | awk '{print $4+$6}'`   # -m stands for Megabytes $4 prints the 4 th 
     echo "RAM"
   
     d=`sudo dmidecode | grep "Configured Memory Speed" | grep "MT/s"`
     Ram_Manufacturer=`sudo dmidecode --type 17 | grep -i "Manufacturer" | head -2 | tail -1`     # works for my pc chance to improve
     echo -e "${yellow}$Ram_Manufacturer${clear}"
     echo -e "${green} $Ram_speed${clear}"
     echo -ne " ${green}       Memory space remaining : $mem_free MB${clear}\n"
     
      if [ $mem_free -lt $mem_remain_threshold  ]
      then
          echo -ne "\r${red}        MEMORY WARNING !!!${clear} \n\c"
      else
          echo -ne "\r${green}        MEMORY OK ..${clear} \n\c"
     fi
   }
  
  #----------------------------------------- # DISK -------------------------- DISK manufactureer Hard Coded
  
    disk_usage () 
   {
    disk_use=`df -P | grep /dev | grep -v -E '(tmp|boot)' | awk '{print $5}' | cut -f 1 -d "%"`
    Disk_manufacturer="WD"
    echo "DISK"
    echo -ne " ${yellow}Disk Manufacturer:               $Disk_manufacturer${clear}\n"
     echo -ne " ${green}Disk usage : $disk_use % ${clear}\n " 
     if [ $disk_use -gt $disk_threshold ]
     then
         echo -ne "${red} DISK WARNING!!!${clear} \n"
     else
         echo -ne "${green}DISK OK ..${clear}\n\c"
    fi
  }

  while [ 1 ]
  do
  echo
  echo
  other_feature
  cpu_usage
  mem_usage
  disk_usage  
  sleep 3

   #     >> log_file.csv
  done
                                                                                                                                                                                                                                                                                                                                                                                          
                 
