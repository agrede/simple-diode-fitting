PC = physC();

[tmpName,tmpPath] = uigetfile({'*.json','JSON'},'Measurment File');
measPath = strcat(tmpPath,tmpName);
DF = loadjson(measPath);
nms = sort(fieldnames(DF));

DF.T = input('Temperature [K] = ');
DF.w = 10;
nfits = 5;
DF.Icut = input('Cutoff current [A] = ');
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
        DF.(ky).ifit{k2} = initialFit(tV,tI(:,k2),DF.w);
        plotInitialFits(DF.(ky).ifit{k2},phit);

        DF.(ky).fits(1,1,k2) = input('I0 = ');
        DF.(ky).fits(2,1,k2) = input('n = ');
        DF.(ky).fits(3,1,k2) = input('Rs = ');
        DF.(ky).fits(4,1,k2) = input('Rsh = ');

        subplot(1,1,1);
        semilogy(tV,abs(tI(:,k2)),'k.');
        ks = 1+ input('Cut off # of points from start = ');
        ke = size(tI(:,k2),1) - input('Cut off # of points from end = ');

        DF.(ky).fits(:,2:end,k2) = fitDiode(tV(ks:ke,1),tI(ks:ke,k2),DF.(ky).fits(:,1,k2),phit);

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
