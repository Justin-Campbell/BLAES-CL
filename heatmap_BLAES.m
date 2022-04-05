function heatmap_BLAES(pwr, freqs_labels, chan_labels)
% 
% heatmap_BLAES plots a heatmap of normalized, dB-converted power 
% across all channels and in discrete frequency bands. 
%
% ArgIn: 
%    - pwr: preprocessed signal generated from power_BCI_data.m [time x channel x freq]
%    - freqs_labels: frequency labels (3rd dim of pwr) to use for xticks, [1 x n cell]
%    - chan_labels: channel labels (2nd dim of pwr) to use for yticks [1 x n cell]
% 
% Author:    Justin Campbell
% Contact:   justin.campbell@hsc.utah.edu 
% Version:   04-04-2022
%
%% 

% Heatmap
figure;
h = heatmap(squeeze(median(pwr)));
colormap default;
h.Title = 'Median Power';
h.CellLabelFormat = '%.2f';
h.XLabel = 'Frequency Band';
h.YLabel = 'Channel';
h.XDisplayLabels = freqs_labels;
h.YDisplayLabels = chan_labels;
h.GridVisible = 'off';
set(gcf,'position',[50,50,1250,1250]);
set(findall(h, '-property', 'fontsize'), 'fontsize', 12.5);

end