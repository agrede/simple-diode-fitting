function res = fitDiode(vk,ik,D0,phit)
  res = zeros(4,4);
  X0 = [log(D0(1));D0(2);D0(3);D0(4).*1e-6];
  X1 = [log(D0(1));D0(2);D0(3);log(D0(4))];
  % This function is not quite right. (using log(i0) helps with weighting)
  f1 = @(i0,n,Rs,Rsh) exp(i0).*(exp((vk-ik.*Rs)./(n.*phit))-1)+(vk-ik.*Rs)./(Rsh.*1e6);
  f2 = @(i0,n,Rs,Rsh) exp(i0).*(exp((vk-ik.*Rs)./(n.*phit))-1)+(vk-ik.*Rs)./exp(Rsh);
  % f2 = @(i0,n,Rs,Rsh) diodeCurrent(vk,exp(i0),n,Rs,Rsh,phit);
  % f2 = @(i0,n,Rs,Rsh) ...
  %       fsolve(@(i) i-exp(i0).*(exp((vk-i.*Rs)./(n.*phit))-1)+(vk-i.*Rs)./Rsh,...
  %             exp(i0).*(exp(vk./(n.*phit))-1)+vk./Rsh);

  R1 = @(X) sum(abs(log(abs(f1(X(1),X(2),X(3),X(4))./ik))));
  R2 = @(X) sum(abs(1-abs(f1(X(1),X(2),X(3),X(4))./ik)));
  R3 = @(X) sum(abs(log(abs(f2(X(1),X(2),X(3),X(4))./ik))));
  R4 = @(X) sum(abs(1-abs(f2(X(1),X(2),X(3),X(4))./ik)));
  % R5 = @(X) sum((f2(X(1),X(2),X(3),X(4))-ik).^2);

  M = fminunc(R1,X0);
  res(:,1) = [exp(M(1));M([2 3],1);1e6.*M(4)];

  M = fminunc(R2,X0);
  res(:,2) = [exp(M(1));M([2 3],1);1e6.*M(4)];

  M = fminunc(R3,X1);
  res(:,3) = [exp(M(1));M([2 3],1);exp(M(4))];

  M = fminunc(R4,X1);
  res(:,4) = [exp(M(1));M([2 3],1);exp(M(4))];

  % M = fminunc(R5,X0);
  % res.M5 = [exp(M(1));M(2:end)];

endfunction
