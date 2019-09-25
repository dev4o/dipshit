#!/bin/bash

a=`df -h | grep lv_root | awk '{print $5}' | sed 's/%//g'`

if [ $a > 90 ];

        then

                echo "The disk space is over 90 percent utilized.";
                mail -vs 'High Disk Space Utilization' test@test.com <<< 'The Confluence server root filesystem is over 90 percent utilized'

        else

                echo "This is an informational email, the disk space is under 90 percent utilized, nothing to do, please disregard this email.";

fi;
