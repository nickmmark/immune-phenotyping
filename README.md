## Dimensional Reduction and Unsupervised Learning for Immune Cell Phenotyping
This repo describes techniques for immune cell phenotyping of non-small cell lung cancer using PCA, tSNE, and other techniques in [R](https://www.r-project.org/) and [FloJo](https://www.flowjo.com/solutions/flowjo). 

Modern single cell analysis techniques capture large amounts of high dimensional data: for example a comprehensive flow cytometry panel can stain cells with dozens of markers and identify numerous cell types. Interpreting this high dimensional data can be challenging. Dimensional reduction techniques can be used to either to analyze raw flow cytometry data (to naively identify cell populations) or to analyze populations identified through traditional gating approaches (to identify population changes between groups).

These techniques can be used to simplify complex high dimensional data and identify novel cell populations, such as interferon gamma producing immune cells in immune cells isolated from non-small cell lung cancer (NSCLC) tumors.

![3d render of IFN gamma expression overlayed onto a tSNE plot of a concatenated NSCLC tumor and non-adjacent lung sample](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/IFNgamma_animated.gif)

# specific techniques for dimensional reduction
- [Principle Component Analysis (PCA)](https://en.wikipedia.org/wiki/Principal_component_analysis) is a linear dimensional reduction algorithm. PCA preserves the global structure of the data but not local structure: PCA places dissimilar points far apart but when reducing high dimensional data to a low dimension manifold similar points are not placed close together.
- [Hierarchical Clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering)
- [t-Distributed Stochastic Neighbor Embedding (tSNE)](https://en.wikipedia.org/wiki/T-distributed_stochastic_neighbor_embedding) is an non-linear algorithm for performing dimensionality reduction, allowing visualization of complex multi-dimensional data in fewer dimensions while still maintaining the structure of the data. tSNE is able to preserve *BOTH* the local and global structures of the data.
For a complete description of the underlying algorithm, see [here](https://www.analyticsvidhya.com/blog/2017/01/t-sne-implementation-r-python/)

# Principle Component Analysis (PCA)
I examined a dataset of samples obtained from individuals undergoing surgical resection of NSCLC; these samples were processed fresh into a single cell suspension and stained with a panel of >30 antibodies against surface and intracellular antigens and >50,000 events were obtained by flow cytometry. 

Overlapping immune cell phenotypes of tumor and lung samples
![overlapping immune phenotypes of tumor and lung samples](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/lung%20tumor.png)

With Eigenvectors shown
![overlapping immune phenotypes of tumor and lung samples with Eigenvectors](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/lung%20tumor%20w%20eigenvectors.png)

# t-Distributed Stochastic Neighbor Embedding (tSNE)
Paired immune cell populations (CD45+) from lung tumor and non-tumor adjacent lung were concatenated (50,000 events from each sample) and analyzed using tSNE. Specific immune cell populations can be labeled according to origin (lung vs tumor), immune effector cell type (CD4+, CD8+, gamma delta TCR+), or intracellular cytokine production (interferon gamma, IL-17a, etc).

![t-Distributed Stochastic Neighbor Embedding demonstrates overlapping immune cell populations in paired NSCLC and lung samples](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/27-Jul-2017-Layout.png)

![Another example using different samples](https://github.com/nickmmark/immune-phenotyping/blob/master/figures/27-Jul-2017-Layout.png)

# Other examples

## version/to do
current version 0.1.0 - this is a work in progress

## references
- Thorsson V et al, [The Immune Landscape of Cancer](https://www.ncbi.nlm.nih.gov/pubmed/29628290), Immunity. 2018
- Mark NM et al, [Chronic Obstructive Pulmonary Disease Alters Immune Cell Composition and Immune Checkpoint Inhibitor Efficacy in Non-Small Cell Lung Cancer](https://www.ncbi.nlm.nih.gov/pubmed/28934595), AJRCCM 2018
- [FloJo tSNE documentation](http://docs.flowjo.com/d2/advanced-features/dimensionality-reduction/tsne/)
- [Comprehensive Guide on t-SNE algorithm with implementation in R & Python](https://www.analyticsvidhya.com/blog/2017/01/t-sne-implementation-r-python/)
