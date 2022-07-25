############################################################################
#Prepare tagfiles for obitools
#
#by: Heike Zimmermann 25.07.2022
#Primers  for 18S_allshorts by Guardiola et al. 2015: 
#(Forward 5’-TTTGTCTGSTTAATTSCG-3’ and Reverse 5’-TCACAGACCTGTTATTGC -3’)
############################################################################

#read in file with primers and tags
primer.tag.file<-read.table("tags_18S_allshorts.txt", sep="\t", header=TRUE)

#read in file with samples and used tag-combinations
sample.file<-read.table("samplelist_18S_allshorts.txt", sep="\t", header=TRUE)

#prepare columns with primer sequences, Experiment and last column F
sample.file$PrimerF="TTTGTCTGSTTAATTSCG"
sample.file$PrimerR="TCACAGACCTGTTATTGC"
sample.file$lastcol="F"
sample.file$Experiment="HZ190IR"

#ngsfilter does not accept sample names starting with the same first characters
#append numbers in front of sample 

sample.file$PCR
sample.file$numbers=1:nrow(sample.file) 
sample.file$sample.name <- paste(sample.file$numbers, sample.file$PCR, sep="_")

#match forward and reverse tags with samples
sample.file$tag.sequenceF=primer.tag.file$tag.sequence[match(sample.file$Tag.F, primer.tag.file$primer_name)]
sample.file$tag.sequenceR=primer.tag.file$tag.sequence[match(sample.file$Tag.R, primer.tag.file$primer_name)]
head(sample.file) #check the first entries if everything is correct

#combine the forward and reverse tag sequences into format: tagF:tagR
sample.file$tag.combination <- paste(sample.file$tag.sequenceF, sample.file$tag.sequenceR, sep=":")

#finish tagfile
tagfile<-as.data.frame(cbind(sample.file$Experiment,sample.file$sample.name, sample.file$tag.combination, sample.file$PrimerF, sample.file$PrimerR, sample.file$lastcol))

write.table(tagfile, "AMD14_204_18Sallshorts_tagfile.txt", sep="\t",
            row.names = FALSE, col.names = FALSE, quote=FALSE)
