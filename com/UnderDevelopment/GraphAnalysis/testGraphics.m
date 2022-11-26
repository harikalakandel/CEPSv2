data= xlsread('RBA_CEPS2_44_LONG_for_Graph_Analysis.xlsx');




%     Participant ID in column B
ID=2;
ID_INDEXES = [2];
ID_LIST = unique(data(~isnan(data(:,ID)),ID))
%     Slot (breathing rate) in column D [I have included the 'virtual' 'RBR' slots here, but they willl overlap with the data above, as RBR = 5, 5.5, 6 or 6.5 bpm]
%     Some RESP ratio measures in columns H & I
RESP_RATIO_INDEXES= [8:9];

%     Demographics and questionnaire responses in columns E-G, J-U
DEMOGRPHICS_INDEXES = [5:7];

QUESTIONNAIRE_INDEXES = [10:21];
%     RBR in columns V, X and Y
RBR_INDEXES = [22, 24,25];


%     HiHRV_Best_Rest in column W
HRV_Hi_br_INDEXES = [23];
%     Various CEPS measures for RRi in columns Z-EG
RRi_INDEXES =[26:137];
%     Standard HRV output from Kubios in columns EH-GO
HRV_KUBIOS_INDEXES=[138:197];
%     CEPS measures for 1-5 minute data in columns GP-LS
CEPS_MEASURES_INDEXES=[198:331];
%     Standard HRV output from RR-APET for 1-5 minute data in columns LT-PY
HRV_RR_APET_INDEXES=[332:441];
%     HRA measures for 1-5 minute data in columns PZ-SV
HRV_1_5min_INDEXES = [442:516];
%     NLD measures for 1-5 minute data in columns SW-UO
NLD_INDEXES=[517:561];
%     CEPS measures for RESP data in columns UP-ADA
CEPS_RESP_1_INDEXES=[562:781];
%     More CEPS measures for1-5 minute RRi data in columns ADB-AEE
CEPS_RRi_1_INDEXES =[782:811];
%     CEPS measures for RESP data in columns AEF-AEM
CEPS_RESP_2_INDEXES =[812:819];
%     More CEPS measures for RRi in columns AEN-AON.
CEPS_RRi_2_INDEXES=[820:1080];








