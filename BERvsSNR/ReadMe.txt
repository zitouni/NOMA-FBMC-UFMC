FOLDERS 'OFDM', 'FBMC', 'UFMC': 
Each of them contain a file main.m that has to be run after the insertion of folders and subfolders 'Classes' and 'Functions' in the path.
'Classes' contains the channel model and the waveform object creation.
'Functions' contains scripts for the BEP calculation and scripts for modulation and matrices at the tx and rx.
'Results' contains data results.
main.m is composed by three parts:
BEP_Simulation: Bit stream and waveform object are generated and the chain tx-to-rx is simulated through blocks.
		BEP is computed by comparing the received bits with the transmitted ones.
		This chain is repeated for a given number of Montecarlo repetitions
BEP_Calculation: Functions in 'Calculation' folder contained in 'Functions' are exploited.
		 BEP_Calculation curves are computed in order to verify if the simulation is correct.
		 Therefore, their curves should coincide: otherwise, try to increase the number of Montecarlo repetitions.
PSD: Plot of the Power Spectral Density.

FOLDER 'BER_RESULTS':
The script generating the graph that gives the performances is in this folder.
Data results are the same contained in 'Results' for each waveform.

FOLDER 'SPECTRUM_RESULTS':
PSDs of each waveform and their plots.

FOLDER 'LTE':
It contains some functions representing the LTE resource block creation and repsective plot.