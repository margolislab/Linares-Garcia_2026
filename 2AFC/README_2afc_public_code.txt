# 2AFC Figure Cache Workflow

This folder contains a cache-based workflow for the 2AFC manuscript figures.

The original file:

2afcData_Complete.mat

is large and should not be uploaded to GitHub. Instead, the heavy analysis is run once from the MATLAB workspace, and the generated manuscript source tables and figures are saved into a compact cache:

twoafc_figure_cache.mat

Public users can restore the manuscript outputs from this cache without loading the full 2AFC data file.

------------------------------------------------------------
Required files
------------------------------------------------------------

For generating the cache internally:

make_2afc_figure_cache_from_workspace.m
DAAS_rule_selectivity_suite_public_standalone.m
DAAS_rule_decoder_part2_public_standalone.m

For public users:

twoafc_figure_cache.mat
plot_2afc_from_figure_cache.m

------------------------------------------------------------
Internal/lab workflow: create the cache
------------------------------------------------------------

Use this only if you have the full 2AFC data loaded in MATLAB.

Step 1: Load your full data file in MATLAB.

For example:

load('2afcData_Complete.mat')

Step 2: Confirm that these variables exist in the workspace:

NewData2_DAAS
params

Step 3: Make sure these functions are on the MATLAB path:

DAAS_rule_selectivity_suite_public_standalone.m
DAAS_rule_decoder_part2_public_standalone.m
make_2afc_figure_cache_from_workspace.m

Step 4: Run:

cache = make_2afc_figure_cache_from_workspace('twoafc_figure_cache.mat');

This creates:

twoafc_figure_cache.mat

and a temporary output folder:

twoafc_cache_build_outputs/

The cache contains the generated source tables and figure files, but not the full NewData2_DAAS structure.

------------------------------------------------------------
Public workflow: restore figures and source tables
------------------------------------------------------------

Public users do not need:

2afcData_Complete.mat
NewData2_DAAS
params

They only need:

twoafc_figure_cache.mat
plot_2afc_from_figure_cache.m

From inside the 2AFC folder, run:

plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs')

This creates:

TwoAFC_outputs/

with two main folders:

TwoAFC_outputs/figures/
TwoAFC_outputs/source_tables/

------------------------------------------------------------
What the 2AFC code outputs
------------------------------------------------------------

The rule-selectivity analysis reproduces manuscript panels including:

Fig. 7A
Pooled heatmap of rule-selective activity.

Fig. 7B / Fig. 7F
Pooled summary of rule-selective neurons.

Supplementary Fig. 5B
Per-day heatmap grid of rule-selective activity.

Supplementary Fig. 5G
Pathway composition comparison between Rule 1 and Rule 2 neurons.

Supplementary Fig. 5H
Pathway composition slope across days.

Supplementary Fig. 7C / Supplementary Fig. 7G
Sound-window versus early-post-sound category composition.

Fig. 8E
Pairwise response-correlation versus spatial-distance scatter plot.

Fig. 8F
Correlation-distance effect size across learning days.

Fig. 8G
Cross-day stability comparison between rule categories and same-cell matched traces.

The decoder analysis reproduces manuscript panels including:

Fig. 7D / Fig. 7H
Decoder AUC across learning days using all neurons.

Fig. 7E / Fig. 7I
Sound-window versus early-post-sound decoder AUC for rule-preferring and non-rule task-modulated neurons.

Supplementary Fig. 5D / Supplementary Fig. 5F
Per-day decoder AUC bars for Rule1, Rule2, and NonRule categories.

download link in the README.

------------------------------------------------------------
Minimal public command
------------------------------------------------------------

plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs')

------------------------------------------------------------
Summary
------------------------------------------------------------

The full 2AFC data file is only needed once to create the cache.

The public GitHub version should use the compact cache file.
