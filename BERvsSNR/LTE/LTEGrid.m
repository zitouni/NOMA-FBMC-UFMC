
function [resourceGrid]= LTEGrid()

%% Setup Cell-Wide

enb.CyclicPrefix = 'Normal';    % Normal cyclic prefix
enb.NDLRB = 15;     % Number of resource blocks
enb.CellRefP = 1;   % Cell-specific reference signal ports (1,2 or 4)
enb.NCellID = 1;    % Cell ID
enb.NSubframe = 0;      % Subframe number (Data changes depending on the number (It is in [0,9]))
enb.DuplexMode = 'FDD';     % FDD duplex mode
enb.CFI = 2;     % Length of control region
enb.TDDConfig = 1;      % Uplink/Downlink configuration (TDD only)
% enb.SSC = 4;                    % Special subframe configuration (TDD only)
enb.Ng='sixth';
antPort = 0;    %Number of antenna port

%% Setup User Data

% DL-SCH Settings 
TrBlkSizes = [1448];    % 2 elements for 2 codeword transmission 
pdsch.RV = [0 ];               % RV for the 2 codewords
pdsch.NSoftbits = 1237248;      % No of soft channel bits for UE category 2 
% PDSCH Settings
pdsch.TxScheme = 'Port0';  % Transmission scheme used
pdsch.Modulation = {'16QAM'}; % Symbol modulation for 2 codewords
pdsch.NLayers = 1;              % Two spatial transmission layers
pdsch.NTxAnts = 1;              % Number of transmit antennas
pdsch.RNTI = 1;                 % The RNTI value
pdsch.PRBSet = (0:enb.NDLRB-1)';% The PRBs for full allocation
pdsch.PMISet = 0;               % Precoding matrix index
pdsch.W = 1;                    % No UE-specific beamforming
% Only required for 'Port5', 'Port7-8', 'Port8' and 'Port7-14' schemes
if any(strcmpi(pdsch.TxScheme,{'Port5','Port7-8','Port8', 'Port7-14'}))
    pdsch.W = transpose(lteCSICodebook(pdsch.NLayers,pdsch.NTxAnts,[0 0]));
end

%% LTE Grid

resourceGrid = lteDLResourceGrid(enb);
[nsub,nOFDM] = size(resourceGrid);
flagGridPlot=1; 
%flagOFDMPlot=1;

%% Pilot CSR

ind = lteCellRSIndices(enb,antPort);    %Indice di dove il segnale è generato
rs = lteCellRS(enb,antPort);    %Segnale generato
bitCSR=qamdemod(rs,4,'OutputType','bit');
resourceGrid (ind) = rs;        %Mapping dei pilot
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('CSR');
end

%% PDSCH (User Data)

[pdsch_symbols,ind_pdsch]=UserChain(enb,pdsch,TrBlkSizes);
bitPDSCH=qamdemod(pdsch_symbols,16,'OutputType','bit');
resourceGrid (ind_pdsch(:,1)) = pdsch_symbols;        %Mapping dei pilot
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('CSR+PDSCH');
end

%% PSS

pss_symbols=ltePSS(enb);
bitPSS=qamdemod(rs,4,'OutputType','bit');
ind_pss = ltePSSIndices(enb,antPort);
resourceGrid (ind_pss(:,1)) = pss_symbols;
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('CSR+PDSCH+PSS');
end

%% SSS

sss_symbols=lteSSS(enb);
bitSSS=qamdemod(sss_symbols,2,'OutputType','bit');
ind_sss = lteSSSIndices(enb,antPort);
resourceGrid (ind_sss(:,1)) = sss_symbols;
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('CSR+PDSCH+PSS+SSS');
end

%% PBCH

mib = lteMIB(enb);
bchCoded = lteBCH(enb,mib);
pbch_symbols=ltePBCH(enb,bchCoded);
bitPBCH=qamdemod(pbch_symbols(1:length(pbch_symbols)/4),4,'OutputType','bit');
ind_pbch = ltePBCHIndices(enb);
resourceGrid (ind_pbch(:,1)) = pbch_symbols(1:length(pbch_symbols)/4);      %Divisione per 4 giustificata dall'help di Matlab (CONTROLLA!!!!!!!!)
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('CSR+PDSCH+PSS+SSS+PBCH');
end

%% PDCCH

ind_pdcch = ltePDCCHIndices(enb);
pdcchInfo = ltePDCCHInfo(enb);
cw = randi([0,1],pdcchInfo.MTot,1);
pdcch_symbols = ltePDCCH(enb,cw);
bitPDCCH=qamdemod(pdcch_symbols,4,'OutputType','bit');
resourceGrid (ind_pdcch(:,1)) = pdcch_symbols;
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('CSR+PDSCH+PSS+SSS+PBCH+PDCCH');
end

%% PCFICH

cfiCodeword = lteCFI(struct('CFI',1));
pcfich_symbols = ltePCFICH(enb,cfiCodeword);
bitPCFICH=qamdemod(pcfich_symbols,4,'OutputType','bit');
ind_pcfich = ltePCFICHIndices(enb);
resourceGrid (ind_pcfich(:,1)) = pcfich_symbols;
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('CSR+PDSCH+PSS+SSS+PBCH+PDCCH+PCFICH');
end

resourceGrid=resourceGrid(1:12,:);
if flagGridPlot
    plotLTEGrid(resourceGrid);
    title('SUBFRAME 0');
end
end

