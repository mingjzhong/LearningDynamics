%
% RunExamples
%
% (c) Mauro Maggioni, JHU

%% Set parameters
if ispc, SAVE_DIR = [getenv('USERPROFILE'), '\DataAnalyses\LearningDynamics']; 
else, SAVE_DIR = [getenv('HOME'), '/DataAnalyses/LearningDynamics']; end                            % Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like   
VERBOSE                 = 0;

TEST_ON_TRAJECTORIES    = false;

if ~exist('Params','var'),  Params = []; end
if ~exist(SAVE_DIR,'dir'),  mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
Examples            = LoadExampleDefinitions('MLtest');
ExampleIdx          = SelectExample(Params, Examples);

%% Get example parameters
Example             = Examples{ExampleIdx};
sys_info            = Example.sys_info;
solver_info         = Example.solver_info;
obs_info            = Example.obs_info;                                                             % move n to learn_info
learn_info          = Example.learn_info;

reuse_rho_T         = true;                                                                         % !!! unsafe unless sure that the parameters are the same !!!
reuse_trajectories  = true;                                                                         % !!! unsafe unless sure that the parameters are the same !!!
reuse_runs          = true;                                                                         % !!! unsafe unless sure that the parameters are the same !!!
save_trajectories   = true;
save_results_at_every_run = false;
n_trials            = 1;                                                                            % Number of learning rounds

% Parameters specific to experiments for the M-L plane plots
n_MAX                       = 1024;
M_plane                     = unique([1,max(1,ceil(2.^(-4:4).*obs_info.M))]);
L_plane                     = unique(max(1,ceil(2.^(-4:2).*obs_info.L)));
n_plane                     = {@(x,y) 2*min(x,n_MAX), @(x,y) 2*ceil(sqrt(min(x,n_MAX))), @(x,y) 2*ceil(min(y,n_MAX)), @(x,y) 2*min(x*y,n_MAX), @(x,y) 2*ceil(sqrt(min(x*y,n_MAX)))};   % Make sure n is even for piecewise linear poly'ss
obs_info.use_derivative     = true;

learn_info.sys_info         = sys_info;
learn_info.is_parallel      = true;                                                                 % Some fine-tuning of learning parameters
learn_info.keep_obs_data    = true;
learn_info.VERBOSE          = VERBOSE;
learn_info.SAVE_DIR         = SAVE_DIR;
learn_info.MEMORY_LEAN      = true;
obs_info.compute_pICs       = false;
obs_info.VERBOSE            = VERBOSE;
obs_info.SAVE_DIR           = SAVE_DIR;


%% Generate \rho^L_T if needed
fprintf('\n================================================================================');
fprintf('\nGenerating rhoT...');tic_rhoLT=tic;
obs_info.rhoLT              = generateRhoLT( sys_info, solver_info, obs_info, reuse_rho_T );
fprintf('done (%.2f).',toc(tic_rhoLT));

%% Perform Learning for all values of M and L
obs_info_time_I = [obs_info.time_vec(1),obs_info.time_vec(end)];                                    % Use fixed time interval

if ~exist('learningOutput')
    learningOutput = cell(length(L_plane),1);
    for l = 1:length(L_plane)
        learningOutput{l} = cell(length(M_plane),length(n_plane),n_trials);
    end
end

fprintf('\n Generating trajectories...');
if ~exist(sprintf('%s',SAVE_DIR),'dir'),    mkdir(sprintf('%s',SAVE_DIR));      end

for k = 1:n_trials
    filename            = sprintf('%s/%s_traj_%d.mat',SAVE_DIR,sys_info.name,k);
    if ~reuse_trajectories || ~exist(filename,'file')
        Timings.generateObservations = tic;
        % Use the same trajectories for all
        fprintf('\nGenerating observations for trial %d/%d...',k,n_trials);tic_obs=tic;
        obs_data_all        = generateObservations( sys_info, solver_info, obs_info, max(M_plane) );
        obs_data_all.x      = [];
        obs_data_all.xp     = [];
        fprintf('done (%.2f sec).',toc(tic_obs));
        Timings.generateObservations = toc(Timings.generateObservations);
        
        if save_trajectories
            save(filename,  '-v7.3', 'sys_info', 'solver_info','obs_info','obs_data_all','Timings');
        end
    else
        fprintf('loading...');
        load(filename,'obs_data_all','Timings');
        fprintf('done.');
    end
    Timings_total = zeros(length(M_plane),1,'uint64');
    for Midx = 1:length(M_plane)
        obs_info.M  = M_plane(Midx);
        Timings_total(Midx) = tic;
        for Lidx = 1:length(L_plane)
            obs_info_cur        = obs_info;
            obs_info_cur.L      = L_plane(Lidx);
            if obs_info_cur.M*obs_info_cur.L < 2, continue; end
            obs_info_cur.time_vec   = linspace(obs_info_time_I(1), obs_info_time_I(2), obs_info_cur.L);
            
            nidx = 1;
            learn_info_cur  = learn_info;
            if isfield(learn_info_cur,'Ebasis_info') && ~isempty(learn_info_cur.Ebasis_info),   learn_info_cur.Ebasis_info.n = n_plane{nidx}(obs_info_cur.M,obs_info_cur.L)*ones(sys_info.K,sys_info.K); ntmp = learn_info_cur.Ebasis_info.n; end
            if isfield(learn_info_cur,'Abasis_info') && ~isempty(learn_info_cur.Abasis_info),   learn_info_cur.Abasis_info.n = n_plane{nidx}(obs_info_cur.M,obs_info_cur.L)*ones(sys_info.K,sys_info.K); ntmp = learn_info_cur.Abasis_info.n; end
            if isfield(learn_info_cur,'Xibasis_info') && ~isempty(learn_info_cur.Xibasis_info), learn_info_cur.Xibasis_info.n = n_plane{nidx}(obs_info_cur.M,obs_info_cur.L)*ones(sys_info.K,sys_info.K);ntmp = learn_info_cur.Xibasis_info.n;end
            
            tic_learningroutine = tic;
            fprintf('\n M(%d/%d)=%d,L(%d/%d)=%d,n(%d/%d)=%d...',...
                Midx,length(M_plane),obs_info_cur.M, ...
                Lidx,length(L_plane),obs_info_cur.L, ...
                nidx,length(n_plane),ntmp );
            if reuse_runs && ~isempty(learningOutput{Lidx}{Midx,nidx,k}), fprintf('...skipping...'); continue; end
            
            learningOutput{Lidx}{Midx,nidx,k}   = learningRoutine( solver_info, obs_info_cur, learn_info_cur, obs_data_all ); % Learning
            learningOutput{Lidx}{Midx, nidx, k}.L2rhoTErr = computeL2rhoTErr(learningOutput{Lidx}{Midx,nidx,k}.Estimator, sys_info, obs_info_cur);
            fprintf('done (%.2f sec).',toc(tic_learningroutine));
            
            for nidx = 2:length(n_plane)
                if reuse_runs && ~isempty(learningOutput{Lidx}{Midx,nidx,k}), fprintf('...skipping...'); continue; end
                n_actual{Midx,Lidx,nidx}        = n_plane{nidx}(obs_info_cur.M,obs_info_cur.L)*ones(sys_info.K,sys_info.K);
                if isfield(learn_info_cur,'Ebasis_info') && ~isempty(learn_info_cur.Ebasis_info),   learn_info_cur.Ebasis_info.n = n_plane{nidx}(obs_info_cur.M,obs_info_cur.L)*ones(sys_info.K,sys_info.K); ntmp = learn_info_cur.Ebasis_info.n; end
                if isfield(learn_info_cur,'Abasis_info') && ~isempty(learn_info_cur.Abasis_info),   learn_info_cur.Abasis_info.n = n_plane{nidx}(obs_info_cur.M,obs_info_cur.L)*ones(sys_info.K,sys_info.K); ntmp = learn_info_cur.Abasis_info.n; end
                if isfield(learn_info_cur,'Xibasis_info') && ~isempty(learn_info_cur.Xibasis_info), learn_info_cur.Xibasis_info.n = n_plane{nidx}(obs_info_cur.M,obs_info_cur.L)*ones(sys_info.K,sys_info.K);ntmp = learn_info_cur.Xibasis_info.n;end
                tic_learningroutine = tic;
                fprintf('\n M(%d/%d)=%d,L(%d/%d)=%d,n(%d/%d)=%d...',Midx,length(M_plane),obs_info_cur.M, Lidx,length(L_plane),obs_info_cur.L, nidx,length(n_plane),ntmp );
                learningOutput{Lidx}{Midx,nidx,k}   = learningRoutine( solver_info, obs_info_cur, learn_info_cur, obs_data_all ); % Learning
                learningOutput{Lidx}{Midx, nidx, k}.L2rhoTErr = computeL2rhoTErr(learningOutput{Lidx}{Midx,nidx,k}.Estimator, sys_info, obs_info_cur);
                if TEST_ON_TRAJECTORIES                                                             % Perform learning and test performance on trajectories
                    [learningOutput{Lidx}{Midx,nidx,k}.trajErr, learningOutput{Lidx}{Midx,nidx,k}.trajErr_new, testTraj.obs_true, testTraj.obs_hat, testTraj.obs_new_true, testTraj.obs_new_hat] = ...
                        estimateTrajAccuracies( sys_info, learningOutput{Lidx}{Midx,nidx,k}.syshatsmooth_info, learningOutput{Lidx}{Midx,nidx,k}.obs_data, obs_info, solver_info );             % Testing performance on trajectories
                end
                fprintf('done (%.2f sec).',toc(tic_learningroutine));
            end
            for nidx = 1:length(n_plane)
                learningOutput{Lidx}{Midx,nidx,k}.obs_data.traj = [];
                learningOutput{Lidx}{Midx,nidx,k}.obs_data.x    = [];
                learningOutput{Lidx}{Midx,nidx,k}.obs_data.xp   = [];
                learningOutput{Lidx}{Midx,nidx,k}.Estimator.Phi = [];
            end
        end
        Timings_total(Midx) = toc(Timings_total(Midx));
        % Save data
        if save_results_at_every_run
            fprintf('\n..saving...');saving_tic=tic;
            save(sprintf('%s/%s_learningOutput%s_%s(M=%d).mat',SAVE_DIR,sys_info.name,datestr(datetime('now')),char(getHostName(java.net.InetAddress.getLocalHost)),obs_info.M),'-v7.3', ...
                'sys_info','solver_info','obs_info','learn_info','learningOutput','Timings_total','M_plane','L_plane','n_actual');
            fprintf('done (%.2f sec).',toc(saving_tic));
        end
    end
end

%% Results
%Err_Rel_smooth = zeros( size(learningOutput,1),size(learningOutput,2),length(n_plane),length(learningOutput{1,1}) );
Err_Rel_EErr = []; Err_Rel_AErr = []; Err_Rel_XiErr = [];
for Lidx = 1:size(learningOutput,1)
    for Midx = 1:size(learningOutput{Lidx},1)
        for nidx = 1:size(learningOutput{Lidx},2)
            for k = 1:size(learningOutput{Lidx},3)
                try
                    Err_Rel_EErr(Midx,Lidx,nidx,k,:,:) = learningOutput{Lidx}{Midx,nidx,k}.L2rhoTErr.EErrSmooth.Rel;
                catch
                end
                try
                    Err_Rel_AErr(Midx,Lidx,nidx,k,:,:) = learningOutput{Lidx}{Midx,nidx,k}.L2rhoTErr.AErrSmooth.Rel;
                catch
                end
                try
                    Err_Rel_XiErr(Midx,Lidx,nidx,k,:,:) = learningOutput{Lidx}{Midx,nidx,k}.L2rhoTErr.XiErrSmooth.Rel;
                catch
                end
            end
        end
    end
end



%% figures
for k_1 = 1:size(Err_Rel_EErr,5)
    for k_2 = 1:size(Err_Rel_EErr,6)        
        if exist('Err_Rel_EErr') && ~isempty(Err_Rel_EErr)
            try
                figure(1);subplot(size(Err_Rel_EErr,5),size(Err_Rel_EErr,6),(k_1-1)*size(Err_Rel_EErr,6)+k_2);
                imagesc(flipud(min(mean(Err_Rel_EErr(:,:,:,:,k_1,k_2),4),[],3)));colorbar;set(gca,'YTickLabels',fliplr(M_plane));set(gca,'XTickLabels',L_plane);title(sprintf('Interaction E-kernel (%d,%d)',k_1,k_2));ylabel('M');xlabel('L');
                
                figure(2);subplot(size(Err_Rel_EErr,5),size(Err_Rel_EErr,6),(k_1-1)*size(Err_Rel_EErr,6)+k_2);
                imagesc(flipud(log10(min(mean(Err_Rel_EErr(:,:,:,:,k_1,k_2),4),[],3))));colormap(gray);colorbar;set(gca,'YTickLabels',fliplr(M_plane));set(gca,'XTickLabels',L_plane);set(gcf,'Name',sprintf('Interaction E-kernel (%d,%d)',k_1,k_2));ylabel('M');xlabel('L');
            catch
            end
        end
        if exist('Err_Rel_AErr') && ~isempty(Err_Rel_AErr)
            try
                figure(3);subplot(size(Err_Rel_EErr,5),size(Err_Rel_EErr,6),(k_1-1)*size(Err_Rel_EErr,6)+k_2);
                imagesc(flipud(min(mean(Err_Rel_AErr(:,:,:,:,k_1,k_2),4),[],3)));colorbar;set(gca,'YTickLabels',fliplr(M_plane));set(gca,'XTickLabels',L_plane);title(sprintf('Interaction A-kernel (%d,%d)',k_1,k_2));ylabel('M');xlabel('L');
                
                figure(4);subplot(size(Err_Rel_EErr,5),size(Err_Rel_EErr,6),(k_1-1)*size(Err_Rel_EErr,6)+k_2);
                imagesc(flipud(log10(min(mean(Err_Rel_AErr(:,:,:,:,k_1,k_2),4),[],3))));colormap(gray);colorbar;set(gca,'YTickLabels',fliplr(M_plane));set(gca,'XTickLabels',L_plane);set(gcf,'Name',sprintf('Interaction A-kernel (%d,%d)',k_1,k_2));ylabel('M');xlabel('L');
            catch
            end
        end
        if exist('Err_Rel_XiErr') && ~isempty(Err_Rel_XiErr)
            try
                figure(5);subplot(size(Err_Rel_EErr,5),size(Err_Rel_EErr,6),(k_1-1)*size(Err_Rel_EErr,6)+k_2);
                imagesc(flipud(min(mean(Err_Rel_XiErr(:,:,:,:,k_1,k_2),4),[],3)));colorbar;set(gca,'YTickLabels',fliplr(M_plane));set(gca,'XTickLabels',L_plane);title(sprintf('Interaction Xi-kernel (%d,%d)',k_1,k_2));ylabel('M');xlabel('L');
                
                figure(6);subplot(size(Err_Rel_EErr,5),size(Err_Rel_EErr,6),(k_1-1)*size(Err_Rel_EErr,6)+k_2);
                imagesc(flipud(log10(min(mean(Err_Rel_XiErr(:,:,:,:,k_1,k_2),4),[],3))));colormap(gray);colorbar;set(gca,'YTickLabels',fliplr(M_plane));set(gca,'XTickLabels',L_plane);set(gcf,'Name',sprintf('Interaction Xi-kernel (%d,%d)',k_1,k_2));ylabel('M');xlabel('L');
            catch
            end
        end
    end
end
%figure;imagesc(flipud(mean(mean(Err_Rel_smooth,4),3)));colorbar;
%figure;imagesc(flipud(max(mean(Err_Rel_smooth,4),[],3)));colorbar;

%% SAVING
save( sprintf('%s/%s_learningOutputFigErr_%s_%s_.mat',SAVE_DIR,sys_info.name,datestr(datetime('now')),char(getHostName(java.net.InetAddress.getLocalHost))),...
    '-v7.3','sys_info','solver_info','obs_info','learn_info','Err_Rel_EErr','Err_Rel_AErr','Err_Rel_XiErr','M_plane','L_plane' );

%%
fprintf('\nSaving...');
save( sprintf('%s/%s_learningOutputAll_%s_%s_.mat',SAVE_DIR,sys_info.name,datestr(datetime('now')),char(getHostName(java.net.InetAddress.getLocalHost))),...
    '-v7.3','sys_info','solver_info','obs_info','learn_info','learningOutput','Err_Rel_EErr','L_plane','M_plane','n_plane' );
fprintf('done.');
%% Done
fprintf('\ndone.\n');

return