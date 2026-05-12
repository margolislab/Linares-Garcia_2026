# 2AFC Figure Plotting Instructions

This folder contains the files needed to restore and view the 2AFC manuscript figures from a compact cache file.

You do not need the original full data file to plot the figures.

You do not need:

2afcData_Complete.mat
NewData2_DAAS
params

You only need:

twoafc_figure_cache.mat
plot_2afc_from_figure_cache.m

------------------------------------------------------------
1. Download the cache file
------------------------------------------------------------

Download the figure cache from:

https://drive.google.com/file/d/14_9XQxzqLzC1q5xak7snZWr7EblrUvRd/view?usp=sharing

The downloaded file should be named:

twoafc_figure_cache.mat

Place it inside the 2AFC folder.

Your folder should look like this:

2AFC/
├── README_2afc_public_code.txt
├── plot_2afc_from_figure_cache.m
└── twoafc_figure_cache.mat

The other MATLAB files in this folder are included for transparency, but they are not required if you only want to plot the figures from the cache.

------------------------------------------------------------
2. Open MATLAB
------------------------------------------------------------

Open MATLAB and set the current folder to the 2AFC folder.

For example:

cd('path/to/repository/2AFC')

Replace path/to/repository with the actual path on your computer.

------------------------------------------------------------
3. Plot the figures
------------------------------------------------------------

Run this command:

plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs')

This will:

1. Restore the figure files.
2. Restore the source tables.
3. Open the figures in MATLAB windows.
4. Save everything into a new folder called TwoAFC_outputs.

------------------------------------------------------------
4. Where the outputs are saved
------------------------------------------------------------

After the command runs, a new folder will be created:

TwoAFC_outputs/

Inside it, you should see:

TwoAFC_outputs/figures/
TwoAFC_outputs/source_tables/
TwoAFC_outputs/README_restored_outputs.txt

The figures folder contains the restored manuscript figure files.

The source_tables folder contains the source tables used to generate or document the figure outputs.

------------------------------------------------------------
5. Optional commands
------------------------------------------------------------

To plot and open the figures in MATLAB:

plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs', true)

To restore the files without opening figure windows:

plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs', false)

------------------------------------------------------------
6. What figures are included
------------------------------------------------------------

The cache restores 2AFC manuscript outputs related to rule selectivity, decoder performance, pathway composition, spatial correlation-distance structure, and cross-day stability.

The restored outputs include panels associated with:

Fig. 7A
Pooled heatmap of rule-selective activity.

Fig. 7B / Fig. 7F
Pooled summary of rule-selective neurons.

Fig. 7D / Fig. 7H
Decoder AUC across learning days using all neurons.

Fig. 7E / Fig. 7I
Sound-window versus early-post-sound decoder AUC for rule-preferring and non-rule task-modulated neurons.

Fig. 8E
Pairwise response-correlation versus spatial-distance scatter plot.

Fig. 8F
Correlation-distance effect size across learning days.

Fig. 8G
Cross-day stability comparison between rule categories and same-cell matched traces.

Supplementary Fig. 5B
Per-day heatmap grid of rule-selective activity.

Supplementary Fig. 5D / Supplementary Fig. 5F
Per-day decoder AUC bars for Rule1, Rule2, and NonRule categories.

Supplementary Fig. 5G
Pathway composition comparison between Rule 1 and Rule 2 neurons.

Supplementary Fig. 5H
Pathway composition slope across days.

Supplementary Fig. 7C / Supplementary Fig. 7G
Sound-window versus early-post-sound category composition.

------------------------------------------------------------
7. Troubleshooting
------------------------------------------------------------

If MATLAB says it cannot find the cache file, check that this file exists:

2AFC/twoafc_figure_cache.mat

If MATLAB says the function is not recognized, make sure the current MATLAB folder is the 2AFC folder.

You can also add the folder to the MATLAB path:

addpath(genpath('path/to/repository/2AFC'))

If the output folder already exists, MATLAB may write new files into the same folder.

------------------------------------------------------------
Summary
------------------------------------------------------------

To plot the 2AFC figures, download twoafc_figure_cache.mat, place it inside the 2AFC folder, open MATLAB in that folder, and run:

plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs')
