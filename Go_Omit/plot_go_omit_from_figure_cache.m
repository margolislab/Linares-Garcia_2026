
function plot_go_omit_from_figure_cache(figureCacheFile, outputDir)
% PLOT_GO_OMIT_FROM_FIGURE_CACHE
%
% Redraw manuscript figures from the compact figure cache created by:
%   export_go_omit_figure_cache_from_workspace.m
%
% Example:
%   plot_go_omit_from_figure_cache('go_omit_figure_cache.mat');

if nargin < 1 || isempty(figureCacheFile)
    figureCacheFile = 'go_omit_figure_cache.mat';
end

if nargin < 2 || isempty(outputDir)
    outputDir = 'figures_from_go_omit_cache';
end

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

S = load(figureCacheFile, 'figureCache');
figureCache = S.figureCache;

M = figureCache.meta;
assocNames = M.assocNames;
perfNames = M.perfNames;
assocLabels = M.assocLabels;
catNames = M.catNames;
catColors = M.catColors;
timeVec = M.timeVec;

fprintf('\n[PlotCache] Plotting figures from %s\n', figureCacheFile);

%% Fig. 3C/F stacked category composition
if isfield(figureCache, 'Fig3C_F_stacked')
    cols5 = [0.70 0.85 1.00; 1.00 0.80 0.60; 0.75 0.90 0.70; 0.85 0.75 0.95; 0.80 0.80 0.80];

    for pf = 1:numel(perfNames)
        perf = perfNames{pf};
        D = figureCache.Fig3C_F_stacked.(perf);

        h = figure('Name', ['Fig3C/F stacked - ' perf], 'Color','w', 'Position',[200 200 1100 460]);
        x = 1:numel(D.days);
        B = bar(x, D.percPlot', 'stacked', 'BarWidth', 0.75);
        for k = 1:5
            B(k).FaceColor = cols5(k,:);
            B(k).EdgeColor = 'none';
        end
        xticks(x); xticklabels(D.days);
        xlabel('Day');
        ylabel('Percentage of all neurons (%)');
        title(sprintf('%s: functional categories (overall p=%.3g)', D.assocLabel, D.p_all));
        ylim([0 100]); grid on;
        legend(D.catNames, 'Location','northeastoutside');

        for d = 1:numel(D.days)
            text(x(d), 102, sprintf('N=%d', D.Ntotal(d)), 'HorizontalAlignment','center','FontSize',8);
        end
        saveas(h, fullfile(outputDir, sprintf('Fig3C_F_stacked_%s.png', perf)));
    end
end

%% Fig. 2B/F modulated neurons per animal
if isfield(figureCache, 'Fig2B_F_modulated')
    D = figureCache.Fig2B_F_modulated;
    h = figure('Name','Fig2B/F modulated per animal', 'Color','w', 'Position',[100 100 1200 500]);
    colors = lines(numel(D.mouseList));

    for aIdx = 1:numel(perfNames)
        assocField = perfNames{aIdx};
        subplot(1,2,aIdx); hold on;
        for m = 1:numel(D.mouseList)
            plot(1:numel(D.days), D.(assocField).pct(m,:), '-o', ...
                'Color', colors(m,:), 'DisplayName', D.mouseList{m}, 'LineWidth',1.2);
        end
        hold off;
        xticks(1:numel(D.days)); xticklabels(D.days);
        xlabel('Day'); ylabel('% Modulated');
        title([assocField ' - % modulated'], 'Interpreter','none');
        legend('Location','best'); ylim([0 100]); grid on;
    end
    saveas(h, fullfile(outputDir, 'Fig2B_F_modulated_per_animal.png'));
end

%% Fig. 3G/H pathway per animal by association
% This plotting block matches the paper code: for each mouse/day, the
% numerator is pathway-specific modulated neurons and the denominator is all
% neurons from that mouse/day.
if isfield(figureCache, 'Fig3G_H_pathway_per_animal_paper')
    D = figureCache.Fig3G_H_pathway_per_animal_paper;
    colors = D.colors;

    assocPlot = {'firstAssociation','secondAssociation'};
    assocTitle = {'FirstAssoc','SecondAssoc'};
    fileName = {'Fig3G_pathway_firstAssociation.png','Fig3H_pathway_secondAssociation.png'};

    for aIdx = 1:numel(assocPlot)
        assocField = assocPlot{aIdx};
        if ~isfield(D, assocField), continue; end

        h = figure('Name', ['% D1 vs A2a - ' assocTitle{aIdx}], ...
            'Color','w', 'Position',[100 100 1000 400]);

        for g = 1:2
            gLabel = D.labels{g};
            subplot(1,2,g); hold on;

            for m = 1:numel(D.mouseList)
                pct = D.(assocField).(gLabel).pct(m,:);
                plot(1:numel(D.days), pct, '-o', ...
                    'Color', colors(g,:), 'LineWidth',1.2, 'DisplayName', D.mouseList{m});
            end

            hold off;
            xticks(1:numel(D.days));
            xticklabels(D.days);
            xlabel('Day');
            ylabel('% of Modulated');
            title([assocTitle{aIdx} ': % ' gLabel]);
            legend('Location','best');
            grid on;
        end

        saveas(h, fullfile(outputDir, fileName{aIdx}));
    end
elseif isfield(figureCache, 'Fig3G_H_pathway_per_animal')
    warning('Using older Fig3G/H cache. Regenerate cache to match the paper denominator exactly.');
end

%% Fig. 3A/D selected examples
if isfield(figureCache, 'Fig3A_D_examples')
    D = figureCache.Fig3A_D_examples;
    h = figure('Name','Fig3A/D example neurons', 'Color','w', 'Position',[50 50 1600 800]);
    plotIdx = 0;

    for i = 1:numel(D.rows)
        R = D.rows(i);
        plotIdx = plotIdx + 1;

        subplot(2,8,plotIdx);
        imagesc(timeVec, 1:size(R.dataRaw,1), R.dataRaw);
        set(gca,'YDir','normal');
        colormap('winter'); caxis([-1 2]);
        hold on; plot_event_lines(M); hold off;
        title(sprintf('%s %s neuron %d', R.associationLabel, R.category, R.neuronIndex));
        xlabel('Time (s)'); ylabel('Trial'); colorbar;

        subplot(2,8,plotIdx+8); hold on;
        fill([timeVec fliplr(timeVec)], [R.muRaw+R.semRaw fliplr(R.muRaw-R.semRaw)], ...
            [0.8 0.8 0.8], 'EdgeColor','none');
        plot(timeVec, R.muRaw, 'k-', 'LineWidth',1.5);
        plot_event_lines(M);
        hold off;
        title('Mean ± SEM');
        xlabel('Time (s)'); ylabel('\DeltaF/F');
    end

    saveas(h, fullfile(outputDir, 'Fig3A_D_example_neurons.png'));
end

%% AUROC heatmaps and mean traces
if isfield(figureCache, 'SuppFig3B_Fig3E_AUROC')
    for pf = 1:numel(perfNames)
        perf = perfNames{pf};
        h = figure('Name', ['AUROC heatmaps - ' perf], 'Color','w', 'Position',[50 50 2000 800]);

        for a = 1:numel(assocNames)
            day = assocNames{a};
            D = figureCache.SuppFig3B_Fig3E_AUROC.(perf).(day);

            subplot(2,numel(assocNames),a);
            imagesc(timeVec, 1:size(D.Msort,1), D.Msort);
            set(gca,'YDir','normal');
            colormap('jet'); caxis([0.4 0.6]);
            hold on;
            plot_event_lines(M);
            sep = cumsum(D.counts) + 0.5;
            for s = 1:3
                plot([timeVec(1) timeVec(end)], [sep(s) sep(s)], 'k', 'LineWidth',1.5);
            end
            hold off;
            title({['Day ' day], sprintf('Sound(%d)',D.counts(1)), sprintf('Action(%d)',D.counts(2)), ...
                sprintf('Outcome(%d)',D.counts(3)), sprintf('Mixed(%d)',D.counts(4))});
            if a==1, ylabel('Neurons'); end
            xlabel('Time (s)'); colorbar;

            subplot(2,numel(assocNames),numel(assocNames)+a); hold on;
            for c = 1:4
                mu = D.meanAbsAUROC(c,:);
                se = D.semAbsAUROC(c,:);
                fill([timeVec fliplr(timeVec)], [mu+se fliplr(mu-se)], catColors(c,:), ...
                    'FaceAlpha',0.3, 'EdgeColor','none');
                plot(timeVec, mu, 'Color',catColors(c,:), 'LineWidth',1.5);
            end
            plot_event_lines(M);
            hold off;
            ylim([0.48 0.8]);
            if a==1, ylabel('abs-auROC'); end
            xlabel('Time (s)');
            title(['Day ' day]);
        end

        saveas(h, fullfile(outputDir, sprintf('SuppFig3B_Fig3E_AUROC_%s.png', perf)));
    end
end

%% Fig. 4 peak metrics
if isfield(figureCache, 'Fig4_peakMetrics')
    for a = 1:numel(perfNames)
        assoc = perfNames{a};
        h = figure('Name', ['Fig4 peak metrics - ' assoc], 'Color','w', 'Position',[100 100 1100 900]);

        for c = 1:numel(catNames)
            catName = catNames{c};
            peaksAU = cell(1,numel(assocNames));
            peaksDF = cell(1,numel(assocNames));

            for d = 1:numel(assocNames)
                day = assocNames{d};
                peaksAU{d} = figureCache.Fig4_peakMetrics.(assoc).(catName).(day).peaksAU;
                peaksDF{d} = figureCache.Fig4_peakMetrics.(assoc).(catName).(day).peaksDF;
            end

            subplot(numel(catNames),2,(c-1)*2+1);
            plot_metric(peaksAU, assocNames, [0.5 1], 'Peak abs-auROC', [assoc ' - ' catName ' AUROC']);

            subplot(numel(catNames),2,(c-1)*2+2);
            plot_metric(peaksDF, assocNames, [], 'Peak dF/F', [assoc ' - ' catName ' dF/F']);
        end

        saveas(h, fullfile(outputDir, sprintf('Fig4_peak_metrics_%s.png', assoc)));
    end
end

%% Fig. 4B/E confirmed pathway
if isfield(figureCache, 'Fig4B_E_confirmedPathway')
    for pf = 1:numel(perfNames)
        perf = perfNames{pf};
        h = figure('Name', ['Fig4B/E confirmed pathway - ' perf], 'Color','w', 'Position',[100 100 900 900]);
        sgtitle(['Confirmed D1/A2a - ' perf], 'Interpreter','none');

        for c = 1:numel(catNames)
            D = figureCache.Fig4B_E_confirmedPathway.(perf).(catNames{c});

            subplot(numel(catNames),1,c); hold on;
            xD1 = 1:numel(assocNames);
            xA2 = xD1 + (numel(assocNames)+1);

            bar(xD1, D.pctD1, 0.8, 'FaceColor',[0.85 0.35 0.35], 'EdgeColor','none');
            bar(xA2, D.pctA2, 0.8, 'FaceColor',[0.35 0.35 0.85], 'EdgeColor','none');

            xticks([xD1 xA2]); xticklabels([assocNames assocNames]); xtickangle(45);
            ylabel('% neurons'); title(catNames{c});
            legend({'Identified D1','Identified A2a'}, 'Location','northeastoutside');
            ylim([0 100]); grid on; hold off;
        end

        saveas(h, fullfile(outputDir, sprintf('Fig4B_E_confirmed_pathway_%s.png', perf)));
    end
end

%% Fig. 2A/E rewarded/omit heatmaps
if isfield(figureCache, 'Fig2A_E_SuppFig1D_E_rewardOmit')
    for aIdx = 1:numel(perfNames)
        assocField = perfNames{aIdx};
        h = figure('Name', ['Reward/omit - ' assocField], 'Color','w', 'Position',[100 100 1200 700]);

        for d = 1:numel(assocNames)
            day = assocNames{d};
            D = figureCache.Fig2A_E_SuppFig1D_E_rewardOmit.(assocField).(day);

            subplot(2,numel(assocNames),d);
            imagesc(timeVec, 1:size(D.H,1), D.H);
            set(gca,'YDir','reverse');
            colormap('jet'); caxis(M.cax);
            title([D.assocLabel ' Day ' day]);
            if d==1, ylabel('Neurons'); end
            xlabel('Time (s)');
            hold on;
            if D.numUnmod_kept > 0 && D.numUnmod_kept < D.Nneur_kept
                plot(xlim, [D.numUnmod_kept+0.5 D.numUnmod_kept+0.5], 'k', 'LineWidth',1.5);
            end
            xline(M.toneSec,'--k'); xline(M.moveSec,'--k'); xline(M.outcomeSec,'--k');
            hold off;

            subplot(2,numel(assocNames),numel(assocNames)+d); hold on;
            plot_cached_mean(timeVec, D.mu_mod, D.sem_mod, [0.65 0.65 0.65], [0 0 0], '-', 'MOD Rew');
            plot_cached_mean(timeVec, D.mu_un, D.sem_un, [0.60 0.70 1.00], [0.20 0.30 0.90], '-', 'UNMOD Rew');
            plot_cached_mean(timeVec, D.mu_mod_omit, D.sem_mod_omit, [1.00 0.65 0.65], [0.90 0.10 0.10], '--', 'MOD Omit');
            xline(M.toneSec,'--k'); xline(M.moveSec,'--k'); xline(M.outcomeSec,'--k');
            if d==1, ylabel('Mean robust z ± SEM'); end
            xlabel('Time (s)');
            title(sprintf('MOD=%d, UNMOD=%d, OMIT=%d', D.n_mod, D.n_unmod, D.n_omit));
            legend('Location','northwest','Box','off');
            hold off;
        end

        saveas(h, fullfile(outputDir, sprintf('Fig2A_E_SuppFig1D_E_rewardOmit_%s.png', assocField)));
    end
end

%% Supplementary Fig. 3B/F similarity slope
if isfield(figureCache, 'SuppFig3B_F_similaritySlope')
    D = figureCache.SuppFig3B_F_similaritySlope;
    h = figure('Name','Similarity slope summary', 'Color','w', 'Position',[100 100 1400 600]);
    tiledlayout(2,4,'Padding','compact','TileSpacing','compact');
    colors = lines(4);

    for a = 1:numel(perfNames)
        for c = 1:4
            nexttile((a-1)*4 + c); hold on;
            for d = 1:numel(assocNames)
                y = D.rhoData(:,d,c,a);
                mu = mean(y,'omitnan');
                sem = std(y,'omitnan') ./ sqrt(sum(~isnan(y)));
                errorbar(d, mu, sem, 'o-', 'Color', colors(c,:), 'LineWidth',1.5);
            end
            xlim([0.5 numel(assocNames)+0.5]); ylim([-1 1]);
            xticks(1:numel(assocNames)); xticklabels(assocNames);
            if c==1, ylabel(sprintf('%s\nSpearman \\rho', assocLabels{a})); end
            title(catNames{c}); hold off;
        end
    end

    saveas(h, fullfile(outputDir, 'SuppFig3B_F_similaritySlope.png'));
end

%% Supplementary Fig. 1A/E corr-distance scatter
if isfield(figureCache, 'SuppFig1A_E_corrDistance')
    h = figure('Name','Corr distance scatter', 'Color','w', 'Position',[100 100 1200 600]);

    for a = 1:numel(perfNames)
        assoc = perfNames{a};
        for c = 1:4
            D = figureCache.SuppFig1A_E_corrDistance.(assoc).(catNames{c});
            subplot(2,4,(a-1)*4+c); hold on; grid on;

            try
                scatter(D.distance, D.similarity, 10, 'filled', ...
                    'MarkerFaceAlpha',0.25, 'MarkerEdgeColor','none');
            catch
                plot(D.distance, D.similarity, '.', 'MarkerSize',8);
            end

            if numel(D.distance) > 50
                [xs,ord] = sort(D.distance);
                ys = D.similarity(ord);
                span = max(5, round(numel(ys)/50));
                yy = smoothdata(ys, 'rlowess', span);
                plot(xs, yy, 'LineWidth',2);
            end

            if numel(D.distance) >= 2
                xfit = [min(D.distance) max(D.distance)];
                yfit = polyval([D.slope D.intercept], xfit);
                plot(xfit, yfit, 'k-', 'LineWidth',1.8);
            end

            xlabel('Distance'); ylabel('Correlation');
            title(sprintf('%s - %s (n=%d)\nr=%.3f, p=%.3g, slope=%.4f', ...
                assocLabels{a}, catNames{c}, D.nPlotted, D.rPearson, D.pPearson, D.slope));
            xlim([0 300]); ylim([-1 1]); hold off;
        end
    end

    saveas(h, fullfile(outputDir, 'SuppFig1A_E_corrDistanceScatter.png'));
end

%% Supplementary Fig. 1C movement-onset neural versus joystick
if isfield(figureCache, 'SuppFig1C_movementOnset')
    Dall = figureCache.SuppFig1C_movementOnset;
    assocFieldsMO = Dall.assocFields;

    h = figure('Name','Supplementary Fig. 1C movement onset', ...
        'Color','w', 'Position',[80 80 1200 560]);

    for a = 1:numel(assocFieldsMO)
        assoc = assocFieldsMO{a};
        if ~isfield(Dall, assoc), continue; end

        D = Dall.(assoc);

        subplot(2,2,(a-1)*2+1); hold on;
        fill([D.tCommon fliplr(D.tCommon)], [D.js_mu+D.js_sem fliplr(D.js_mu-D.js_sem)], ...
            [0.75 0.9 1.0], 'FaceAlpha',0.35,'EdgeColor','none');
        plot(D.tCommon, D.js_mu, 'b-', 'LineWidth',1.8);

        fill([D.tCommon fliplr(D.tCommon)], [D.ne_mu+D.ne_sem fliplr(D.ne_mu-D.ne_sem)], ...
            [0.8 0.8 0.8], 'FaceAlpha',0.35,'EdgeColor','none');
        plot(D.tCommon, D.ne_mu, 'k-', 'LineWidth',1.8);

        xline(0,'--','Color',[0.2 0.2 0.2]);
        xlabel('Time from movement onset (s)');
        ylabel('z-scored amplitude');
        title(sprintf('%s — %s (N=%d)', D.assocLabel, D.day, D.nAnimals));
        legend({'JS \pm SEM','JS mean','Neural \pm SEM','Neural mean'}, 'Location','best');
        grid on; box off; hold off;

        subplot(2,2,(a-1)*2+2); hold on;
        plot(D.lagsSec, D.xc_med, 'k-', 'LineWidth',1.8);
        yline(0,'k:'); xline(0,'k:');
        plot(D.lagpk_med_sec, D.rpk_med, 'ro', 'MarkerFaceColor','r');
        xlabel('Lag (s)  [JS leads (+) / Neural leads (–)]');
        ylabel('Cross-correlation (median across animals)');
        title(sprintf('Peak r=%.3f at %.3f s', D.rpk_med, D.lagpk_med_sec));
        grid on; box off; hold off;
    end

    saveas(h, fullfile(outputDir, 'SuppFig1C_movement_onset_neural_vs_joystick.png'));
end

fprintf('[PlotCache] Done. Figures saved in: %s\n', outputDir);

end

%% Helpers

function plot_event_lines(M)
yl = ylim;
plot([M.toneFrame/16 M.toneFrame/16], yl, 'k--');
plot([M.moveFrame/16 M.moveFrame/16], yl, 'k--');
plot([M.outcomeFrame/16 M.outcomeFrame/16], yl, 'k--');
end

function plot_metric(valuesByDay, dayLabels, yLimits, yLabel, titleStr)
nDays = numel(valuesByDay);
mu = nan(1,nDays);
se = nan(1,nDays);

for d = 1:nDays
    x = valuesByDay{d};
    x = x(:);
    x = x(isfinite(x));
    if isempty(x)
        mu(d) = NaN;
        se(d) = NaN;
    else
        mu(d) = mean(x, 'omitnan');
        se(d) = std(x, 0, 'omitnan') / sqrt(numel(x));
    end
end

errorbar(1:nDays, mu, se, '-o', 'LineWidth',1.5);
xlim([0.5 nDays+0.5]);
if ~isempty(yLimits), ylim(yLimits); end
xticks(1:nDays); xticklabels(dayLabels);
ylabel(yLabel); title(titleStr, 'Interpreter','none'); grid on;
end

function plot_cached_mean(timeVec, mu, sem, fillColor, lineColor, lineStyle, labelStr)
if isempty(mu) || all(isnan(mu)), return; end
fill([timeVec fliplr(timeVec)], [mu+sem fliplr(mu-sem)], fillColor, ...
    'FaceAlpha',0.25, 'EdgeColor','none', 'HandleVisibility','off');
plot(timeVec, mu, 'Color',lineColor, 'LineStyle',lineStyle, 'LineWidth',1.5, 'DisplayName',labelStr);
end
