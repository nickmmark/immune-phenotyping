## Dimensional Reduction and Unsupervised Learning for Immune Cell Phenotyping
This repo describes techniques for immune cell phenotyping of non-small cell lung cancer using PCA, tSNE, and other techniques in [R](https://www.r-project.org/) and [FloJo](https://www.flowjo.com/solutions/flowjo). 

Modern [single cell analysis](https://en.wikipedia.org/wiki/Single-cell_analysis) techniques (flow cytometry, mass cytometry, single cell RNA sequencing, etc) capture massive amounts of high dimensional data: for example a comprehensive flow cytometry panel can stain cells with dozens of markers and identify hundreds of distinct cell types, and the raw data can occupy 1-25 GB. Interpreting this high dimensional data can be challenging. Dimensional reduction techniques can be used either to analyze raw flow cytometry data (to naively identify cell populations) or to analyze populations identified through traditional gating approaches (to identify population changes between groups). These techniques can be used to simplify complex high dimensional data and identify novel cell populations, such as interferon gamma producing immune cells in immune cells isolated from non-small cell lung cancer (NSCLC) tumors:

![3d render of IFN gamma expression overlayed onto a tSNE plot of a concatenated NSCLC tumor and non-adjacent lung sample](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/IFNgamma_animated.gif)

_tSNE plot CD45+ immune cells derived from NSCLC tumor and non-tumor adjacent lung tissue, z-axis and color indicates the degree of IFN-gamma production_


### Principle Component Analysis (PCA)
[Principle Component Analysis (PCA)](https://en.wikipedia.org/wiki/Principal_component_analysis) is a linear dimensional reduction algorithm with O(n2) time complexity. PCA is perhaps the most widely used dimensional reduction technique (having been first described in 1933) and has many implementations in R and other programming languages. PCA preserves the global structure of the data but not local structure: PCA places dissimilar points far apart but when reducing high dimensional data to a low dimension manifold similar points are not placed close together.

In this example of immune cell phenotyping of NSCLC and lung tissue, I examined a dataset of samples obtained from individuals undergoing surgical resection of NSCLC; these samples were processed fresh into a single cell suspension and stained with a panel of >30 antibodies against surface and intracellular antigens and >50,000 events were obtained by flow cytometry. 

![overlapping immune phenotypes of tumor and lung samples](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/lung%20tumor.png)
_Overlapping immune cell phenotypes of tumor and lung samples_


![overlapping immune phenotypes of tumor and lung samples with Eigenvectors](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/lung%20tumor%20w%20eigenvectors.png)
_Immune cell populations in tumor and lung samples with Eigenvectors shown_

We can also look at other clinical parameters, such as if the sample came from a patient with COPD or not, based on either the degree of airflow obstruction ([GOLD stage](https://goldcopd.org/wp-content/uploads/2018/02/WMS-GOLD-2018-Feb-Final-to-print-v2.pdf)) or the degree of emphysema as measured radiologically ([Goddard score](https://www.researchgate.net/publication/316458451_Updates_in_computed_tomography_assessment_of_emphysema_using_computed_tomography_lung_analysis)).  Although the degree of emphysema and airflow obstruction are correlated there are phenotypic and immunologic differences, as seen below:
![airflow obstruction versus emphysema](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/gold%20goddard%20w%20image.png)

For example:

```R
# define the presence of COPD
copd <- mutate(copd, new_gold = ifelse(gold_stage < 1, "No COPD present", "COPD present"))
copd <- mutate(copd, new_goddard = ifelse(goddard_score < 0.5, "No emphysema present", "Emphysema present"))
copd <- mutate(copd, new_copd_any_definition = ifelse(copd_anydefinition < 1, "No COPD", "COPD"))
copd <- na.omit(copd)

# select the correct cell types for inclusion
copd <- select(copd, gold_stage, goddard_score, new_gold, new_goddard, colNames, sample, copd_anydefinition,
               cd45, cd3, cd4, cd8, nkt, pmn, nk, b, #gdt, nk, b, mac, pmn,  # basic cell types
               cd8ifng, th1, th17, treg, gdtil17, gdtifng,      # cytokine profiles
              #cd4_pd1, cd8_pd1,                                # pd-1 expression
              #pmnpdl1, macpdl1, monopdl1, nocd45pdl1,           # pd-l1 expression
              #cd4_tim3, cd8_tim3,                                # tim3 expression
              #cd4pd1tim3, cd8pd1tim3,                          # dual checkpoint expression
               )          

pr <- prcomp(minus_gold)
pc_comps <- data.frame(pr$rotation)
pc1_vars <- select(pc_comps, PC1)
pc2_vars <- select(pc_comps, PC2)
arrange(pc1_vars, PC1)

# Write 2 axis PCA
autoplot(pr, data = copd,
         colour = "new_gold", frame = TRUE, frame.type = "norm",
         #loadings = TRUE, loadings.label = TRUE, loadings.colour = "black"            # show eigenvectors
         ) +
         ggtitle(label = "COPD vs Non-COPD PCA")
```

This shows us the the effect of COPD being present in the resected non-adjacent lung on immune cell phenotype in the resected tumor. In this case we define COPD as the presence of airflow obstruction based on GOLD stage (see code above).

![example showing the effect of COPD present in the resected non-adjacent lung on immune cell phenotype in the resected tumor](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/COPD_present_or_not.png)

### t-Distributed Stochastic Neighbor Embedding (tSNE)
[t-Distributed Stochastic Neighbor Embedding (tSNE)](https://en.wikipedia.org/wiki/T-distributed_stochastic_neighbor_embedding) is an non-linear algorithm for performing dimensionality reduction, allowing visualization of complex multi-dimensional data in fewer dimensions while maintaining the overall structure of the data. tSNE was first described in 2008 and has become a widely used dimensional reduction technique (see the creator, [Laurens van der Maaten's website](https://lvdmaaten.github.io/tsne/) for more details). Importantly, tSNE is able to preserve *BOTH* the local and global structures of the data. tSNE was first described in 2008 and is a powerful and useful technique that can be done either natively in FloJo or R using the ```rTsne``` package. For a complete description of the underlying algorithm, see [here](https://www.analyticsvidhya.com/blog/2017/01/t-sne-implementation-r-python/)

For tSNE in FloJo there is excellent documentation available [here](http://docs.flowjo.com/d2/advanced-features/dimensionality-reduction/tsne/). 

To perform tSNE in R, we can use the ```rTsne``` package. In this example, Paired immune cell populations (CD45+) from lung tumor and non-tumor adjacent lung were concatenated (50,000 events from each sample) and analyzed using tSNE. Specific immune cell populations can be labeled according to origin (lung vs tumor), immune effector cell type (CD4+, CD8+, gamma delta TCR+), or intracellular cytokine production (interferon gamma, IL-17a, etc). We can export flow cytometry data in a dataframe such that each row represents a single event (cell) and each column represents the values for each marker. 

```R
training_set <- loadExcel("NSCLC.xlsx",1)
immune_cell_tsne <- Rtsne(training_set[,-1], dims = 2, perplexity=25, theta = 0.2, verbose = TRUE, PCA = TRUE, max_iter = 500)
plot(immune_cell_tsne$Y, t='n', main="immune_cell_tsne")
text(immune_cell_tsne$Y, labels=train$label, col=colors[train$label])
```

When performing tSNE it is important to carefully select hyperparameters:
- **dimensions** - how many dimensions are desired (usually 2)
- **perplexity** - increase with larger number of cells or with a denser cluster; typically 25-100
- **maximum iterations** - typically 500 or 1000
- **theta** (speed/accuracy tradeoff) - 
- **PCA** (true or false) - 
- **eta** (learning rate) - controls how much the weights are adjusted at each iteration. Optimally set at 7% the number of cells being mapped into tSNE space.

Hyperparameter tuning requires experimentation. I recommend downsampling the dataset to 10,000 events while optimizing the parameters to save time.

In this example, we can see that t-Distributed Stochastic Neighbor Embedding demonstrates overlapping immune cell populations in paired NSCLC and lung samples. Specifically, we can see that there are similar/overlapping immune cell populations in both the lung and tumor populations. 
![Another example using different samples](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/27-Jul-2017-Layout.png)

Here is a summary of tSNE findings for multiple concatenated lung and tumor samples:
![lung and tumor summary](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/tsne_summary.png)
_tSNE analysis of multiple lung tumors - note the overlapping immune phenotype for several different lung/tumor samples_

While tSNE is a powerful and useful tool for analyzing immune cell populations, there are some important limitations of tSNE to consider:
- computationally expensive; with O(n2) time complexity this can take a long time to run (it makes sense to setup a cloud VM with lots of RAM and compute to run for datasets larger than 100k cells)
- non-deterministic; running the same data can produce (slightly) different results
- sensitive to hyper-parameters; make sure to empirically tune and then standardize the settings used
- images can be deceptive; although tSNE space preserves the local and global aspects of the data, the relative area of different regions is not representative of the number of cells
- sensitive to the compensation of the data; one of the strengths of tSNE is that it can accomodate log distributed data, however if there are events off scale it will distort the analysis

### T cell receptor sequence analysis
Examining TCR sequences, consensus sequences, and shared sequences in both tumor and adjacent tissue using the [```tcr``` R package](https://cran.r-project.org/web/packages/tcR/vignettes/tcrvignette.html).


### Other techniques
- [Uniform Manifold Approximation and Projection](https://www.biorxiv.org/content/biorxiv/early/2018/04/10/298430.full.pdf) (UMAP) - An alternative non-linear, non-deterministic, dimensional reduction algorithm. I have less experience using UMAP but it has some clear advantages including O(d*n^1.14) rather than O(n2) time complexity that make it appealing for large datasets. UMAP is available as an R package [here](https://github.com/tkonopka/umap).
- [Hierarchical Clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering)
- 

### version/to do
current version 0.1.3
- [ ]current version 0.1.0 - this is a work in progress
- [ ]need to cleanup the tSNE R code
- [ ]add more detailed examples and explanations
- [ ]add additional references

## references
- Mark NM et al, [Chronic Obstructive Pulmonary Disease Alters Immune Cell Composition and Immune Checkpoint Inhibitor Efficacy in Non-Small Cell Lung Cancer](https://www.ncbi.nlm.nih.gov/pubmed/28934595), AJRCCM 2018
- Thorsson V et al, [The Immune Landscape of Cancer](https://www.ncbi.nlm.nih.gov/pubmed/29628290), Immunity. 2018
- [FloJo tSNE documentation](http://docs.flowjo.com/d2/advanced-features/dimensionality-reduction/tsne/)
- [Comprehensive Guide on t-SNE algorithm with implementation in R & Python](https://www.analyticsvidhya.com/blog/2017/01/t-sne-implementation-r-python/)
- Becht E et al, [Evaluation of UMAP as an alternative to t-SNE for single-cell data](https://www.biorxiv.org/content/biorxiv/early/2018/04/10/298430.full.pdf)
- Nazarov, V.I., Pogorelyy, M.V., Komech, E.A. et al. tcR: an R package for T cell receptor repertoire advanced data analysis. BMC Bioinformatics 16, 175 (2015). https://doi.org/10.1186/s12859-015-0613-1
