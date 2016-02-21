#!/usr/bin/env Rscript

library(DESeq2)
library("pheatmap")

options(bitmapType="cairo")

directory <- "{$self->htseq_dir}"

sampleFiles <- grep(".txt", list.files(directory),value=TRUE)
sampleFiles

#I dont know what this is supposed to be
sampleN <- sub("(*)_*.txt","\\1",sampleFiles)
sampleN <- sub("htseq_(*)","\\1",sampleN)

{
    my @vals = $self->attr->get_values('other_regexp');
    my $text = $vals[0];
    my $href = {};
    foreach my $sample (@{$self->samples}){
        if($sample =~ qr/$text/){
            my(@match) = $sample =~ qr/$text/;
            my($cond, $repl) = ($match[0], $match[1]);
            if(exists $href->{$cond}){
                my $count = $href->{$cond};
                $count += 1;
                $href->{$cond} = $count;
            }
            else{
                $href->{$cond} = 1;
            }
        }
        else{
            #Do something to say the regexp did not catch this sample
        }
    }
    my @keys = keys(%{$href});
    $self->stash->{array} = [];
    $self->stash->{lim} = @keys;
    foreach my $k (@keys){
        $self->stash->{conditions}->{$k} = $href->{$k};
        push(@{$self->stash->{array}}, "rep(\"$k\", $href->{$k})");
    }

}

sampleCondition <- factor(c( {join(",", @{$self->stash->{array}})} ))
sampleCondition

sampleTable <- data.frame(sampleName = sampleN, fileName = sampleFiles, condition = sampleCondition)
sampleTable


dds <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,directory = directory,design= ~ condition,ignoreRank=FALSE)
dds

dds <- DESeq(dds)

rld <- rlog(dds)
vsd <- varianceStabilizingTransformation(dds)
rlogMat <- assay(rld)
vstMat <- assay(vsd)

write.table(rlogMat, "{$self->outdir}/deseq2_all_samples_rlog.csv", sep="\t")
write.table(vstMat, "{$self->outdir}/deseq2_all_samples_vst.csv", sep="\t")


sampleDists <- dist(t(assay(rld)))
library("RColorBrewer")
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(rld$condition, rld$type, sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
png("{$self->outdir}/deseq2_all_samples_rlog_heatmap.png")
rlogHeat <- pheatmap(sampleDistMatrix,clustering_distance_rows=sampleDists,clustering_distance_cols=sampleDists,col=colors)
rlogHeat
dev.off()


sampleDists <- dist(t(assay(vsd)))
library("RColorBrewer")
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(rld$condition, rld$type, sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
png("{$self->outdir}/deseq2_all_samples_vst_heatmap.png")
vstHeat <- pheatmap(sampleDistMatrix,clustering_distance_rows=sampleDists,clustering_distance_cols=sampleDists,col=colors)
vstHeat
dev.off()

{
	my %seen = ();
	my @conditions = keys %{$self->stash->{conditions}};
	$OUT .= "# CONDITIONS: ".join(",", @conditions)."\n";
	my $lim = $self->stash->{lim};
	
	for (my $i = 0;$i<$lim;$i++){

		for (my $i2 = $0;$i2<$lim;$i2++){
			next if $conditions[$i] eq $conditions[$i2];
			next if exists $seen{$conditions[$i]."_".$conditions[$i2]};
			next if exists $seen{$conditions[$i2]."_".$conditions[$i]};
			$seen{$conditions[$i]."_".$conditions[$i2]} = 1;
			$seen{$conditions[$i2]."_".$conditions[$i]} = 1;

			$OUT .= "$conditions[$i]VS$conditions[$i2] <- results\(dds,contrast=c\(\"condition\",\"$conditions[$i]\",\"$conditions[$i2]\"\)\)\n";
			$OUT .= "write.table\($conditions[$i]VS$conditions[$i2],\"$self->{outdir}/$conditions[$i]VS$conditions[$i2].csv\", sep=\"\\t\")
				png\(\"$self->{outdir}/$conditions[$i]VS$conditions[$i2]\_MAplot.png\"\)
				plotMA\($conditions[$i]VS$conditions[$i2], main=\"DESeq2\", ylim=c\(-2,2\)\)
				dev.off\(\)\n\n";
		}
	}
}
