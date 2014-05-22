% RUNFITS is an interactive way to fit data from JSON file
%
% Copyright (C) 2014 Alex J. Grede
% GPL v3, See LICENSE.txt for details
% This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)

PC = physC();

[tmpName,tmpPath] = uigetfile({'*.json','JSON'},'Measurment File');
measPath = strcat(tmpPath,tmpName);
DF = loadjson(measPath);
nms = sort(fieldnames(DF));

DF.T = input('Temperature [K] = ');
DF.w = 10;
nfits = 5;
DF.Icut = inputDefault('Cutoff current [A] = ',nan(1));
phit = PC.kB.*DF.T./PC.e;

for k1 = 1:length(nms)
  ky = nms{k1};
  if (yes_or_no(strcat('Fit ', ky, '?')))
    tV = DF.(ky).V';
    DF.(ky).V = tV;
    [uV1, uk1, ul1] = unique(tV,'last');
    [uV2, uk2, ul2] = unique(tV,'first');
    tI = DF.(ky).I;
    mI = mean(cat(3,tI(uk1(ul1),:),tI(uk2(ul2),:)),3);
    DF.(ky).pps = cell(1,size(tI,2));
    DF.(ky).ppfs = cell(nfits,size(tI,2));
    DF.(ky).fits = zeros(4,nfits,size(tI,2));
    DF.(ky).ifits = cell(1,size(tI,2));
    DF.(ky).fI = zeros(size(tI,1),nfits,size(tI,2));
    for k2 = 1:size(tI,2)
      DF.(ky).pps{k2} = spline(uV1,mI(:,k2));
      setInit = 1;
      while (setInit == 1)
        DF.(ky).pps{k2} = spline(uV1,mI(:,k2));
        DF.(ky).ifit{k2} = initialFit(tV,tI(:,k2),DF.w,phit);
        plotInitialFits(DF.(ky).ifit{k2});


        DF.(ky).fits(1,1,k2) = inputDefault('I0 [A] =',DF.(ky).ifit{k2}.est.i0);
        DF.(ky).fits(2,1,k2) = inputDefault('n =',DF.(ky).ifit{k2}.est.n);
        DF.(ky).fits(3,1,k2) = inputDefault('Rs [Ohms] =',...
                                            DF.(ky).ifit{k2}.est.Rs);
        DF.(ky).fits(4,1,k2) = inputDefault('Rsh [Ohms] =',...
                                            DF.(ky).ifit{k2}.est.Rsh);

        subplot(1,1,1);
        semilogy(tV,abs(tI(:,k2)),'k.');
        kcut = find(abs(tI(:,k2))>=DF.Icut);
        if (~isempty(kcut))
          hold on;
          semilogy(tV((end-length(kcut)):end,1),...
                   abs(tI((end-length(kcut)):end,k2)),'rx');
          hold off;
        endif
        ylabel('Current [A]');
        xlabel('Bias [V]');
        ks = 1+ inputDefault('Cut off # of points from start =',0);
        ke = size(tI(:,k2),1) - inputDefault(...
                                      'Cut off # of points from end =',...
                                      length(kcut));

        DF.(ky).fits(:,2:end,k2) = fitDiode(tV(ks:ke,1),...
                                            tI(ks:ke,k2),...
                                            DF.(ky).fits(:,1,k2),phit);

        for k3 = 1:nfits
          DF.(ky).fI(:,k3,k2) = diodeCurrent(tV,DF.(ky).fits(:,k3,k2),phit);
          DF.(ky).ppfs{k3,k2} = spline(uV1,DF.(ky).fI(uk1,k3,k2));
        endfor

        plotDiodeFit(tV,tI(:,k2),[],phit,DF.(ky).fI(:,:,k2));
        setInit = yes_or_no('Re-enter starting conditions?');
      endwhile
    endfor
  endif
endfor
