# Go/Omit Figure Reproduction Code

This folder contains the MATLAB code and compact figure-source data needed to reproduce the Go/Omit manuscript figures.

The original analysis used large MATLAB workspace variables, including:

results
NewData2
trialCodes
clusterResults
newData

Those full variables are not needed to plot the figures from this folder.

Instead, the figures are reproduced from a compact cache file:

go_omit_figure_cache.mat

This cache contains the processed values needed to redraw the final manuscript figures.

------------------------------------------------------------
Folder contents
------------------------------------------------------------

This folder should contain:

Go_Omit/
├── README_Go_Omit_public_code.txt
├── go_omit_figure_cache.mat
└── plot_go_omit_from_figure_cache.m

go_omit_figure_cache.mat

Compact figure-source data file.

This file contains the final processed values used for plotting, including:

- sorted heatmap matrices
- mean ± SEM traces
- selected example-neuron traces
- category percentages
- pathway-composition values
- peak auROC and peak dF/F values
- movement-onset joystick/neural summaries
- downsampled correlation-distance values

plot_go_omit_from_figure_cache.m

Main MATLAB plotting function.

This function reads go_omit_figure_cache.mat and regenerates the manuscript figures.

------------------------------------------------------------
How to run
------------------------------------------------------------

Step 1: Open MATLAB

Open MATLAB and set the current folder to the Go_Omit folder.

For example:

cd('path/to/repository/Go_Omit')

Replace path/to/repository with the actual path on your computer.

Step 2: Confirm the required files are present

Inside the Go_Omit folder, you should see:

go_omit_figure_cache.mat
plot_go_omit_from_figure_cache.m

Step 3: Run the plotting function

From inside the Go_Omit folder, run:

plot_go_omit_from_figure_cache('go_omit_figure_cache.mat', 'Go_Omit_outputs')

This will create a new folder called:

Go_Omit_outputs/

and save the regenerated figures there.

------------------------------------------------------------
What to expect
------------------------------------------------------------

After running the command, MATLAB will generate figures and save them into:

Go_Omit_outputs/

The exact filenames may vary slightly depending on the plotting function, but the folder should include figures related to:

- Fig. 2A/E: rewarded and omission heatmaps/mean traces
- Fig. 2B/F: percentage of modulated neurons per animal
- Fig. 3A/D: selected example neurons
- Fig. 3C/F: functional-category stacked percentages
- Fig. 3G/H: per-animal D1/A2a pathway composition by association
- Fig. 4A/C/D/F: peak abs-auROC and peak dF/F metrics
- Fig. 4B/E: confirmed D1/A2a composition by functional category
- Supplementary Fig. 1A/E: correlation-distance scatter plots
- Supplementary Fig. 1C: movement-onset neural versus joystick comparison
- Supplementary Fig. 1D/E: rewarded/omission summary panels
- Supplementary Fig. 3B/F: similarity slope / Spearman rho summary

During execution, MATLAB may open multiple figure windows. This is expected.

------------------------------------------------------------
Minimal command
------------------------------------------------------------

If you are already inside the Go_Omit folder, the only command needed is:

plot_go_omit_from_figure_cache('go_omit_figure_cache.mat', 'Go_Omit_outputs')

------------------------------------------------------------
Important note about the data
------------------------------------------------------------

The plotting function does not require the original large workspace variables:

results
NewData2
trialCodes
clusterResults
newData

Those variables were only used to create the cache file.

To reproduce the figures from this folder, users only need:

go_omit_figure_cache.mat
plot_go_omit_from_figure_cache.m

------------------------------------------------------------
Troubleshooting
------------------------------------------------------------

Error: cache file not found

If MATLAB gives an error saying it cannot find the cache file, make sure this file exists:

Go_Omit/go_omit_figure_cache.mat

Then run the command again from inside the Go_Omit folder.

Error: function not found

If MATLAB says:

Unrecognized function or variable 'plot_go_omit_from_figure_cache'

make sure the current MATLAB folder is set to Go_Omit, or add the folder to the path:

addpath(genpath('path/to/repository/Go_Omit'))

Output folder already exists

If Go_Omit_outputs/ already exists, MATLAB will save new figures into the same folder. Existing files with the same name may be overwritten.

------------------------------------------------------------
Summary
------------------------------------------------------------

This folder provides a lightweight way to reproduce the Go/Omit manuscript figures from a compact figure-source cache.

Users do not need the original full analysis workspace.
