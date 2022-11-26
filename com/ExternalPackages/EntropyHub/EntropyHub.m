function Fig_Handle = EntropyHub()
%  ___  _   _  _____  _____  ____  ____  _     _          
% |  _|| \ | ||_   _||     \|    ||    || \   / |   ___________ 
% | \_ |  \| |  | |  |   __/|    ||  __| \ \_/ /   /  _______  \
% |  _|| \ \ |  | |  |   \  |    || |     \   /   |  /  ___  \  |
% | \_ | |\  |  | |  | |\ \ |    || |      | |    | |  /   \  | | 
% |___||_| \_|  |_|  |_| \_||____||_|      |_|   _|_|__\___/  | | 
%  _   _  _   _  ____                           / |__\______\/  | 
% | | | || | | ||    \     An open-source      |  /\______\__|_/ 
% | |_| || | | ||    |     toolkit for         | |  /   \  | | 
% |  _  || | | ||    \     entropic time-      | |  \___/  | |          
% | | | || |_| ||     \    series analysis     |  \_______/  |
% |_| |_|\_____/|_____/                         \___________/ 
% 
% 
% EntropyHub functions belong to one of five main classes/categories:
% Base Entropies             >>  e.g. Approximate Entropy (ApEn),
%                                     Sample Entropy (SampEn)
% Cross Entropies            >>  e.g. Cross-Approximate Entropy (XApEn)
%                                     Cross-Sample Entropy (XSampEn)
% Bidimensional Entropies    >>  e.g. Bidimensional Sample Entropy (SampEn2D)
%                                     Bidimensional Fuzzy Entropy (FuzzEn2D)
% Multiscale Entropies       >>  e.g. Multiscale Sample Entropy (MSEn)
%                                     Refined Multiscale Sample Entropy (rMSEn)
%                                     Composite Multiscale Sample Entropy (cMSEn)
% Multiscale Cross Entropies >>  e.g. Multiscale Cross-Sample Entropy (XMSEn)
%                                     Refined Multiscale Cross-Sample Entropy (rXMSEn)
% 
% _________________________________________________________________________
% Base Entropies                                       	|	Function Name
% ______________________________________________________|__________________
% Approximate Entropy                               	|	ApEn
% Sample Entropy                                    	|	SampEn
% Fuzzy Entropy                                     	|	FuzzEn
% Kolmogorov Entropy                                	|	K2En
% Permutation Entropy                               	|	PermEn
% Conditional Entropy                               	|	CondEn
% Distribution Entropy                              	|	DistEn
% Spectral Entropy                                  	|	SpecEn
% Dispersion Entropy                                	|	DispEn
% Symbolic Dynamic Entropy                          	|	SyDyEn
% Increment Entropy                                 	|	IncrEn
% Cosine Similarity Entropy                         	|	CoSiEn
% Phase Entropy                                        	|	PhasEn
% Slope Entropy                                      	|	SlopEn
% Bubble Entropy                                        |	BubbEn
% Gridded Distribution Entropy                          |	GridEn
% Entropy of Entropy                                    |	EnofEn
% Attention Entropy                                     |	AttnEn
% 
% _________________________________________________________________________
% Cross Entropies                                       |	Function Name
% ______________________________________________________|__________________
% Cross Sample Entropy                                  |	XSampEn
% Cross Approximate Entropy                             |	XApEn
% Cross Fuzzy Entropy                                   |	XFuzzEn
% Cross Permutation Entropy                             |	XPermEn
% Cross Conditional Entropy                             |	XCondEn
% Cross Distribution Entropy                            |	XDistEn
% Cross Spectral Entropy                                |	XSpecEn
% Cross Kolmogorov Entropy                             	|	XK2En
% 	
% _________________________________________________________________________
% Bi-Dimensional Entropies                              |	Function Name
% ______________________________________________________|__________________
% Bi-Dimensional Sample Entropy                         |	SampEn2D
% Bi-Dimensional Fuzzy Entropy                          |	FuzzEn2D
% Bi-Dimensional Distribution Entropy                   |	DistEn2D
% Bi-Dimensional Dispersion Entropy                     |	DispEn2D
% 	
% _________________________________________________________________________
% Multiscale Entropy Functions                          | Function Name
% ______________________________________________________|__________________ 
% Multiscale Entropy Object                             |   MSobject
%                                                       |
% Multiscale Entropy                                    |   MSEn
% Composite/Refined-Composite Multiscale Entropy        |   cMSEn
% Refined Multiscale Entropy                            |   rMSEn
% Hierarchical Multiscale Entropy Object                |   hMSEn
% 
% _________________________________________________________________________
% Multiscale Entropies	MSEn                            |	Function Name
% ______________________________________________________|__________________
% Multiscale Sample Entropy                             |	
% Multiscale Approximate Entropy                        |	
% Multiscale Fuzzy Entropy                              |	
% Multiscale Permutation Entropy                        |	
% Multiscale Dispersion Entropy                         |	
% Multiscale Cosine Similarity Entropy                  |	
% Multiscale Symblic Dynamic Entropy                    |	MSobject
% Multiscale Conditional Entropy                        |	     +
% Multiscale Entropy of Entropy                         |   MSEn / cMSEn
% Multiscale Gridded Distribution Entropy               |	rMSEn / hMSEn
% Multiscale Slope Entropy                              |
% Multiscale Phase Entropy                              |		
% Multiscale Kolmogorov Entropy                         |	
% Multiscale Distribution Entropy                    	|	
% Multiscale Bubble Entropy                            	|	
% Multiscale Increment Entropy                        	|	
% Multiscale Attention Entropy                          |	
% 	
% _________________________________________________________________________
% Multiscale Cross-Entropy Functions                    |   Function Name
% ______________________________________________________|__________________
% Multiscale Cross-Entropy Object                       |   MSobject
%                                                       |
% Multiscale Cross-Entropy                              |   XMSEn
% Composite/Refined-Composite Multiscale Cross-Entropy  |   cXMSEn
% Refined Multiscale Entropy                            |   rXMSEn
% Hierarchical Multiscale Entropy Object                |   hXMSEn
% 
% _________________________________________________________________________
% Multiscale Cross-Entropies                            |	Function Name
% ______________________________________________________|__________________
% Multiscale Cross-Sample Entropy                       |	
% Multiscale Cross-Approximate Entropy                  |	
% Multiscale Cross-Fuzzy Entropy                        |	MSobject
% Multiscale Cross-Permutation Entropy                  |	    +
% Multiscale Cross-Distribution Entropy                 |	XMSEn / cXMSEn
% Multiscale Cross-Kolmogorov Entropy                   |   rXMSEn / hXMSEn
% Multiscale Cross-Conditional Entropy                  |	
% 
% 
% This package is open for use by all in accordance with the terms of the 
% attached License agreement. Any scientific outputs obtained using 
% EntropyHub are required to include the following citation:
% 
%   Matthew W. Flood and Bernd Grimm, 
%   "EntropyHub: An open-source toolkit for entropic time series analysis",
%   2021, https://github.com/MattWillFlood/EntropyHub
% 
%   © Copyright 2021 Matthew W. Flood, EntropyHub
% 
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
% 
%        http://www.apache.org/licenses/LICENSE-2.0
% 
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
% 
%   For Terms of Use see https://github.com/MattWillFlood/EntropyHub

fprintf(['\n',...    
' ___  _   _  _____  _____  ____  ____  _     _                  \n', ...        
'|  _|| \\ | ||_   _||     \\|    ||    || \\   / |   ___________   \n', ...   
'| \\_ |  \\| |  | |  |   __/|    ||  __| \\ \\_/ /   /  _______  \\  \n', ...   
'|  _|| \\ \\ |  | |  |   \\  |    || |     \\   /   |  /  ___  \\  | \n', ...   
'| \\_ | |\\  |  | |  | |\\ \\ |    || |      | |    | |  /   \\  | | \n', ...   
'|___||_| \\_|  |_|  |_| \\_||____||_|      |_|   _|_|__\\___/  | | \n', ...   
' _   _  _   _  ____                           / |__\\______\\/  | \n', ...   
'| | | || | | ||    \\     An open-source      |  /\\______\\__|_/  \n', ...   
'| |_| || | | ||    |     toolkit for         | |  /   \\  | |    \n', ...   
'|  _  || | | ||    \\     entropic time-      | |  \\___/  | |    \n', ...        
'| | | || |_| ||     \\    series analysis     |  \\_______/  |    \n', ...   
'|_| |_|\\_____/|_____/                         \\___________/     \n'])   


fprintf(['\nFor information on any specific EntropyHub Function, type:\n',...
        'help functionname (e.g. help CoSiEn)\n        or \n',...
        'doc functionname (e.g. doc DistEn2D)\n\n',...
        'See the EntropyHub guide for detailed examples of EntropyHub functions.\n',...
        '(https://www.entropyhub.xyz/matlab/EHmatlab.html)\n\n'])
    
Fig_Handle = 'EntropyHub_profiler2.png';

end