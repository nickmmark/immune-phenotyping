# immune-phenotyping using unsupervised learning
This repo describes techniques for immune cell phenotyping of non-small cell lung cancer using PCA, tSNE, and other techniques in R.

# background
Modern single cell analysis techniques capture large amounts of high dimensional data: for example a comprehensive flow cytometry panel can stain cells with dozens of markers and identify numerous cell types. Interpreting this high dimensional data can be challenging. Dimensional reduction techniques can be used to either to analyze raw flow cytometry data (to naively identify cell populations) or to analyze populations identified through traditional gating approaches (to identify population changes between groups).
[more background and details needed]

# specific techniques for dimensional reduction
- [Principle Component Analysis (PCA)](https://en.wikipedia.org/wiki/Principal_component_analysis)
- [t-Distributed Stochastic Neighbor Embedding (tSNE)](https://en.wikipedia.org/wiki/T-distributed_stochastic_neighbor_embedding)
- [Hierarchical Clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering)

# examples
I examined a dataset of samples obtained from individuals undergoing surgical resection of NSCLC; these samples were processed fresh into a single cell suspension and stained with a panel of >30 antibodies against surface and intracellular antigens and >50,000 events were obtained by flow cytometry. 

![GitHub Logo](/images/logo.png)

# version/to do
current version 0.1.0 - this is a work in progress

# references
Mark NM et al, [Chronic Obstructive Pulmonary Disease Alters Immune Cell Composition and Immune Checkpoint Inhibitor Efficacy in Non-Small Cell Lung Cancer](https://www.ncbi.nlm.nih.gov/pubmed/28934595), AJRCCM 2018
