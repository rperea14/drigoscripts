#!/bin/sh

#   tbss_non_FA - project non-FA data onto the skeleton

if [ $1 -z ] ;then

    echo "Usage: RUN drigo_tbss_non_FA_ants_Step1.sh FIRST!!"
    echo "Dependencies: output from drigo_tbss_non_FA_ants_Step1.sh in a input/ directory and 
                        all of file bewlo in a dependencies/ folder:
                        mean_FA.nii.gz
                        mean_FA_skeleton_mask_dst
                        mean_FA_mask.nii.gz
                        all_FAAnts.nii.gz
                        "
    echo "\$1 is RD or AxD or MD"

exit
fi

cd Step3_Final_skeletonisation/
ALTIM=$1
INPUT='input'
DEPENDENCY='dependencies'

#Step3:FINAL TBSS_NON_FA step
echo "merging all upsampled $ALTIM images into single 4D image"
temp=$( $FSLDIR/bin/imglob $INPUT/ToMNI*)
${FSLDIR}/bin/fslmerge -t all_${ALTIM}Ants_not_mean_masked $temp
${FSLDIR}/bin/fslmaths  all_${ALTIM}Ants_not_mean_masked  -mas $DEPENDENCY/mean_FA_mask all_${ALTIM}Ants



echo "projecting all_$ALTIM onto mean FA skeleton"
thresh=0.2
${FSLDIR}/bin/tbss_skeleton -i $DEPENDENCY/mean_FA -p $thresh $DEPENDENCY/mean_FA_skeleton_mask_dst ${FSLDIR}/data/standard/LowerCingulum_1mm $DEPENDENCY/all_FAAnts all_${ALTIM}_skeletonised -a all_${ALTIM}Ants

echo "now run stats - for example:"
echo "randomise -i all_${ALTIM}_skeletonised -o tbss_$ALTIM -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V"
echo "(after generating design.mat and design.con)"
