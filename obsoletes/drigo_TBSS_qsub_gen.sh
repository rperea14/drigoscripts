#!/bin/bash

SOURCE=$( pwd )
if [ -z $1 ] ; then
echo "Run it with -run and the output name you want"

fi

if [ -z $2  ] ; then 
    echo "PLease run it with -run (first input should be the output name!!)
"
else
    
    if [ -e $SOURCE"/QSUB_FA.qsub" ] ; then
	rm $SOURCE"/QSUB_FA.qsub" 
    fi
          
    echo "
#PBS -q default
#PBS -N $2
#PBS -l nodes=1:ppn=1,mem=2g
#PBS -j oe

cd $SOURCE
randomise -i $SOURCE/all_FA_skeletonised.nii.gz  -o $SOURCE/tbss_$2 -m $SOURCE/mean_FA_skeleton_mask.nii.gz -d $SOURCE/design/design.mat -t $SOURCE/design/design.con -n 5000 --T2 -V | tee $SOURCE/tee_$2" >> $SOURCE/QSUB_FA.qsub
    
fi

