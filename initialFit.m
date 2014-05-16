function res = initialFit(v,i,w)
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
endfunction
