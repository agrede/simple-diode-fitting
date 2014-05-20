function res = plotInitialFits(fit)
  % Plot I0
  subplot(2,2,1);
  semilogy(fit.vA,fit.i0);
  hold on;
  semilogy(fit.vA(fit.est.kri0),fit.i0(fit.est.kri0),'ro');
  semilogy(fit.vA(fit.est.ki0),fit.est.i0,'rx');
  hold off;
  ylabel('I0');

  % Plot n
  subplot(2,2,2);
  plot(fit.vA,fit.n);
  hold on;
  plot(fit.vA(fit.est.krn), fit.n(fit.est.krn), 'ro');
  plot(fit.vA(fit.est.kn), fit.est.n, 'rx');
  hold off;
  ylabel('n');

  % Plot Rs
  subplot(2,2,3);
  semilogy(fit.vC,fit.Rs);
  hold on;
  semilogy(fit.vC(fit.est.kRs),fit.est.Rs,'rx');
  hold off;
  ylabel('Rs');

  % Plot Rsh
  subplot(2,2,4);
  semilogy(fit.vB,fit.Rsh);
  hold on;
  semilogy(fit.vB(fit.est.kRsh),fit.est.Rsh,'rx');
  hold off;
  ylabel('Rsh');
endfunction
