#/usr/bin/Rscript
library(optparse)
library(ggplot2)
option_list <- list(make_option(c("-i","--input"), help="the GCmap file generated by BS-seeker2"),
                   make_option(c("-o","--out_prefix"), help = "the output prefix of data and pictures")
)
opts <- parse_args(OptionParser(option_list=option_list))

da <- read.table(opts$input,header=F)
plant <- subset(da,da$V1!="lambda")
lambda <- subset(da,da$V1=="lambda")
conversion_rate <- (sum(lambda$V8)-sum(lambda$V7))/sum(lambda$V8)
cat("file name is:",opts$input,"\n")
cat("the conversion_rate:",conversion_rate,"\n")
da$V4<-as.factor(da$V4)
methylation_class_rate <- tapply(da$V6, da$V4,mean)
out_picture_name <- paste(opts$out_prefix,".jpeg",sep="")
jpeg(out_picture_name)
barplot(methylation_class_rate)
dev.off()
cg_subset <- subset(plant, plant$V4 =="CG")
chg_subset <- subset(plant, plant$V4 == "CHG")
chh_subset <- subset(plant, plant$V4 == "CHH")
write.table(cg_subset,  file=paste(opts$out_prefix, ".CG.CGmap",  sep=""), row.names=F, quote=F, sep="\t", col.names = F)
write.table(chg_subset, file=paste(opts$out_prefix, ".CHG.CGmap", sep=""), row.names=F, quote=F, sep="\t", col.names = F)
write.table(chh_subset, file=paste(opts$out_prefix, ".CHH.CGmap", sep=""), row.names=F, quote=F, sep="\t", col.names = F)