# README - PRIVATE NOTES (SLAMtrack)

## Writing the paper

- add back in PCA plots (+/- DEA) ---> defer?  
- add in Run1_slamdunk
- rename Run1 - if not all folders  
- run all existing data through SLAMtrack pipeline   
- make figures  
- write paper  

- AAV8 mRNA > exemplar working well
- podo > also works but less well
- AAV8 miRNA > can label miRNA but at limit of detection for transfer?  
- podo miRNA > can we label?  


## Next steps

1) look within two sets of genes:
- genes well-labelled in liver
- genes not labelled in liver (but present in kidney) ------> DONE

2) 4TU effect on gene expression? - need PCA plots   

3) look for primary transcript (miR-122)

4) write paper (& CoRE application) - use miR-122 as exemplar - eLife? NatComms

5) paracetamol injury model and look in spleen too (and AAV8 null vector as control) - all male; probably FACS-sort tubules as well as bulk tissue: 4 groups (+- Cre; +- APAP) - for mRNA and smallRNA

6) ASN? (April)


## Priority:

- check and update README files (for smallSLAM and slamtrack)  
- add in filename to headers in Rmd files  
- add in candidate gene analysis (e.g. for miR-122 vs. other miRs)  
- add in gene labels to plot with ggrepel()  
- add in bespoke chunks for smallRNA analysis - e.g. TC by biotype  
- add in some basic table descriptors of library structure - e.g. no. of genes / rpm / parents per gene etc. - probably better in smallSLAM analysis Rmd?  
- add back PCA / dendrograms  


## To refine looking for labelled genes and the miniMAP analysis:  

In labelled genes:

- sort out problem with renaming group factors  
- look in genes that are ONLY in kidney  
- do the delta analysis for marker genes?  
- could try alternative marker gene strategy - proteinatlas.org (but NB human)  

In miniMAP:
- choose best bowtie alignment option (? length important for the LoxP sites)  


