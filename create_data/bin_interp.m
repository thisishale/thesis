function [asl_ms_log, cc]= bin_interp(upcount, lwcount, ...
    upthr, lwthr, Margin, tol)

if (tol < 0)
    tol = -tol;
end

% Check if extreme counts are not already the true active value
iterno = 1;
if (abs(upcount - upthr - Margin) < tol)
    asl_ms_log= upcount;
    cc= upthr;
    return;
end
if (abs(lwcount - lwthr - Margin) < tol)
    asl_ms_log= lwcount;
    cc= lwthr;
    return;
end

% Initialize first middle for given (initial) bounds 
midcount = (upcount + lwcount) / 2.0;
midthr = (upthr + lwthr) / 2.0;

% Repeats loop until `diff' falls inside the tolerance (-tol<=diff<=tol)
while ( 1) 
    
    diff= midcount- midthr- Margin;
    if (abs(diff)<= tol)
        break;
    end
    
    % if tolerance is not met up to 20 iteractions, then relax the
    % tolerance by 10%
    
    iterno= iterno+ 1; 
    
    if (iterno>20) 
      tol = tol* 1.1; 
    end

    if (diff> tol)   % then new bounds are ...     
        midcount = (upcount + midcount) / 2.0; 
        % upper and middle activities 
        midthr = (upthr + midthr) / 2.0;	  
        % ... and thresholds     
    elseif (diff< -tol)	% then new bounds are ... 
        midcount = (midcount + lwcount) / 2.0; 
        % middle and lower activities 
        midthr = (midthr + lwthr) / 2.0;   
        % ... and thresholds 
    end    
    
end
%   Since the tolerance has been satisfied, midcount is selected 
%   as the interpolated value with a tol [dB] tolerance.

asl_ms_log= midcount;
cc= midthr;

end