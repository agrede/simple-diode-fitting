function res = calcGOF(DF,nms,imax)
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
