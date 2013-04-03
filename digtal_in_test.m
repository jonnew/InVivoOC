% Author and Date: Ehsan Azar  14 Sept 2009
% Copyright:       Blackrock Microsystems
% Workfile:        RealSpec.m
% Purpose: Realtime spectrum display. All sampled channels are displayed.

close all;
clear variables;

f_disp = 0:0.1:15;       % the range of frequency to show spectrum over.
% Use f_disp = [] if you want the entire spectrum

collect_time = 0.001; % collect samples for this time 0.01
display_period = 0.001; % display spectrum every this amount of time 0.5

cbmex('open'); % open library

proc_fig = figure; % main display
set(proc_fig, 'Name', 'Close this figure to stop');
% xlabel('frequency (Hz)');
% ylabel('magnitude (dB)');


cbmex('trialconfig', 1); % empty the buffer

t_disp0 = tic; % display time
t_col0  = tic; % collection time
bCollect = true; % do we need to collect
 % while the figure is open
 i=1;
 hold on
 xend=0;
 time_and_cont_data={[], []};
while (ishandle(proc_fig))

    if (bCollect)
        %et_col = toc(t_col0); % elapsed time of collection
        %if (et_col >= collect_time)
            tic
            [spike_data, t_buf1, continuous_data] = cbmex('trialdata',1); % read some data
            x=toc;
            if (length(continuous_data)>0)
                time_and_cont_data{2}(end+1)=length(continuous_data{3})+length(spike_data{1,2})+length(spike_data{1,3})+length(spike_data{1,4})+length(spike_data{1,5})+length(spike_data{1,6})+length(spike_data{1,7});
            end
            if (length(continuous_data)>0)
                time_and_cont_data{1}(end+1)=x;
            end
            %nGraphs = size(continuous_data,1); % number of graphs
            % if the figure is still open
%             if(~isempty(spike_data{1,3}))
%                length(spike_data{1,3})
%             end
            if (ishandle(proc_fig))
                if length(continuous_data)>0
                plot((1:length(continuous_data{3}))+xend, continuous_data{3})
                xend=xend+length(continuous_data{3});
                end

                % graph all
%                 for ii=1:nGraphs
%                     % get frquency of sampling
%                     fs0 = continuous_data{ii,2};
%                     % get the ii'th channel data
%                     data = continuous_data{ii,3};
%                     % number of samples to run through fft
%                     collect_size = min(size(data), collect_time * fs0);
%                     x = data(1:collect_size);
%                     if isempty(f_disp)
%                         [psd, f] = periodogram(double(x),[],'onesided',512,fs0);
%                     else
%                         [psd, f] = periodogram(double(x),[],f_disp,fs0);
%                     end
%                     subplot(nGraphs,1,ii,'Parent',proc_fig);
%                     plot(f, 10*log10(psd), 'b');title(sprintf('fs = %d t = %f', fs0, t_buf1));
%                     xlabel('frequency (Hz)');ylabel('magnitude (dB)');
%                 end
                drawnow;
            end
            %bCollect = false;
            i=i+1;
        %end
    end

    %et_disp = toc(t_disp0); % elapsed time since last display
    %if (et_disp >= display_period)
        %t_col0  = tic; % collection time
        %t_disp0 = tic; % restart the period
        %bCollect = true; % start collection
    %end
end
cbmex('close'); % always close
% meanfreq=1/mean(time_and_cont_data{1});
% figure; scatter(time_and_cont_data{1}, time_and_cont_data{2}, 3, 'fill');
% figure; scatter(time_and_size(1).data{1}, time_and_size(1).data{2}, 3, 'fill');
% (1-(length(time_and_cont_data{3})/length(time_and_cont_data{1})))*100
% xlabel('time to call trialdata (s)');
% ylabel('size of sample');


