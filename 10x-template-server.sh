#!/bin/bash
set -e

#set your reference here: GRCh37 or GRCh38
REFERENCE=GRCh37

#loop over all the samples you want mapped
for SAMPLE in 
do
	#run the cellranger-wrapper.sh pipeline, providing cram/fastq input as argument 1
	#and GRCh37/GRCh38 reference choice as argument 2. arguments 3+4 form an imeta query pair
	#you can optionally provide a second one to refine the search if needed in 5+6
	#argument 4 will be used for naming the cellranger output files
	bash /mnt/mapcloud/scripts/10x/cellranger-wrapper.sh cram $REFERENCE sample $SAMPLE
	
	#EmptyDrops droplet calling, FCA style. comment out if unwanted. make sure reference matches above
	#Rscript /mnt/mapcloud/scripts/10x/emptydrops.R $SAMPLE $REFERENCE
	
	#and now that we ran cellranger, we can toss it over to the farm for safekeeping. specify where below
	sshpass -f ~/.sshpass rsync -Pr $SAMPLE kp9@farm3-login.internal.sanger.ac.uk:/lustre/scratch117/cellgen/team205/
	
	#and now that we copied over the results, time to burn the input/output to the ground and start anew
	rm -r fastq
	rm -r $SAMPLE
done