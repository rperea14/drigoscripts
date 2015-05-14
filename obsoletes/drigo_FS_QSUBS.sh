#!/bin/bash                                                                                                
# read DIREC                                                                                               
PWD=$( pwd )
SOURCE=$1
GROUPLIST="long_non_afil"
EXPECTED_ARGS=1

#Checking for one single argument
if [ $# -eq 0 ] ; then
echo "Type --help for help"

exit

fi
 

if [ $1 = "--help" ]; then
    echo"

This script will generate the *.qsub files that are necessary to submit into the cluster.
To run this script, it is recommended to run it from the folder containing the files you want to submit in the cluster.
To run, please type -run  
"
    exit
fi


if [ $1 = '-run' ] ; then
    
#Assigning the foldername to $FOLDER
    IMAGE=$1
    
    echo "What type of image are you using(e.g. .nii will be default if you hit enter)?"
    read -e ITYPE
    echo "Where are the images located (Type the folder location or Enter to use current location)?"
    read -e PROJECT
    
#If LOCATION is a null string...allocated as the pwd directory....

    if [ -z $ITYPE ]; then
	ITYPE='.nii'
    fi
    if [ -z $LOCATION  ]; then
	LOCATION=$PWD
    fi
    
    
    if [ -z $PROJECT ] ; then
	PROJECT=$PWD
	
    fi
    
    echo "QSUBS directory with all the *.qsubs will be generated in $PROJECT/QSUBS/* "
    
    QSUBS=$PROJECT/QSUBS
    mkdir -p $PROJECT/QSUBS

    for FILE in $( ls *$ITYPE ) ; 
    do
#Generating the pbs_submit file....




	#Check first if the files exists, if so, then delete it.
	if [ -f $QSUBS/${FILE/$ITYPE}.qsub ] ; then
	    rm $QSUBS/${FILE/$ITYPE}.qsub 
	fi
	
	echo "
#PBS -N ${FILE/$ITYPE}
#PBS -l nodes=1:ppn=2
#PBS -q default      
#PBS -M rperea@ittc.ku.edu
#PBS -m abe
#PBS -j oe                                                  

$FREESURFER_HOME/bin/recon-all -i $PROJECT/$FILE -s ${FILE/$ITYPE} -sd $PROJECT -autorecon-all | tee $QSUBS/tee_${FILE/$ITYPE} " >> $QSUBS/${FILE/$ITYPE}.qsub
	
	
	echo "${FILE/$ITYPE}.qsub has been stored in $QSUBS.."
    done


else
    echo " Incorrect arguments. Please type --help for help. "    
fi
