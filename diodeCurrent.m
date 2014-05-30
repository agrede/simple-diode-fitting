function i = diodeCurrent(v,D0,phit)
  % DIODECURRENT calculates i for all v using iterative approach
  %  I = DIODECURRENT(V, D0, PHIT)
  %     V    voltage vector
  %     D0   vector of [i0, n, Rs, Rsh]
  %     PHIT thermal voltage kT/q
  %
  % Ideal diode with series and shunt resistance are considered iteration is
  % seeded with value excluding series resistance (closed form solution exists)
  %
  % Copyright (C) 2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)
  i0 = D0(1);
  n = D0(2);
  Rs = D0(3);
  Rsh = D0(4);
  f = @(i,v) i0.*(exp((v-i.*Rs)./(n.*phit))-1)+(v-i.*Rs)./Rsh;
  ig = i0.*(exp(v./(n.*phit))-1)+v./Rsh;
  % i = fsolve(@(i) i-f(i,v),ig);
  i = zeros(size(v));
  for k=1:length(v)
    i(k) = fsolve(@(i) i-f(i,v(k)),ig(k));
  end
end
