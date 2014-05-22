function res = plotDiodeFit(vk,ik,fit,phit,fI)
  % RES = PLOTDIODEFIT plots measured and fits for diode
  %   PLOTDIODEFIT(VK, IK, FIT, PHIT)
  %     VK   measured voltage
  %     IK   measured current
  %     FIT  fit matrix from DIODEFITS
  %     PHIT thermal voltage (kT/q)
  %   PLOTDIODEFIT(VK, IK, FIT, PHIT, FI)
  %     FI   fit currents for all VK
  % Without the optional fI parameter, will calculate currents using fit and
  %   DIODECURRENT (Takes time)
  %
  % Copyright (C) 2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of <NAME> (https://github.com/agrede/<GITHUB>)
  if (nargin<5)
    fI = zeros(size(vk,1),size(fit,2));

    for k=1:size(fit,2)
      fI(:,k) = diodeCurrent(vk,fit(:,k),phit);
    endfor
  endif

  semilogy(vk,abs(ik),'k.');
  hold on;
  semilogy(vk,abs(fI));
  hold off;

endfunction
