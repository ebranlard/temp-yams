%%
clear all;
clc;
restoredefaultpath;
old_dir=pwd;
addpath(genpath('C:/Work/FAST/matlab-toolbox/'));
addpath(genpath('code/'))
addpath('gen/')

%% Parameters
base_path= '5MW_Land_DLL_WTurb'; %<<<<< FOR NOW "turbine*.mac depends on this location
% 
%% Step 1 create Bld and Twr SID from 
% disp('>>> FAST2CADynTurb')
% fst_file= 'data/5MW_Baseline/5MW_Land_DLL_WTurb.fst';
% [param, data, tw_sid, bd_sid]= FAST2CADynTurb(fst_file);
% save('_output/param.mat', 'param')
% save('_output/tw_sid.mat', 'tw_sid')
% save('_output/bd_sid.mat', 'bd_sid')

load('_output/param.mat');
load('_output/tw_sid.mat');
load('_output/bd_sid.mat');
% 
% %%
% fprintf('Writing: %s \n',[base_path '_tw_sid.mac']);
% fprintf('Writing: %s \n',[base_path '_bd_sid.mac']);
% disp('>>> Write Maxima')
% write_sid_maxima(tw_sid, [base_path '_tw_sid'], 'tower', length(tw_sid.frame), 1e-5, 1)
% write_sid_maxima(bd_sid, [base_path '_bd_sid'], 'blade', []                  , 1e-5, 1)
% 
%%
disp('>>> Make Mex')
% setenv('maxima_path', '/usr/bin/maxima')
setenv('maxima_path','C:/Bin/maxima-5.42.2/bin/maxima.bat')
setenv('cagem_path', 'C:/Work/Atlantis/_StructuralModel/Jens/CADynEssentials/gen/cagem.mac')
setenv('eigen_path', 'C:/Bin/Eigen')
makeMex('turbine_coll_flap_edge_pitch_aero.mac')

%%
% params_turbine
% sim_turbine
% plot_turbine
