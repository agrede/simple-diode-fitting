function res = plotInitialFits(fit,phit)
  subplot(2,2,1); semilogy(fit.vA,exp(fit.A(2,:))); ylabel('I0');
  subplot(2,2,2); plot(fit.vA,1./(phit.*fit.A(1,:))); ylabel('n'); ylim([1 6]);
  subplot(2,2,3); semilogy(fit.vC,1./fit.C(1,:)); ylabel('Rs');
  subplot(2,2,4); semilogy(fit.vB,1./fit.B(1,:)); ylabel('Rsh')
endfunction
