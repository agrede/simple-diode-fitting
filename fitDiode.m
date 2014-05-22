function res = fitDiode(vk,ik,D0,phit)
  % FITDIODE uses four different methods to find parameters
  %  RES = FITDIODE(VK, IK, D0, PHIT)
  %       VK   Measured voltage values
  %       IK   Measured current values
  %       D0   Seed value for optimization [i0;n;Rs;Rsh]
  %       PHIT thermal voltage
  %  Output:
  %       RES is a 4x4 matrix with each column the parameters that result from
  %        each fit method in the order [i0;n;Rs;Rsh]
  %
  % Two flavors of fitness functions are used minimizing
  %   sum(|log|i(vk)|-log|ik|) or
  %   sum(|1-|i(vk)/ik||)
  % with two ways of handling Rsh either linearly or exponentially
  %
  % Solution relies on measured ik in calculating i(vk) for increased speed
  %
  % Copyright (C) 2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of <NAME> (https://github.com/agrede/<GITHUB>)
  res = zeros(4,5);
  X0 = [log(D0(1));D0(2);D0(3);D0(4).*1e-6];
  X1 = [log(D0(1));D0(2);D0(3);log(D0(4))];

  H1 = @(X) [exp(X(1));X(2);X(3);exp(X(4))];
  %G1 = @(X) [log(X(1));X(2);X(3);log(X(4))];
  % This function is not quite right. (using log(i0) helps with weighting)
  f1 = @(i0,n,Rs,Rsh) exp(i0).*(exp((vk-ik.*Rs)./(n.*phit))-1)+(vk-ik.*Rs)./(Rsh.*1e6);
  f2 = @(i0,n,Rs,Rsh) exp(i0).*(exp((vk-ik.*Rs)./(n.*phit))-1)+(vk-ik.*Rs)./exp(Rsh);
  f3 = @(X) diodeCurrent(vk,H1(X),phit);
  % f2 = @(i0,n,Rs,Rsh) ...
  %       fsolve(@(i) i-exp(i0).*(exp((vk-i.*Rs)./(n.*phit))-1)+(vk-i.*Rs)./Rsh,...
  %             exp(i0).*(exp(vk./(n.*phit))-1)+vk./Rsh);

  R1 = @(X) sum(abs(log(abs(f1(X(1),X(2),X(3),X(4))./ik))));
  R2 = @(X) sum(abs(1-abs(f1(X(1),X(2),X(3),X(4))./ik)));
  R3 = @(X) sum(abs(log(abs(f2(X(1),X(2),X(3),X(4))./ik))));
  R4 = @(X) sum(abs(1-abs(f2(X(1),X(2),X(3),X(4))./ik)));
  R5 = @(X) sum((log(abs(f3(X)./ik))).^2);

  M = fminunc(R1,X0);
  res(:,1) = [exp(M(1));M([2 3],1);1e6.*M(4)];

  M = fminunc(R2,X0);
  res(:,2) = [exp(M(1));M([2 3],1);1e6.*M(4)];

  M = fminunc(R3,X1);
  res(:,3) = [exp(M(1));M([2 3],1);exp(M(4))];

  M = fminunc(R4,X1);
  res(:,4) = [exp(M(1));M([2 3],1);exp(M(4))];

  % M = fminunc(R5,X1);
  % res(:,5) = H1(M);

endfunction
