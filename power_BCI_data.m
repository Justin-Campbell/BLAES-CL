function power = power_BCI_data(signal, f_window)
% 
% power_BCI_data calculates power for preprocessed BCI2000-style data. 
%
% ArgIn: 
%    - signal: preprocessed signal generated from prepro_BCI_data.m [time x channel x epoch]
%    - f_window: frequency band for power calculation [2 x 1]

% ArgOut:
%    - power [time x channel matrix]
%
% Author:    Justin Campbell
% Contact:   justin.campbell@hsc.utah.edu 
% Version:   03-09-2022
%
%% 

global Fs;

%%
d = designfilt('bandpassiir','FilterOrder', 4, ...
        'HalfPowerFrequency1',f_window(1),'HalfPowerFrequency2', f_window(2), ...
        'SampleRate',Fs); % butterworth filter

filt_signal = filtfilt(d, signal);
power = abs(hilbert(filt_signal)).^2; % hilbert transform

%%

end