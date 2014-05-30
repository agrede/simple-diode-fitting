function [D, fI] = fitText(path,outpath,Icut)
  % FITTEXT is an interactive way to fit data from text file
  %
  % Copyright (C) 2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)

  % Force for this function
  PC = physC();
  T = 300;
  w = 10;
  phit = PC.kB.*T./PC.e;
  nfits = 5;
  skipR = 7;
  sep = '\t';

  if nargin < 3
    Icut = 1e9;
  end

  D = zeros(4,nfits);

  setInit = 1;

  tmp = dlmread(path,sep,skipR,0);

  vk = tmp(:,1);
  ik = tmp(:,2);
  fI = zeros(size(vk,1),nfits);

  while (setInit == 1)
    ifit = initialFit(vk,ik,w,phit);
    plotInitialFits(ifit);

    D(1,1) = inputDefault('I0 [A] =', ifit.est.i0);
    D(2,1) = inputDefault('n =', ifit.est.n);
    D(3,1) = inputDefault('Rs [Ohms] =', ifit.est.Rs);
    D(4,1) = inputDefault('Rsh [Ohms] =', ifit.est.Rsh);

    kkeep = find((abs(ik)<Icut).*(abs(vk)>0));
    kcut = find(((abs(ik)>=Icut))>0);
    subplot(1,1,1);
    semilogy(vk,abs(ik),'k.');
    if (~isempty(kcut))
      hold on;
      semilogy(vk(kcut,1),abs(ik(kcut,1)),'rx');
      hold off;
    endif
    ylabel('Current [A]');
    xlabel('Bias [V]');

    input('Continue...');

    D(:,2:end) = fitDiode(vk(kkeep,1),ik(kkeep,1),D(:,1),phit);
    for k3 = 1:nfits
      fI(:,k3) = diodeCurrent(vk,D(:,k3),phit);
    endfor

    plotDiodeFit(vk,ik,[],phit,fI);
    setInit = yes_or_no('Re-enter starting conditions?');
  endwhile

  csvwrite(strcat(outpath,'fit.csv'),[vk,fI]);
  csvwrite(strcat(outpath,'fitParams.csv'),D);

endfunction
