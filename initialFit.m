function res = initialFit(v,i,w,phit)
  % w is the number of points, like a boxcar average of sorts

  kp = find(v>0);
  kn = find(v<0);
  o1 = ones(w,1);

  A = zeros(2,length(kp)-1-2*w); % used to calculate n and i0 at each point
                                 % after an inflection in n(V), Rs dominates
  B = zeros(2,length(kn)-1-2*w); % used to calculate Rsh at each point

  C = zeros(2,length(kp)-1-2*w);

  res.vA = v(kp(floor(1.5.*w)+(1:size(A,2))),1);
  res.vB = v(kn(ceil(0.5.*w)+(1:size(B,2))),1);
  res.vC = res.vA;

  for k=1:size(A,2)
    kw = kp((1:w)+k+w-2,1);
    A(:,k) = [v(kw,1) ones(size(kw))]\log(i(kw,1));
    C(:,k) = [v(kw,1) ones(size(kw))]\i(kw,1);
  endfor

  for k=1:size(B,2)
    kw = kn(k-1+(1:w),1);
    B(:,k) = [v(kw,1) ones(size(kw))]\i(kw,1);
  endfor

  res.A = A;
  res.B = B;
  res.C = C;
  res.i0 = exp(A(2,:))';
  res.n = 1./(res.A(1,:).*phit)';
  res.Rs = 1./res.C(1,:)';
  res.Rsh = 1./res.B(1,:)';

  res.est = struct;

  % Est I0
  d1 = dydx(res.vA,spline(res.vA,res.A(2,:)'),1);
  lmin = find((d1(w:end)>0).*(d1(1:(end-w+1))));
  if (isempty(lmin))
    res.est.kri0 = 1:w;
    vm = median(res.A(2,res.est.kri0),2);
    [v,k] = min((res.A(2,res.est.kri0)-vm).^2,[],2);
    v = A(2,res.est.kri0(k));
  else
    rlow = max(-w+floor(median(lmin)),1);
    rhigh = min(ceil(w./2)+ceil(median(lmin)),length(res.i0));
    res.est.kri0 = rlow:1:rhigh;
    [v,k] = min(res.A(2,res.est.kri0),[],2);
  endif
  res.est.ki0 = res.est.kri0(k);
  res.est.i0 = exp(v);

  % Est n
  d1 = dydx(res.vA,spline(res.vA,res.n),1);
  lmin = find((d1(w:end)>0).*(d1(1:(end-w+1))));
  if (isempty(lmin))
    res.est.krn = 1:w;
    vm = median(res.n(res.est.krn,1));
    [v,k] = min((res.n(res.est.krn,1)-vm).^2);
    v = res.n(res.est.krn(k));
  else
    rlow = max(-w+floor(median(lmin)),1);
    rhigh = min(ceil(w./2)+ceil(median(lmin)),length(res.n));
    res.est.krn = rlow:1:rhigh;
    [v,k] = min(res.n(res.est.krn,1));
  endif
  res.est.kn = res.est.krn(k);
  res.est.n = v;

  % Est Rs
  kr = find(res.Rs>0);
  if (isempty(kr))
    res.est.Rs = res.Rs(end-w);
    res.est.kRs = length(res.Rs)-w;
  else
    [res.est.Rs,k] = min(res.Rs(kr,1));
    res.est.kRs = kr(k);
  endif

  % Est Rsh
  kr = find(res.Rsh>0);
  if (isempty(kr))
    res.est.Rsh = res.Rsh(w);
    res.est.kRsh = w;
  else
    vm = median(log(res.Rsh(kr,1)));
    [v,k] = min((log(res.Rsh(kr,1))-vm).^2);
    res.est.Rsh = res.Rsh(kr(k));
    res.est.kRsh = kr(k);
  endif

endfunction
