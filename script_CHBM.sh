#!/bin/bash 
tittle="------Anatomy Pipeline------"
echo ""
echo $tittle
echo ""
echo "->> Starting process..."

anat_path="/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOKSY/realese_2/ds_bids_cbm_loris_012720/"
echo "->> Anat Path: "$anat_path
freesurfer_path="/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOKSY/realese_2/freesurfer/"
echo "->> Freesurfer OutPut Path: "$freesurfer_path
ciftify_work_dir="/data3_260T/data/CCLAB_DATASETS/CHBM/CHBM_ARIOKSY/realese_2/ciftify/"
echo "->> Ciftify OutPut Path: "$ciftify_path

export $freesurfer_path

for subject in "$anat_path"/*
do
  if [ -d "$subject" ]; then

    	subject_dir=`dirname $subject`
    	subject_name=`basename $subject`
    	#echo $subject_name
    	T1w_file=$subject"/anat/"$subject_name"_T1w.nii.gz"
    	
    	if [ -f "$T1w_file" ]; then
        		echo "$T1w_file exist"
    		recon-all -i $T1w_file -sd $freesurfer_path -s $subject_name -all > $freesurfer_path"/$subject_name.txt"
    	else
    		echo "->> Error:The subject: "$subject_name". Don't have any T1w."
    	fi    
  fi
done
wait

for subject_freesf in "$freesurfer_path"/*
do
	if [ -d "$subject_freesf" ]; then
		subject_dir=`dirname $subject_freesf`
		subject_name=`basename $subject_freesf`
		ciftify_recon_all --verbose --surf-reg FS --resample-to-T1w32k --fs-subjects-dir $freesurfer_path --ciftify-work-dir $ciftify_work_dir $subject_name
	fi
done

echo ""
echo "Done.."
echo ""
