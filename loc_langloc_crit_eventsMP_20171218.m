
%% DO NOT FORGET TO CHANGE OUTPUT DIRECTORY
outputdir = '/mindhive/evlab/u/mekline/Documents/Projects/EventsMP_Pilot2/loc_langloc_crit_eventsMP_20171218/';

experiments(1)=struct(...
    'name','loc',...% language localizer 
    'pwd1','/mindhive/evlab/u/Shared/SUBJECTS',...  % path to the data directory
    'pwd2','firstlevel_langlocSN',... % path to the first-level analysis directory for the lang localizer
    'data',{{ ...
        '334_FED_20151119a_3T2_PL2017',...
        '479_FED_20161104a_3T2_PL2017',...
        '522_FED_20161228e_3T2_PL2017',...
        '516_FED_20161217a_3T2_PL2017',...
        '424_FED_20161102b_3T1_PL2017',...
        '426_FED_20160908d_3T1_PL2017'
        }}); % subject IDs
       
experiments(2)= struct(...
    'name','crit',...
    'pwd1','/mindhive/evlab/u/Shared/SUBJECTS',... 
    'pwd2','firstlevel_EventsMP',...
    'data',{{ ...
        '334_FED_20161221a_3T2_PL2017',...
        '479_FED_20161228d_3T2_PL2017',...
        '522_FED_20161228e_3T2_PL2017',...
        '516_FED_20161217a_3T2_PL2017',...
        '424_FED_20161228c_3T2_PL2017',...
        '426_FED_20161215c_3T2_PL2017'
        }});% important that this is the same order as above
%TEMP REMOVED FOR BROKEN PERMISSIONS
            
    %% DO NOT FORGET TO CHANGE OUTPUT DIRECTORY

localizer_spmfiles={};
for nsub=1:length(experiments(1).data),
    localizer_spmfiles{nsub}=fullfile(experiments(1).pwd1,experiments(1).data{nsub},experiments(1).pwd2,'SPM.mat');
end

effectofinterest_spmfiles={};
for nsub=1:length(experiments(2).data),
    effectofinterest_spmfiles{nsub}=fullfile(experiments(2).pwd1,experiments(2).data{nsub},experiments(2).pwd2,'SPM.mat');
end

ss=struct(...
    'swd', outputdir,...   % output directory
    'EffectOfInterest_spm',{effectofinterest_spmfiles},...
    'Localizer_spm',{localizer_spmfiles},...
    'EffectOfInterest_contrasts', {{'SameAll','SameMan','SamePath','SameAg','DiffAll','Cont','DiffAll-Cont','SameMan-Cont','SamePath-Cont', 'SameAg-Cont','SameAll-Cont','All-Cont','DiffAll-SameAll','DiffAll-SameMan','DiffAll-SamePath','DiffAll-SameAg', 'SameMan-SameAll','SamePath-SameAll','SameAg-SameAll'  }},...    % contrasts of interest; here you just indicate t
    'Localizer_contrasts',{{'S-N'}},...                     % localizer contrast 
    'Localizer_thr_type','percentile-ROI-level',...  % appendix F, paper by Alfonso & Ev, 2012, has all the options
    'Localizer_thr_p',0.1,... % proportion, not actually significance level (what proportion of ROI will be used, IF localizer_thr_type is percentile-ROI-level
    'type','mROI',...                                       % can be 'GcSS', 'mROI', or 'voxel'
    'ManualROIs','/users/evelina9/fMRI_PROJECTS/ROIS/LangParcels_n220_LH.img',... % predefined, this is the one we usually use, ask beforehand
    'model',1,...    % can be 1 (one-sample t-test), 2 (two-sample t-test), or 3 (multiple regression), usually 1
    'estimation','OLS',... % basically always use, ordinary least squares, as opposed to ReML
    'overwrite',true,... % clears stuff from earlier toolbox analyses
    'ExplicitMasking',[],...
    'ask','missing');    % can be 'none' (any missing information is assumed to take default values), 'missing' (any missing information will be asked to the user), 'all' (it will ask for confirmation on each parameter)

addpath('/software/spm12');
addpath('/users/evelina9/fMRI_PROJECTS/spm_ss_vE/');
addpath('/mindhive/evlab/u/bpritche/Documents/fMRI_analyses/Toolbox/spm_ss_Apr4-2016'); %set spm_ss version here!

addpath /software/spm_ss/

ss=spm_ss_design(ss);    % see help spm_ss_design for additional information
ss=spm_ss_estimate(ss);  % can be found in /software/spm_ss


% spm_ss_display and spm_ss_results allow you to interface with your
% results and visualize things
% spm_ss_watershed lets you visualize that probabilistic hilly space
