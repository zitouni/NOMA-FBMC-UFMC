function Pr = Compute_rectangularRegionProb(...
    expected_y2,...             % Expectation{|y|^2}
    expected_h2,...             % Expectation{|h|^2}
    expected_yh,...             % Expectation{y*conj(h)}
    Re_Zinf,...         % Determines the rectangular region
    Re_Zsup,...
    Im_Zinf,...
    Im_Zsup)


    CDF_RegionA = Compute_symbProb(expected_y2,expected_h2,expected_yh,Re_Zsup,Im_Zsup);
    CDF_RegionB = Compute_symbProb(expected_y2,expected_h2,expected_yh,Re_Zinf,Im_Zinf);
    CDF_RegionC = Compute_symbProb(expected_y2,expected_h2,expected_yh,Re_Zinf,Im_Zsup);
    CDF_RegionD = Compute_symbProb(expected_y2,expected_h2,expected_yh,Re_Zsup,Im_Zinf);
    
    Pr = CDF_RegionA+CDF_RegionB-CDF_RegionC-CDF_RegionD;
    
end