function res = plotDiodeDeriv(vk,ppm,ppf,order)
  % PLOTDIODEDERIV plots derivative of measured and model data
  %   RES = PLOTDIODEDERIV(VK, PPM, PPF, ORDER)
  %     VK    voltages
  %     PPM   result of spline(V,I) for measured data
  %     PPF   result of spline(V,I) for modeled data (fit)
  %     ORDER derivative order
  % See also DYDX
  %
  % Copyright (C) 2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)
  yf = zeros(length(vk),length(ppf));
  for k=1:size(yf,2)
    yf(:,k) = dydx(vk,ppf{k},order);
  end
  ym = dydx(vk,ppm,order);
  semilogy(vk,abs(ym),'kx');
  hold on;
  semilogy(vk,abs(yf),'o');
  hold off;
end
