function i = diodeCurrent(v,D0,phit)
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
endfunction
