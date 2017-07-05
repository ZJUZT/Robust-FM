% load data
training.train_X = train_X;
training.train_Y = train_Y;

validation.test_X = test_X;
validation.test_Y = test_Y;

% pack paras
pars.task = 'regression';
pars.iter_num = 1;
pars.epoch = 20;

pars.epsilon1 = 2;
pars.epsilon2 = 20;

% initial model
[~, p] = size(train_X);

%% fm
pars.reg = 1e-3;
pars.factors_num = 10;
pars.w0 = 0;
pars.W = zeros(1,p);
pars.V = 0.1*randn(p,pars.factors_num);

pars.learning_rate = 1e3;
pars.t0 = 1e5;

disp('Training FM...')
[model_mf, metric_fm] = fm(training, validation, pars);

%% no capped norm
rng('default');
disp('Training without capped norm...')
pars.beta = 0;
pars.alpha = 1e-3;

pars.learning_rate = 1e3;
pars.t0 = 1e5;
[model_no_capped, metric_no_capped] = capped_fm(training, validation, pars);

%% capped norm
rng('default');
disp('Training with capped norm...')
pars.beta = 1e-3;
pars.epsilon1 = 5;
pars.epsilon2 = 1;

pars.learning_rate = 1e2;
pars.t0 = 1e5;

pars.w0 = model_no_capped.w0;
pars.W = model_no_capped.W;
pars.Z = model_no_capped.Z;
[model_capped, metric_capped] = capped_fm(training, validation, pars);
