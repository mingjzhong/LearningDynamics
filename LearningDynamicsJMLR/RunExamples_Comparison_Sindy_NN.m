%
% RunExamples and do comparison with SINDY and NN nettworks
%
% (c) M. Maggioni, M. Zhong (JHU)
%  Comparison test added by S. Tang (UCSB)


%delete(gcp('nocreate'));

%parpool(20);

clear all;
close all;
Startup_LearningDynamics

%% Set parameters
SAVE_DIR                        = '~/DataAnalyses/LearningDynamics';                                % Please keep this fixed, simply create a symlink ~/DataAnalyses pointing wherever you like
VERBOSE                         = 1;                                                                % indicator to print certain output
if ~exist('Params','var'), Params = [];     end
if ~exist(SAVE_DIR,'dir'), mkdir(SAVE_DIR); end

%% Load example definitions and let user select one example to run
Examples                        = LoadExampleDefinitions(); % Change parameters in each example 
ExampleIdx                      = SelectExample(Params, Examples);

%% Get example parameters
Example                         = Examples{ExampleIdx};
sys_info                        = Example.sys_info;
solver_info                     = Example.solver_info;
obs_info                        = Example.obs_info;                                                 % move n to learn_info
learn_info                      = Example.learn_info;
plot_info                       = Example.plot_info;

reuse_rho_T                     = true;
n_trials                        = 1;                                                                % Number of learning rounds

learn_info.to_predict_LN        = false;
learn_info.is_parallel          = false;                                                            % Some fine-tuning of learning parameters
learn_info.keep_obs_data        = true;
learn_info.VERBOSE              = VERBOSE;
learn_info.SAVE_DIR             = SAVE_DIR;
learn_info.MEMORY_LEAN          = true;
obs_info.compute_pICs           = false;
obs_info.VERBOSE                = VERBOSE;
obs_info.SAVE_DIR               = SAVE_DIR;


obs_info.obs_noise              = 0.0;
if obs_info.obs_noise>0
    obs_info.use_derivative     = true;
end

%% Start parallel pool
gcp

time_stamp                      = datestr(now, 30);

%% Generate \rho^L_T if needed
fprintf('\n================================================================================');
fprintf('\nGenerating rhoT......');
obs_info.rhoLT                  = generateRhoLT( sys_info, solver_info, obs_info, reuse_rho_T );
fprintf('done (%.2f sec).',obs_info.rhoLT.Timings);

%% Perform learning and test performance on trajectories
learn_tic = tic;
learningOutput                  = cell(1,n_trials);
learn_info.sys_info             = sys_info;
fprintf('\n================================================================================');
fprintf('\nLearning Interaction Law(s)......');
for trial_idx = 1:n_trials
    if VERBOSE >= 1, fprintf('\n------------------- Learning with trial ID#%3d.', trial_idx); end
    learningOutput{trial_idx}     = learningRoutine( solver_info, obs_info, learn_info );               % Learning
end
fprintf('\n------------------- Overall time for learning: %.2f',toc(learn_tic));

%% Test performance on trajectories
fprintf('\n================================================================================');
trajErr_tic = tic;
fprintf('\nComputing Trajectory Errors......');
rStr        = '';
fprintf('\n------------------- Trajectory Error with trial ID#: ');
for k = n_trials:-1:1
    learningOutput{k}.Timings.estimateTrajAccuracies = tic;
    [learningOutput{k}.trajErr,learningOutput{k}.trajErr_new]     = ...
        estimateTrajAccuracies( sys_info, learningOutput{k}.syshatsmooth_info, learningOutput{k}.obs_data, obs_info, solver_info );                                            % Testing performance on trajectories
    learningOutput{k}.Timings.estimateTrajAccuracies = toc( learningOutput{k}.Timings.estimateTrajAccuracies );
    msg                                              = sprintf('%3d', k);
    fprintf([rStr, msg]);
    rStr                                             = repmat(sprintf('\b'), 1, length(msg));
end
fprintf('\n------------------- Overall time for computing trajecotry errors: %.2f',toc(trajErr_tic));

%% Test performance on transfer to system with more agents
if isfield(learn_info, 'to_predict_LN') && learn_info.to_predict_LN
    fprintf('\n================================================================================');
    trajErr_tic = tic;
    fprintf('\nComputing Trajectory Errors for Larger N......');
    rStr        = '';
    fprintf('\n------------------- Trajectory Error with trial ID#: ');
    sys_info_Ntransfer                                           = restructure_sys_info_for_larger_N( learn_info.N_ratio, sys_info );
    for k = n_trials:-1:1
        learningOutput{k}.syshatsmooth_info_Ntransfer              = restructure_sys_info_for_larger_N( learn_info.N_ratio, learningOutput{k}.syshatsmooth_info );
        learningOutput{k}.Timings.estimateTrajAccuracies_Ntransfer = tic;
        learningOutput{k}.y_init_Ntransfer                         = generateICs( obs_info.M_test, sys_info_Ntransfer );
        learningOutput{k}.trajErr_new_Ntransfer                    = computeTrajectoryAccuracy( sys_info_Ntransfer, ...
            learningOutput{k}.syshatsmooth_info_Ntransfer, solver_info, obs_info, learningOutput{k}.y_init_Ntransfer );
        learningOutput{k}.Timings.estimateTrajAccuracies_Ntransfer = toc( learningOutput{k}.Timings.estimateTrajAccuracies_Ntransfer );
        msg                                                        = sprintf('%3d', k);
        fprintf([rStr, msg]);
        rStr                                                       = repmat(sprintf('\b'), 1, length(msg));
    end
    fprintf('\n------------------- Overall time for computing trajectory errors: %.2f',toc(trajErr_tic));
else
    sys_info_Ntransfer                                           = [];
end



%% Display & figures
if VERBOSE >= 1
    [Mean_traj_errors,Std_traj_errors] = final_visualization(learningOutput, obs_info, solver_info, sys_info, sys_info_Ntransfer, learn_info, time_stamp, plot_info);
end


%% Save
save(sprintf('%s/%s_learningOutput%s.mat', SAVE_DIR, sys_info.name, time_stamp), '-v7.3', 'sys_info', 'solver_info', 'obs_info', 'learn_info', 'plot_info', ...
    'learningOutput', 'sys_info_Ntransfer', 'time_stamp','Mean_traj_errors','Std_traj_errors');

%% Done
fprintf('\ndone.\n');



%% performance of our algoritms on fitting fphi-the RHS of dynamical systems  on the  data sets

traj_Err_Train = learningOutput{1,1}.trajErr;
observations_true = traj_Err_Train.obs_true.observation;% Nd x L x M
observationsfuture_true = traj_Err_Train.obs_true.observationfuture;% Nd x L x M

obsfut_true =  reshape(observationsfuture_true,sys_info.d*sys_info.N,[]); % Nd x ML
obs_true = reshape(observations_true,sys_info.d*sys_info.N,[]); % Nd x ML



for l=1: size(obs_true,2)
    dxdata_true(:,l)                   = eval_rhs(obs_true(:,l), sys_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    hatdxdata_true(:,l)                   = eval_rhs(obs_true(:,l), learningOutput{1,1}.syshat_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    
end

for l=1: size(obsfut_true,2)
    dxdata_fut(:,l)                   = eval_rhs( obsfut_true(:,l), sys_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    hatdxdata_fut(:,l)                   = eval_rhs(obsfut_true(:,l), learningOutput{1,1}.syshat_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    
end
%
fprintf('\n--- RMSE of our algorithm of fitting fphi for Training ICs on training time interval is: %10.4e',norm(hatdxdata_true-dxdata_true)./norm(dxdata_true));
fprintf('\n--- RMSE of our algorithm of fitting fphi for Training ICS on future time interval is: %10.4e',norm( hatdxdata_fut-dxdata_fut)./norm(dxdata_fut));


%%  test data on training time interval and future time interval

traj_Err_new = learningOutput{1,1}.trajErr_new; % do only for one trial learning
observations_true_new = traj_Err_new.obs_true.observation; % Nd x L x M
observationsfuture_true_new = traj_Err_new.obs_true.observationfuture;% Nd x L x M

obs_new = reshape(observations_true_new,sys_info.d*sys_info.N,[]);
obsfut_new =  reshape(observationsfuture_true_new,sys_info.d*sys_info.N,[]);

dxdata_test = obs_new;
dxdatafut_test = obsfut_new;

for l= 1:size(obs_new,2)
    dxdata_test(:,l)                   = eval_rhs(obs_new(:,l), sys_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    hatdxdata_test(:,l)                   = eval_rhs(obs_new(:,l), learningOutput{1,1}.syshat_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    
end
%
for l= 1:size(obsfut_new,2)
    dxdatafut_test(:,l)                   = eval_rhs(obsfut_new(:,l), sys_info);
    hatdxdatafut_test(:,l)                   = eval_rhs(obsfut_new(:,l), learningOutput{1,1}.syshat_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    
end
%

fprintf('\n--- RMSE of our algorithm on fitting fphi for Test ICs on training time interval is: %10.4e', norm(hatdxdata_test-dxdata_test)./norm(dxdata_test));
fprintf('\n--- RMSE of our algorithm on fitting fphi for Test ICs  on future time interval is: %10.4e', norm(hatdxdatafut_test-dxdatafut_test)./norm(dxdatafut_test));


fprintf('\n--- Mean trajectory prediciton of training ICs on training time interval is: %10.4e', mean(learningOutput{1,1}.trajErr.sup) );
fprintf('\n--- Mean trajectory prediciton of training ICs on future time interval is: %10.4e', mean(learningOutput{1,1}.trajErr.sup_fut) );
fprintf('\n--- Mean trajectory prediciton of test ICs on training time interval is: %10.4e', mean(learningOutput{1,1}.trajErr_new.sup) );
fprintf('\n--- Mean trajectory prediciton of test ICs on future time interval is: %10.4e', mean(learningOutput{1,1}.trajErr_new.sup_fut) )


%% using Sindy to learn dynamics
%  Matlab SINDy package is available at faculty.washington.edu/sbrunton/sparsedynamics.zip.

% if do comparison
Comparison_with_SINDy= true;

if Comparison_with_SINDy
    
    % prepare for the X and dot X
    
    Sindyfit_tic =tic;
    
    obs_data = learningOutput{1,1}.obs_data; % only for one learning trial
    xdata = obs_data.x;
    dxdata     = xdata(:,2:end,:) - xdata(:,1:end-1,:);
    xdata  = xdata(:,1:end-1,:);
    dt = obs_info.time_vec(2)-obs_info.time_vec(1);
    train_xdata_1 = reshape(xdata,size(xdata,1),[])'; % Data of X, size LM x Nd
    train_dxdata_1 = reshape(dxdata./dt,size(dxdata,1),[])'; % Data of dot X, size LM x Nd
    
    
    %% pool Data  (i.e., build library of nonlinear time series)
    
    polyorder = 2;
    usesine   = 1;
    Theta = poolData(train_xdata_1,size(train_xdata_1,2),polyorder,usesine); % the defaul dictionary is mutivariable polys with sines and cosines
    m = size(Theta,2);% size of dictionary
    
    %% compute Sparse regression: sequential least squares
    % lambda is our sparsification knob. in our example, sparsity is not obvious,
    %  have to set lambda very small, large lambda leads to zero solution
    lambda = 0.00005;
    Xi = sparsifyDynamics(Theta,train_dxdata_1,lambda,size(train_xdata_1,2)); % coefficient matrix, size m x Nd
    fprintf('\n--- The elapse time for Running Sindy is: %10.4e',toc(Sindyfit_tic));
    
    
    
    
    
    
    
    
    %% use sparse regression coefficient as RHS
    
    SindyPred_tic =tic;
    RHS = @(t,x)sparseGalerkin(t,x,Xi,polyorder,usesine);
    
    
    % prepare data for X and dot X
    obs_data = learningOutput{1,1}.obs_data;
    xdata = obs_data.x;
    dxdata     = xdata(:,2:end,:) - xdata(:,1:end-1,:);
    xdata  = xdata(:,1:end-1,:);
    dt = obs_info.time_vec(2)-obs_info.time_vec(1);
    train_xdata = reshape(xdata,size(xdata,1),[]); % size: Nd x LM
    train_dxdata = reshape(dxdata./dt,size(dxdata,1),[]); % size: Nd x LM
    
    
    % Training error for Training ICs
    SINDy_dxdata = train_xdata;
    SINDy_dxdata_fut = obsfut_true;
    for j=1:size(train_xdata,2)
        SINDy_dxdata(:,j)= RHS(0,train_xdata(:,j));
    end
    
    for j=1:size(obsfut_true,2)
        SINDy_dxdata_fut(:,j)= RHS(0,obsfut_true(:,j));
    end
    
    perf_sindy_train = norm(SINDy_dxdata-train_dxdata,2)./norm(train_dxdata);
    perf_sindy_train_fut = norm(SINDy_dxdata_fut-dxdata_fut)./norm(dxdata_fut);
    fprintf('\n--- RMSE error of fitting fphi using Sindy on Training ICs on training time interval is: %10.4e',perf_sindy_train);
    fprintf('\n--- RMSE error of fitting fphi using Sindy on Training ICs on future time interval is: %10.4e',perf_sindy_train_fut);
    
    
    
    
    
    
    tspan = [0,sys_info.T_f];
    options = odeset('RelTol',1e-5,'AbsTol',1e-6);
    
    obs_info_Ltest              = obs_info;
    obs_info_Ltest.L            = obs_info.L_test;
    obs_info_Ltest.time_vec     = linspace(0,obs_info.T_L,obs_info_Ltest.L);
    obs_info_Ltest_fut          = obs_info_Ltest;
    obs_info_Ltest_fut.time_vec = linspace(obs_info.T_L,solver_info.time_span(2),obs_info_Ltest.L);
    
    %% Trajectory prediction for training ICs on both training time interval and future time interval
    ICs = obs_data.ICs;
    for i=1:size(ICs,2)
        sol_SINDy = ode15s(RHS,tspan,ICs(:,i),options);
        xpath_SINDy_train(:,:,i) = deval(sol_SINDy,obs_info_Ltest.time_vec);
        xpath_SINDy_test(:,:,i) = deval (sol_SINDy,obs_info_Ltest_fut.time_vec);
    end
    
    
    traj_Err = learningOutput{1,1}.trajErr;
    observations_true = traj_Err.obs_true.observation; % Nd x L x M
    observationsfuture_true = traj_Err.obs_true.observationfuture;% Nd x L x M
    
    for i = 1:size(observations_true,3)
        sup_err_sindy(i)                = traj_norm(observations_true(:,:,i),     xpath_SINDy_train(:,:,i),    'Time-Maxed', sys_info);
        sup_err_sindy_fut(i)            = traj_norm(observationsfuture_true(:,:,i), xpath_SINDy_test(:,:,i), 'Time-Maxed', sys_info);
    end
    
    
    
    
    %% Trajectory prediction for test ICs on both training time interval and future time interval
    
    traj_Err_new = learningOutput{1,1}.trajErr_new;
    observations_true_new = traj_Err_new.obs_true.observation; % Nd x L x M
    observationsfuture_true_new = traj_Err_new.obs_true.observationfuture;% Nd x L x M
    
    obs_new = reshape(observations_true_new,sys_info.d*sys_info.N,[]); % dN x ML
    obsfut_new =  reshape(observationsfuture_true_new,sys_info.d*sys_info.N,[]); %dN x ML
    
    dxdata_test = obs_new;
    dxdatafut_test = obsfut_new;
    
    for l=1: size(obs_new,2)
        dxdata_test(:,l)                   = eval_rhs(obs_new(:,l), sys_info);                                                    % for future usage when the sys_info (especially type_info) is updated during the time integration
    end
    %
    for l=1: size(obsfut_new,2)
        dxdatafut_test(:,l)                   = eval_rhs(obsfut_new(:,l), sys_info);
    end
    %
    
    SINDy_dxdata_test=obs_new;
    for j=1:size(obs_new,2)
        SINDy_dxdata_test(:,j)= RHS(0,obs_new(:,j));
    end
    
    perf_sindy_test = norm(SINDy_dxdata_test-dxdata_test)/norm(dxdata_test);
    fprintf('\n---  RMSE error of fitting fphi using Sindy on Test ICs on training time interval is: %10.4e',perf_sindy_test);
    
    
    SINDy_dxdatafuture_test =  (obsfut_new);
    for j=1:size(obsfut_new,2)
        SINDy_dxdatafuture_test(:,j)= RHS(0,obsfut_new(:,j));
    end
    perffut_sindy_test = norm (SINDy_dxdatafuture_test-dxdatafut_test)/norm(dxdatafut_test);
    fprintf('\n--- RMSE error of fitting fphi using Sindy on Test ICs on future time interval is: %10.4e',perffut_sindy_test);
    
    
    
    
    
    
    
    % the trajectory prediction error
    
    for i=1:size(observations_true,3)
        sol_SINDy = ode15s(RHS,tspan,observations_true_new(:,1,i),options);
        xpath_SINDy_train_new(:,:,i) = deval(sol_SINDy,obs_info_Ltest.time_vec);
        xpath_SINDy_test_new(:,:,i) = deval (sol_SINDy,obs_info_Ltest_fut.time_vec);
    end
    
    for m = 1:size(observations_true,3)
        sup_err_sindy_new(m)                = traj_norm( observations_true_new(:,:,m),     xpath_SINDy_train_new(:,:,m),    'Time-Maxed', sys_info);
        sup_err_sindy_future_new(m)            = traj_norm(observationsfuture_true_new(:,:,m), xpath_SINDy_test_new(:,:,m), 'Time-Maxed', sys_info);
    end
    
    fprintf('\n------------------- Overall time for computing trajecotry errors: %.2f',toc(SindyPred_tic));
    
    
    fprintf('\n--- SINDy: Mean trajectory prediciton of training ICs on training time interval is: %10.4e', mean(sup_err_sindy) );
    fprintf('\n--- SINDy: Mean trajectory prediciton of training ICs on future time interval is: %10.4e', mean(sup_err_sindy_fut));
    fprintf('\n--- SINDy: Mean trajectory prediciton of test ICs on training time interval is: %10.4e', mean(sup_err_sindy_new));
    fprintf('\n--- SINDy: Mean trajectory prediciton of test ICs on future time interval is: %10.4e', mean(sup_err_sindy_future_new));
    
    % visualize the results for one trajectory prediction
    trajs{1} = [observations_true(:,:,1) observationsfuture_true(:,:,1)];
    trajs{2} = [xpath_SINDy_train(:,:,1) xpath_SINDy_test(:,:,1)];
    trajs{3} = [observations_true_new(:,:,1) observationsfuture_true_new(:,:,1)];
    trajs{4} = [xpath_SINDy_train_new(:,:,1) xpath_SINDy_test_new(:,:,1)];
    time_vec = [obs_info_Ltest.time_vec obs_info_Ltest_fut.time_vec];
    
    switch sys_info.d
        case 1
            visualize_traj_1D(trajs, time_vec, sys_info, obs_info, plot_info);
        case 2
            visualize_traj_2D(trajs, time_vec, sys_info, obs_info, plot_info);
        case 3
            visualize_traj_3D(trajs, time_vec, sys_info, obs_info, plot_info);
        otherwise
    end
    
    
    
    
    %% Train a neural_network to approximate  RHS and use NN to predict the dynamics
    %
    NNfit_tic=tic;
    obs_data = learningOutput{1,1}.obs_data;
    xdata = obs_data.x;
    dxdata     = xdata(:,2:end,:) - xdata(:,1:end-1,:);
    xdata  = xdata(:,1:end-1,:);
    dt = obs_info.time_vec(2)-obs_info.time_vec(1);
    train_xdata = reshape(xdata,size(xdata,1),[]); %Nd x LM
    train_dxdata = reshape(dxdata./dt,size(dxdata,1),[]); % Nd x LM
    
    
    
    
    
    % construct and train neural net
    %net = fitnet(200); % two hidden layer of 25 neurons each
    net = feedforwardnet([25,25,10]);
    net = train(net,train_xdata,train_dxdata);
    
    %% evaluate the performance of fitting fphi on the training data set
    net_dxdata= net(train_xdata);
    net_dxdata_fut = net(obsfut_true);
    perf_train = norm(net_dxdata-train_dxdata)/norm(train_dxdata);
    perf_train_fut = norm(net_dxdata_fut-dxdata_fut)/norm(dxdata_fut);
    fprintf('\n--- The elapse time for fitting neural network is: %10.4e',toc(NNfit_tic));
    fprintf('\n--- RMSE error of fitting fphi using FNN fitting fphi for Training ICs on training time interval is: %10.4e',perf_train);
    fprintf('\n--- RMSE error of fitting fphi using FNN fitting fphi for Training ICs on future time interval is: %10.4e',perf_train_fut);
    
    
    %% use neural network as RHS
    
    NNPred_tic =tic;
    RHS = @(t,x)RHS_NN(net,x);
    tspan = [0,sys_info.T_f];
    options = odeset('RelTol',1e-5,'AbsTol',1e-6);
    
    obs_info_Ltest              = obs_info;
    obs_info_Ltest.L            = obs_info.L_test;
    obs_info_Ltest.time_vec     = linspace(0,obs_info.T_L,obs_info_Ltest.L);
    obs_info_Ltest_fut          = obs_info_Ltest;
    obs_info_Ltest_fut.time_vec = linspace(obs_info.T_L,solver_info.time_span(2),obs_info_Ltest.L);
    
    % test on training data
    ICs = obs_data.ICs;
    for i=1:size(ICs,2)
        sol_NN = ode15s(RHS,tspan,ICs(:,i),options);
        xpath_NN_train(:,:,i) = deval(sol_NN,obs_info_Ltest.time_vec);
        xpath_NN_test(:,:,i) = deval (sol_NN,obs_info_Ltest_fut.time_vec);
    end
    
    
    
    
    
    
    
    
    %% test on initial  conditions from training data
    traj_Err = learningOutput{1,1}.trajErr;
    observations_true = traj_Err.obs_true.observation; % Nd x L x M
    observationsfuture_true = traj_Err.obs_true.observationfuture;% Nd x L x M
    
    for i = 1:size(observations_true,3)
        sup_err(i)                = traj_norm(observations_true(:,:,i),     xpath_NN_train(:,:,i),    'Time-Maxed', sys_info);
        sup_err_fut(i)            = traj_norm(observationsfuture_true(:,:,i), xpath_NN_test(:,:,i), 'Time-Maxed', sys_info);
    end
    
    %%FNN fitting of fphi on training data set
    
    
    %% FNN fitting of fphi on testing data set
    net_dxdata_test= net(obs_new);
    perf_test = norm(net_dxdata_test-dxdata_test)/norm(dxdata_test);
    fprintf('\n--- RMSE error of fitting fphi using FNN fitting fphi for Test ICs on training time interval is: %10.4e',perf_test);
    
    net_dxdatafuture_test =  net(obsfut_new);
    perffut_test = norm(net_dxdatafuture_test-dxdatafut_test)/norm(dxdatafut_test);
    fprintf('\n--- RMSE error of fitting fphi using FNN fitting fphi for Test ICs on future time interval is: %10.4e',perffut_test);
    
    
    
    
    
    
    % the trajectory prediction error
    
    for i=1:size(observations_true,3)
        sol_NN = ode15s(RHS,tspan,observations_true_new(:,1,i),options);
        xpath_NN_train_new(:,:,i) = deval(sol_NN,obs_info_Ltest.time_vec);
        xpath_NN_test_new(:,:,i) = deval (sol_NN,obs_info_Ltest_fut.time_vec);
    end
    
    for m = 1:size(observations_true,3)
        sup_err_new(m)                = traj_norm( observations_true_new(:,:,m),     xpath_NN_train_new(:,:,m),    'Time-Maxed', sys_info);
        sup_err_future_new(m)            = traj_norm(observationsfuture_true_new(:,:,m), xpath_NN_test_new(:,:,m), 'Time-Maxed', sys_info);
    end
    
    fprintf('\n------------------- Overall time for computing trajecotry errors: %.2f',toc(NNPred_tic));
    
    
    
    % visualize the results
    trajs{1} = [observations_true(:,:,1) observationsfuture_true(:,:,1)];
    trajs{2} = [xpath_NN_train(:,:,1) xpath_NN_test(:,:,1)];
    trajs{3} = [observations_true_new(:,:,1) observationsfuture_true_new(:,:,1)];
    trajs{4} = [xpath_NN_train_new(:,:,1) xpath_NN_test_new(:,:,1)];
    time_vec = [obs_info_Ltest.time_vec obs_info_Ltest_fut.time_vec];
    
    switch sys_info.d
        case 1
            visualize_traj_1D(trajs, time_vec, sys_info, obs_info, plot_info);
        case 2
            visualize_traj_2D(trajs, time_vec, sys_info, obs_info, plot_info);
        case 3
            visualize_traj_3D(trajs, time_vec, sys_info, obs_info, plot_info);
        otherwise
    end
    
    
    
    
    fprintf('\n--- FNN: Mean trajectory prediciton of training ICs on training time interval is: %10.4e', mean(sup_err) );
    fprintf('\n--- FNN: Mean trajectory prediciton of training ICs on future time interval is: %10.4e', mean(sup_err_fut));
    fprintf('\n--- FNN: Mean trajectory prediciton of test ICs on training time interval is: %10.4e', mean(sup_err_new));
    fprintf('\n--- FNN: Mean trajectory prediciton of test ICs on training time interval is: %10.4e', mean(sup_err_future_new));
    
    save(strcat(sys_info.name,'_SINDy_NN_err'),'sup_err','sup_err_fut','sup_err_new','sup_err_future_new','perf_train','perf_test', 'perffut_test');
    fprintf('\ndone.\n');
    
    
end










return
