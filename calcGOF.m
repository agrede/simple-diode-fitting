function res = calcGOF(DF,nms,imax)
  % CALCGOF calculates metrics for goodness of fit (GOF)
  %  RES = CALCGOF(DF, NMS, IMAX)
  %       DF    struct of fit data
  %       NMS   cell array of field names of DF that contain fits
  %       IMAX  current above this level is ignored in calculations
  %             (hit ceiling of measurement device)
  %
  % Calculates GOF for values of V<0, V>0 and combination (V=0 evaluates to -Inf
  %   on log scale)
  % Uses general formula rk = (log|ik|-log|i(vk)|)^2
  %
  % Copyright (C) 2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)
  res = struct;
  for k1 = 1:length(nms)
    ky = nms{k1};
    res.(ky) = struct;
    res.(ky).SStot = zeros(3,1,size(DF.(ky).I,2));
    res.(ky).SSres = zeros(3,size(DF.(ky).fI,2),size(DF.(ky).I,2));
    for k2 = 1:size(DF.(ky).I,2)
      kn = find((DF.(ky).I(:,k2)<imax).*(DF.(ky).V<0));
      kp = find((DF.(ky).I(:,k2)<imax).*(DF.(ky).V>0));
      ka = [kn;kp];

      tIn = log(abs(DF.(ky).I(kn,k2)));
      tIp = log(abs(DF.(ky).I(kp,k2)));
      tIa = log(abs(DF.(ky).I(ka,k2)));
      tfIn = log(abs(DF.(ky).fI(kn,:,k2)));
      tfIp = log(abs(DF.(ky).fI(kp,:,k2)));
      tfIa = log(abs(DF.(ky).fI(ka,:,k2)));

      res.(ky).SStot(1,1,k2) = sum((tIn-mean(tIn)).^2)./length(kn);
      res.(ky).SStot(2,1,k2) = sum((tIp-mean(tIp)).^2)./length(kp);
      res.(ky).SStot(3,1,k2) = sum((tIa-mean(tIa)).^2)./length(ka);

      o2 = ones(1,size(DF.(ky).fI,2));

      res.(ky).SSres(1,:,k2) = sum((tIn(:,o2)-tfIn).^2)./length(kn);
      res.(ky).SSres(2,:,k2) = sum((tIp(:,o2)-tfIp).^2)./length(kp);
      res.(ky).SSres(3,:,k2) = sum((tIa(:,o2)-tfIa).^2)./length(ka);
    endfor
  endfor
endfunction
