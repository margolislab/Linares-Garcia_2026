function plot_2afc_from_figure_cache(cacheFile, outputDir, openFigures)
% PLOT_2AFC_FROM_FIGURE_CACHE
%
% Restore 2AFC manuscript figures/source tables from a compact cache.
%
% This function does NOT require:
%   NewData2_DAAS
%   params
%   2afcData_Complete.mat
%
% Usage:
%   plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs')
%
% Save outputs but do not open figures:
%   plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs', false)
%
% Save outputs and open figures in MATLAB:
%   plot_2afc_from_figure_cache('twoafc_figure_cache.mat', 'TwoAFC_outputs', true)

if nargin < 1 || isempty(cacheFile)
    cacheFile = 'twoafc_figure_cache.mat';
end

if nargin < 2 || isempty(outputDir)
    outputDir = 'TwoAFC_outputs';
end

if nargin < 3 || isempty(openFigures)
    openFigures = true;
end

if ~exist(cacheFile, 'file')
    error('Could not find cache file: %s', cacheFile);
end

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

S = load(cacheFile, 'cache');
cache = S.cache;

fprintf('\n[2AFC cache plot] Loading cache: %s\n', cacheFile);
fprintf('[2AFC cache plot] Output folder: %s\n', outputDir);

% Restore source tables.
tableDir = fullfile(outputDir, 'source_tables');
if ~exist(tableDir, 'dir'), mkdir(tableDir); end

write_cached_tables(cache.tables.rule, fullfile(tableDir, 'rule_selectivity'));
write_cached_tables(cache.tables.decoder, fullfile(tableDir, 'decoder'));

% Restore saved figure files.
figDir = fullfile(outputDir, 'figures');
if ~exist(figDir, 'dir'), mkdir(figDir); end

write_cached_files(cache.figureFiles.rule, fullfile(figDir, 'rule_selectivity'));
write_cached_files(cache.figureFiles.decoder, fullfile(figDir, 'decoder'));

% Write index file.
write_index_file(cache, outputDir);

% Open figures in MATLAB.
if openFigures
    fprintf('[2AFC cache plot] Opening restored figures in MATLAB...\n');
    open_restored_figures(figDir);
else
    fprintf('[2AFC cache plot] openFigures=false, so figures were saved but not opened.\n');
end

fprintf('[2AFC cache plot] Done.\n');
fprintf('[2AFC cache plot] Restored figures: %s\n', figDir);
fprintf('[2AFC cache plot] Restored source tables: %s\n\n', tableDir);

end

%% ------------------------------------------------------------------------
% Write cached tables and files
% -------------------------------------------------------------------------

function write_cached_tables(tableStruct, outFolder)
if ~exist(outFolder, 'dir'), mkdir(outFolder); end

names = fieldnames(tableStruct);
for i = 1:numel(names)
    item = tableStruct.(names{i});
    if ~isfield(item, 'table') || ~istable(item.table)
        continue;
    end

    outPath = fullfile(outFolder, item.relativePath);
    outSub = fileparts(outPath);
    if ~exist(outSub, 'dir'), mkdir(outSub); end

    writetable(item.table, outPath);
end
end

function write_cached_files(fileStruct, outFolder)
if ~exist(outFolder, 'dir'), mkdir(outFolder); end

names = fieldnames(fileStruct);
for i = 1:numel(names)
    item = fileStruct.(names{i});
    if ~isfield(item, 'bytes')
        continue;
    end

    outPath = fullfile(outFolder, item.relativePath);
    outSub = fileparts(outPath);
    if ~exist(outSub, 'dir'), mkdir(outSub); end

    fid = fopen(outPath, 'w');
    if fid < 0
        warning('Could not write file: %s', outPath);
        continue;
    end
    fwrite(fid, item.bytes, 'uint8');
    fclose(fid);
end
end

function write_index_file(cache, outputDir)
indexFile = fullfile(outputDir, 'README_restored_outputs.txt');
fid = fopen(indexFile, 'w');

if fid < 0
    warning('Could not write output index file.');
    return;
end

fprintf(fid, '2AFC restored outputs\n');
fprintf(fid, '====================\n\n');

if isfield(cache, 'meta') && isfield(cache.meta, 'created')
    fprintf(fid, 'Created from cache generated on: %s\n\n', cache.meta.created);
end

fprintf(fid, 'This output folder was restored from twoafc_figure_cache.mat.\n');
fprintf(fid, 'It does not require NewData2_DAAS, params, or 2afcData_Complete.mat.\n\n');

fprintf(fid, 'Restored folders:\n');
fprintf(fid, '  figures/rule_selectivity/\n');
fprintf(fid, '  figures/decoder/\n');
fprintf(fid, '  source_tables/rule_selectivity/\n');
fprintf(fid, '  source_tables/decoder/\n\n');

if isfield(cache, 'fileList') && isfield(cache.fileList, 'rule')
    fprintf(fid, 'Rule-selectivity files included in cache:\n');
    write_string_list(fid, cache.fileList.rule);
end

if isfield(cache, 'fileList') && isfield(cache.fileList, 'decoder')
    fprintf(fid, '\nDecoder files included in cache:\n');
    write_string_list(fid, cache.fileList.decoder);
end

fclose(fid);
end

function write_string_list(fid, L)
if isempty(L)
    fprintf(fid, '  none\n');
    return;
end

for i = 1:numel(L)
    fprintf(fid, '  %s\n', char(L(i)));
end
end

%% ------------------------------------------------------------------------
% Open restored figures in MATLAB
% -------------------------------------------------------------------------

function open_restored_figures(figDir)
% Open one displayable file per figure.
%
% Priority:
%   .fig first, then .png, .jpg/.jpeg, .tif/.tiff
%
% PDFs are restored to disk, but not opened in MATLAB.

displayFiles = choose_display_files(figDir);

if isempty(displayFiles)
    warning('[2AFC cache plot] No displayable figure files found in: %s', figDir);
    return;
end

for i = 1:numel(displayFiles)
    f = displayFiles{i};
    [~, name, ext] = fileparts(f);
    ext = lower(ext);

    try
        switch ext
            case '.fig'
                openfig(f, 'visible');

            case {'.png', '.jpg', '.jpeg', '.tif', '.tiff'}
                img = imread(f);
                figure('Name', name, 'Color', 'w');
                show_image_in_figure(img);
                title(strrep(name, '_', '\_'), 'Interpreter', 'tex');

            otherwise
                % Skip unsupported formats.
        end
    catch ME
        warning('[2AFC cache plot] Could not open %s: %s', f, ME.message);
    end
end

fprintf('[2AFC cache plot] Opened %d figure window(s).\n', numel(displayFiles));
end

function displayFiles = choose_display_files(figDir)
% Select one file per base name to avoid opening duplicate formats.

patterns = {'*.fig', '*.png', '*.jpg', '*.jpeg', '*.tif', '*.tiff'};
displayFiles = {};
seen = containers.Map('KeyType', 'char', 'ValueType', 'logical');

for p = 1:numel(patterns)
    files = dir(fullfile(figDir, '**', patterns{p}));

    for i = 1:numel(files)
        fullPath = fullfile(files(i).folder, files(i).name);
        relPath = erase(fullPath, [figDir filesep]);
        [subFolder, baseName, ~] = fileparts(relPath);
        baseKey = fullfile(subFolder, baseName);

        if ~isKey(seen, baseKey)
            seen(baseKey) = true;
            displayFiles{end+1} = fullPath; %#ok<AGROW>
        end
    end
end
end

function show_image_in_figure(img)
% Use imshow if available. Otherwise use base MATLAB image().

if exist('imshow', 'file') == 2
    imshow(img);
else
    image(img);
    axis image off;
end
end
