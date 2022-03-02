function [idxs, epochs] = epoch_BCI_data(states, parameters, start_code, end_code, pad)
% 
% epoch_BCI_data finds the index which marks the transition between two
% stimulus codes and creates an epoch around that transition.
%
% ArgIn: 
%    - states, state information generated from load_BCI_dat.m [1 x 1 struct]
%    - parameters, parameter information generated from load_BCI_dat.m [1 x 1 struct]
%    - start_code, unique BCI2000 code for stimulus [int]
%    - end_code, unique BCI2000 code for stimulus [int]
%    - pad, time (in seconds) to pad around transition [2 x 1 array]
% ArgOut:
%    - idxs, index marking the transition from start_code to end-code [1 x n array]
%    - epochs, indices surrounding transition from start_code to end-code
%    with padding applied before/after [n x 1 cell]
%
% E.G.,:
%    [idxs, epochs] = epoch_BCI_data(states, 1502, 1801, [0, 5]); % find
%    the transition from stim (1502) to ISI (1801) and create an epoch
%    with 5 seconds of padding after end of stim
%
% Author:    Justin Campbell
% Contact:   justin.campbell@hsc.utah.edu 
% Version:   03-01-2022
%% 

% Find Trials
idxs = [];
for sc_idx = 1:length(states.StimulusCode)
    if states.StimulusCode(sc_idx) == end_code; % if stimulus code matches end_code
        if states.StimulusCode(sc_idx - 1) == start_code; % and if previous stimulus code matches start_code
            idxs = [idxs (sc_idx)]; % add index of last sample to array (first instance of end_code, NOT last instance of start_code)
        end
    end
end

% Create epochs w/ padding (in seconds)
epochs = cell(length(idxs),1);
pre_pad = pad(1) * parameters.SamplingRate.NumericValue;
post_pad = pad(2) * parameters.SamplingRate.NumericValue;
for s_idx = 1:length(idxs) % loop through no_stim trials
    if (pre_pad ~= 0) && (post_pad ~= 0) % pad pre- and post-
        epochs{s_idx} = (idxs(s_idx) - post_pad):(idxs(s_idx) + post_pad);
    elseif (pre_pad == 0) && (post_pad ~= 0) % pad post- only
        epochs{s_idx} = idxs(s_idx):(idxs(s_idx) + post_pad);
    elseif (pre_pad ~= 0) && (post_pad == 0) % pad pre- only
        epochs{s_idx} = (idxs(s_idx) - pre_pad):idxs(s_idx);
    else % no padding specified
        error('Need to specify padding (in sec) to create epochs!')
    end
end

% Summarize output
fprintf('Created %d epochs with %ds pre- and %ds post-padding around the transition from %d to %d\n', size(epochs,1), pad(1), pad(2), start_code, end_code);

end