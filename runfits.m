PC = physC();

[tmpName,tmpPath] = uigetfile({'*.json','JSON'},'Measurment File');
measPath = strcat(tmpPath,tmpName);

DF = loadjson(measPath);

DF.T = input('Temperature [K] = ');
w = 10;
nfits = 5;
phit = PC.kB.*T./PC.e;

nms = sort(fieldnames(dta));

for k1 = 1:length(nms)
  ky = nms{k1};
  if (yes_or_no(strcat('Fit ', ky, '?')))
    tV = DF.(ky).V;
    [uV1, uk1, ul1] = unique(tV,'last');
    [uV2, uk2, ul2] = unique(tV,'first');
    tI = DF.(ky).I;
    mI = mean(cat(3,tI(uk1(ul1),:),tI(uk2(ul2),:)),3);
    DF.(ky).pps = cell(1,size(tI,2));
    DF.(ky).ppf = cell(nfits,size(tI,2));
    DF.(ky).fits = zeros(4,nfits,size(tI,2));
    DF.(ky).ifits = cell(1,size(tI,2));
    for k2 = 1:size(tI,2)
      DF.(ky).pps{k2} = spline(uV1,mI(:,k2));
      DF.(ky).ifit{k2} = initialFit(tV,tI(:,k2),w);
      plotInitialFits(DF.(ky).ifit{k2},phit);
      DF.(ky).fits(1,1,k2) = input('I0 = ');
      DF.(ky).fits(2,1,k2) = input('n = ');
      DF.(ky).fits(3,1,k2) = input('Rs = ');
      DF.(ky).fits(4,1,k2) = input('Rsh = ');
    endfor
  endif
endfor
