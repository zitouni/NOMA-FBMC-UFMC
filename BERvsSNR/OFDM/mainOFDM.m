clc;
clear all;
%close all;

flagDoublyFlat=0;
flagBEP_Simulation=0;
flagBEP_Calculation=0;
flagPSD=1;


%% DoublyFlat
if flagDoublyFlat
%     The channel is flat in both domain.
%     We don't need multicarrier system.
%     We simulate the Bit Error Probability depending on the SNR with different
%     modulation orders

    snr_dB=0:20;    %SNR vector
    mod_vector=[4 16 64 256 1024];  %Simulated modulation orders

    for ind=1:length(mod_vector)
        %Take the term of the modulation vector
        Modulation_Order=mod_vector(ind);   
        %We get the symbol and bit mappings from the "Constellation" function
        [SymbolMapping,BitMapping]=Constellation(Modulation_Order);
        %We get the Bit Error Probability for each mapping and corresponding
        %modulation
        DecisionRegions=GetDecisionRegions(SymbolMapping);
        BEP=BEP_DoublyFlat(snr_dB,SymbolMapping,BitMapping,DecisionRegions);
        %Plot the results
        semilogy(snr_dB,BEP);
        hold on
        grid on
    end
    title('Doubly Flat Channel: Rectangular QAM performances')
    xlabel('SNR [dB]');
    ylabel('Bit Error Probability (BEP)');
    legend('4-QAM','16-QAM','64-QAM','256-QAM','1024-QAM','Location','SouthWest');
end


%% BEP Simulation

if flagBEP_Simulation
    %Modulation order
    mod=16;
    [symmap,bitmap]=Constellation(mod);
    %OFDM object creation
    str=OFDM();   
    NSamples=str.NSamples;
    %Matrices
    G=TXMatrix(str);    %TX Matrix                                                        %,ResourceGrid
    Q=RXMatrix(str,G);  %RX Matrix
    Q=Q';
    NormFactor = sqrt(Q(:,1)'*Q(:,1));
    G = G*NormFactor;
    Q = Q/NormFactor;
    %We are interested only on the middle position of the matrices
    MidPosition = ceil(str.Subcarriers/2)+(str.Subcarriers)*(ceil(str.Symbols/2)-1);
    qlk = Q(:,MidPosition);
    glk = G(:,MidPosition);

    %Simulation
    snr_dB=-6:2:30;   %SNR vector
    Pn_vector = 10.^(-snr_dB/10); 
    MonteCarloRepetitions=4000;
    for rep=1:MonteCarloRepetitions
        %Transmitter
        %Bit stream
        stream=randi([0 1],str.Subcarriers*str.Symbols*log2(mod),1);
        %Symbol stream
        symbols=Bit_to_Symbol(symmap,stream,mod);
        %Symbols are shaped like a LTE grid (12 subcarriersX14 OFDM symbols)
        LTEgrid=reshape(symbols,str.Subcarriers,str.Symbols);
        %OFDM modulation
        s=OFDMModulation(str,LTEgrid)*NormFactor;
        %Channel model
        ch=channel();
        %Power Delay Profile
        x_genChannel=[0:0.01:2];    %200 paths
        channelmodel='Rayleigh';
        %channelmodel='Nakagami';
        if strcmp(channelmodel,'Rayleigh')
            b=0.5;
            PDP=raylpdf(x_genChannel,b);
            %Channel Impulse Response
            h=GetImpulseResponse(ch,'Jakes',NSamples,PDP);
        else
            if strcmp(channelmodel,'Nakagami')
                mu=10;
                omega=0.5;
                PDP=pdf('Nakagami',x_genChannel,mu,omega);
                %Channel Impulse Response
                h=GetImpulseResponse(ch,'Jakes',NSamples,PDP);
            end
        end
        %Channel Convolution Matrix
        H=GetConvolutionMatrix(h,PDP,NSamples);
        %Received signal without noise
        r_no=H*s;   
        %Channel equalization
        hlk = qlk'*H*glk;
        %Receiver
        for k=1:length(snr_dB)
            %Simulate noise
            Pn = Pn_vector(k);
            n = sqrt(Pn/2)*(randn(NSamples,1)+1j*randn(NSamples,1));  
            %Add noise
            r=r_no+n;
            %Demodulation
            rx_LTEgrid=OFDMDemodulation(str,r)/NormFactor;
            % Equalized received symbols, only the middle MidPosition is of interest for us here
            rx_equalized = rx_LTEgrid(MidPosition)./hlk;
            %Demapping
            rx_bit=Symbol_to_Bit(symmap,bitmap,rx_equalized,mod);
            tx_bit=Symbol_to_Bit(symmap,bitmap,LTEgrid(MidPosition),mod);
            %BER evaluation
            BER(k,1)=mean(rx_bit~=tx_bit);
        end
        BER_tot(:,rep)=BER;
    end
    meanBER=mean(BER_tot,2);
    
    %Save simulation results
    saveFlag=1;
    if saveFlag
        if strcmp(channelmodel,'Nakagami')
        FileName = ['.\Results\' 'OFDM_Simulation_' channelmodel '_ShapeParameter' num2str(mu) '_Velocity' int2str(ch.Velocity_kmh) '_Modulation' int2str(mod) 'QAM.mat'];
        save(FileName,...
              'snr_dB', ...
              'meanBER');
        else
        FileName = ['.\Results\' 'OFDM_Simulation_' channelmodel '_Velocity' int2str(ch.Velocity_kmh) '_Modulation' int2str(mod) 'QAM.mat'];
        save(FileName,...
              'snr_dB', ...
              'meanBER');
        end
    end
end

%% BEP Calculation

if flagBEP_Calculation
    %Modulation order
    mod=16;
    [symmap,bitmap]=Constellation(mod);
    %OFDM object creation
    str=OFDM();   
    NSamples=str.NSamples;
    %Simulation
    snr_dB=-6:2:30;   %SNR vector
    Pn_vector = 10.^(-snr_dB/10); 
    %Matrices
    G=TXMatrix(str);    %TX Matrix                                                        %,ResourceGrid
    Q=RXMatrix(str,G);  %RX Matrix
    Q=Q';
    NormFactor = sqrt(Q(:,1)'*Q(:,1));
    G = G*NormFactor;
    Q = Q/NormFactor;
    %We are interested only on the middle position of the matrices
    MidPosition = ceil(str.Subcarriers/2)+(str.Subcarriers)*(ceil(str.Symbols/2)-1);
    qlk = Q(:,MidPosition);
    glk = G(:,MidPosition);
    %Channel model
    ch=channel();
    %Power Delay Profile
    x_genChannel=[0:0.1:2];
    channelmodel='Rayleigh';
    %channelmodel='Nakagami';
    if strcmp(channelmodel,'Rayleigh')
        b=0.5;
        PDP=raylpdf(x_genChannel,b);
        %Channel Impulse Response
        h=GetImpulseResponse(ch,'Jakes',NSamples,PDP);
        PDP_Normalized=PDP.'/sum(PDP);
        R_vecH = GetCorrelationMatrix(ch,'Jakes',h,PDP_Normalized,NSamples);
    else
    if strcmp(channelmodel,'Nakagami')
        mu=10;
        omega=0.5;
        PDP=pdf('Nakagami',x_genChannel,mu,omega);
        %Channel Impulse Response
        h=GetImpulseResponse(ch,'Jakes',NSamples,PDP);
        PDP_Normalized=PDP.'/sum(PDP);
        R_vecH = GetCorrelationMatrix(ch,'Jakes',h,PDP_Normalized,NSamples);
    end
    end
    RXVectorRep = kron(sparse(eye(length(qlk'))),qlk);
    Temp = RXVectorRep'*R_vecH*RXVectorRep;
    Ey2WithoutDataNoNoise = G.'*Temp*conj(G);               % Same as "Ey2WithoutDataNoNoise = kron((G).',glk')*R_vecH*(kron((G).',glk'))';" but faster!
    EyhWithoutData = G.'*Temp*conj(glk);                    % Same as: EyhWithoutData = kron((G).',qlk')*R_vecH*(kron((glk).',qlk'))';
    Eh2 = abs(kron(glk.',qlk')*R_vecH*(kron(glk.',qlk'))'); % Eh2 is independent of the data and the noise => can be precalculated here: Expectation{|h|^2}
    NrMonteCarloRepetitionsForInterferers=200;
    BEP = nan(length(Pn_vector),1);
    for m = 1:length(Pn_vector)
    Pn = Pn_vector(m);
    ProbabilityMatrix = nan(size(symmap,1),size(symmap,1),NrMonteCarloRepetitionsForInterferers);
    for l = 1:size(symmap,1)
        xlk = symmap(l);       
        % "Exact" solution by using enough Montecarlo repetitions
        for k = 1:NrMonteCarloRepetitionsForInterferers
            % We choose the interferers randomly too keep it simple. Note
            % that for a low QAM order the exact calcuation is possibly by
            % considering all relevant interferers (especially for FBMC)
            x = symmap(randi(mod,str.Subcarriers*str.Symbols,1));
            x(MidPosition) = xlk;  
            % Expectation{|y|^2} conditioned on x
            Ey2 = abs(x(:).'*Ey2WithoutDataNoNoise*conj(x(:)))+Pn;
            % Expectation{yh*} conditioned on x
            Eyh =  x(:).'*EyhWithoutData;
            DecisionRegions=GetDecisionRegions(symmap);
            ProbabilityMatrix(:,l,k)=Compute_rectangularRegionProb(Ey2,Eh2,Eyh,DecisionRegions(:,1),DecisionRegions(:,2),DecisionRegions(:,3),DecisionRegions(:,4));
        end
    end 
    % The probability matrix gives the probability that x_i was detected conditioned that x_j was transmitted.
    ProbabilityMatrix = mean(ProbabilityMatrix,3);

    % We have to relate the detection probabilities of x_i conditioned on x_j to the corresponding bit mapping, usually based on Gray coding
    ErrorProbability = nan(2,size(bitmap,2));
    for i_bit= 1:size(bitmap,2)
        for i_zero_one = [0 1]
            index_x = (bitmap(:,i_bit)==i_zero_one);
            ErrorProbability(i_zero_one+1,i_bit) = mean(sum(ProbabilityMatrix(not(index_x),index_x)));
        end   
    end
    BEP(m) = mean(mean(ErrorProbability));
    end
    
    %Save simulation results
    saveFlag=1;
    if saveFlag
        if strcmp(channelmodel,'Nakagami')
        FileName = ['.\Results\' 'OFDM_Calculation_' channelmodel '_ShapeParameter' num2str(mu) '_Velocity' int2str(ch.Velocity_kmh) '_Modulation' int2str(mod) 'QAM.mat'];
        save(FileName,...
              'snr_dB', ...
              'BEP');
        else
        FileName = ['.\Results\' 'OFDM_Calculation_' channelmodel '_Velocity' int2str(ch.Velocity_kmh) '_Modulation' int2str(mod) 'QAM.mat'];
        save(FileName,...
              'snr_dB', ...
              'BEP');
        end
    end
end


%% Spectrum Plot

if flagPSD
    str=OFDM();
    ModulationOrder=16;
    [PSD,Normalized_frequency] = GetPSD(str,ModulationOrder);
    %Save simulation results
    saveFlag=0;
    if saveFlag
        FileName = ['.\Results\' 'OFDM_Spectrum.mat'];
        save(FileName,...
          'Normalized_frequency', ...
          'PSD');
    end
    plot( Normalized_frequency /1e6 , 10*log10(PSD/max(PSD)) ,'b');  hold on;
end