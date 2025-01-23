#!/bin/bash

#Create a 5 minute timeout for root shell sessions unless an override file is created and owned by root#

echo '#!/bin/bash
OVTMFILE=/tmp/disable_timeout
 
TimeoutFunction () {
if [ "`whoami`" = "root" ]
then
  TMOUT=300
  readonly TMOUT
  export TMOUT
fi
}
 
if [ -f $OVTMFILE ]
then
#check the ownership of the file#
OVTMFILE_OWNER=`/usr/bin/stat -c %U $OVTMFILE`
  #if override file not owned by root set timeout#
  if [ "$OVTMFILE_OWNER" != "root" ]
  then
    TimeoutFunction
  fi
else
  #if override file not exist and user is root set timeout#
  TimeoutFunction
fi
 
unset OVTMFILE
unset OVTMFILE_OWNER
unset -f TimeoutFunction' > /etc/profile.d/timeout.sh

chmod 755 /etc/profile.d/timeout.sh
