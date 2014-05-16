function res = plotDiodeFit(vk,ik,fit,phit,ifits)
  if (nargin<5)
    ifits = zeros(size(vk,1),size(fit,2));

    for k=1:size(fit,2)
      ifits(:,k) = diodeCurrent(vk,fit(:,k),phit);
    endfor
  endif

  semilogy(vk,abs(ik),'k.');
  hold on;
  semilogy(vk,abs(ifits));
  hold off;

endfunction
