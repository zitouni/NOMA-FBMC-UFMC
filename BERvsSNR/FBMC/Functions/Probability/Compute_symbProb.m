function CDF = Compute_symbProb(...
    expected_y2,...             % Expectation{|y|^2}
    expected_h2,...             % Expectation{|h|^2}
    expected_yh,...             % Expectation{y*conj(h)}
    Re_Z,...              % Real part of the CDF, i.e, Pr(real(y/h)<zR &...)
    Im_Z)                 % Imaginary part of the CDF, i.e, Pr(... & imag(y/h)<zR)

a = expected_yh/expected_h2; % alpha
b = expected_y2/expected_h2; % beta

Index0 = (Re_Z == -inf) | (Im_Z == -inf);
Index1 = (Re_Z == inf) & (Im_Z == inf);
IndexReal = (Im_Z == inf) & isfinite(Re_Z);
IndexImag = (Re_Z == inf) & isfinite(Im_Z);
IndexNormal = isfinite(Re_Z) & isfinite(Im_Z);

% See "Bit error probability for pilot-symbol aided channel estimation in
% FBMC-OQAM", R. Nissel and M. Rupp, 2016
CDF_Real = 1/2-...
    (real(a)-Re_Z(IndexReal))./...
    (2*sqrt((real(a)-Re_Z(IndexReal)).^2+b-abs(a).^2));

CDF_Imag = 1/2-...
    (imag(a)-Im_Z(IndexImag))./...
    (2*sqrt((imag(a)-Im_Z(IndexImag)).^2+b-abs(a).^2));


% General Case, see "OFDM and FBMC-OQAM in Doubly-Selective Channels:
% Calculating the Bit Error Probability" R. Nissel and M. Rupp, 2017
CDF_Normal = 1/4+...
(Re_Z(IndexNormal)-real(a)).*...
 (2*atan(...
            (Im_Z(IndexNormal)-imag(a))./sqrt((Re_Z(IndexNormal)-real(a)).^2+b-abs(a).^2)...
         )+pi)./...
 (4*pi*sqrt((Re_Z(IndexNormal)-real(a)).^2+b-abs(a).^2))+...
(Im_Z(IndexNormal)-imag(a)).*...
 (2*atan(...
            (Re_Z(IndexNormal)-real(a))./sqrt((Im_Z(IndexNormal)-imag(a)).^2+b-abs(a).^2)...
         )+pi)./...
 (4*pi*sqrt((Im_Z(IndexNormal)-imag(a)).^2+b-abs(a).^2));


% Map CDF to correct one
CDF = nan(size(Re_Z));
CDF(Index0) = 0;
CDF(Index1) = 1;
CDF(IndexReal) = CDF_Real;
CDF(IndexImag) = CDF_Imag;
CDF(IndexNormal) = CDF_Normal;

end