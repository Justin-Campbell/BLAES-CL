function [processed_signal] = prepro_BCI_data(signal)
% 
% prepro_BCI_data preprocesses BCI2000-style data. 
%
% ArgIn: 
%    - signal: raw signal generated from load_BCI_dat.m [time x channel matrix]
% ArgOut:
%    - processed_signal [time x channel matrix]
%
% Author:    Justin Campbell
% Contact:   justin.campbell@hsc.utah.edu 
% Version:   03-08-2022


%%

global Fs;

%% ID Bad Channels
% remove bad channels
% ranges = [];
% range_cutoff = 5000; % UPDATE?
% for i = 1:length(dat_files)
%     val_range = range(signal{i,1});
%     within_range = val_range < range_cutoff;
%     ranges = [ranges; within_range];
% end
% keep_chans = sum(ranges) > 0;
% fprintf('%d bad channels removed\n', (length(keep_chans) - sum(keep_chans)));
%
%% Re-Referencing
processed_signal = zeros(size(signal));
for i = 1:size(signal,2) % loop through chans
    processed_signal(:,i) = double(signal(:,i)) - double(median(signal,2)); % common median re-reference
end

%% Filtering
[b60,a60] = iirnotch(60/(Fs/2), (60/(Fs/2))/25); % 60Hz IIR filter
[b120,a120] = iirnotch(120/(Fs/2), (120/(Fs/2))/25); % 120Hz IIR filter
[bBand,aBand] = butter(3,[2,249]/(Fs/2)); % 2-249Hz bandpass filter

processed_signal = filtfilt(b60,a60,processed_signal); 
processed_signal = filtfilt(b120,a120,processed_signal);
processed_signal = filtfilt(bBand, aBand, processed_signal);

%%

end