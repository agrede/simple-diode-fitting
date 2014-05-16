function res = plotDiodeDeriv(vk,ppm,ppf,order)
  yf = zeros(length(vk),length(ppf));
  for k=1:size(yf,2)
    yf(:,k) = dydx(vk,ppf{k},order);
  endfor
  ym = dydx(vk,ppm,order);
  semilogy(vk,abs(ym),'kx');
  hold on;
  semilogy(vk,abs(yf),'o');
  hold off;
endfunction
