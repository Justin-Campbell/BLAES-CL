function spectrogram_BLAES(signal)
% 
% spectrogram_BLAES plots a spcectrogram of dB-converted power. 
%
% ArgIn: 
%    - signal: preprocessed signal generated from prepro_BCI_data.m [time x channel x epoch]
% 
% Author:    Justin Campbell
% Contact:   justin.campbell@hsc.utah.edu 
% Version:   04-04-2022
%
%% 
global Fs;

% Wavelet-based power
[WAVE, PERIOD, SCALE, COI] = basewaveERP(signal, Fs, 1, 250, 6, 0);

% Get timevector and frequencies
tvecs = linspace(0, length(WAVE)/Fs, length(WAVE));
freqs = SCALE .^ -1;

% Plot spectrogram
h = imagesc(tvecs, freqs, 10 * log10(abs(WAVE)));
set(gca, 'Yscale', 'log')
axis xy;
ylabel('Frequency (Hz)')
xlabel('Time (sec)')
set(gcf,'position',[50,50,1250,1250]);
set(findall(h, '-property', 'fontsize'), 'fontsize', 12.5);

% Add colorbar
hcb = colorbar;
colorTitleHandle = get(hcb,'Title');
set(colorTitleHandle ,'String','Power (dB)');

end