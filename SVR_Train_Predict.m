% addpath('/Users/yathee-itphd/Documents/Doc for Prof/SVM');
addpath('D:\work\libs\libsvm-3.22\matlab');

%Read the data %
train_input_file = 'data/input/SVM_train_test_max_wrk3.scale';
predict_input_file = 'data/input/SVM_predict_max_wrk3.scale';
predict_output_file = 'data/output/predict_output_svr_max_wrk3.csv';
test_output_file = 'data/output/test_output_svr_max_wrk3.csv';



%% Data set
N = 3531;    % N training instances
nv = 6;     % nv features

total_size = 3531
train_size = 3500 

% 
[y,x ] = libsvmread (train_input_file);


%% Training and testing model
% Training with train_size of data
tic;

model = svmtrain(y(1:train_size),x(1:train_size,:),['-s 3 -t 2 -g ' num2str(0.03125) ' -c ' num2str(8)]);

toc
% Testing with the rest data (total_size - train_size)
tic;
zz=svmpredict(y((train_size+1):end),x((train_size+1):end,:),model);
toc
tmp = corrcoef(zz, y((train_size+1):end));
err_test = y((train_size+1):end) - zz ;

% Get the w and b of model
w = model.SVs' * model.sv_coef;
b = -model.rho;
% 


%% Predict a new set of data

[y_pred, x_pred] = libsvmread (predict_input_file);
tic;
zz_pred = svmpredict ( y_pred, x_pred, model );
toc
tmp2 = corrcoef(zz_pred, y_pred);
err_pred = y_pred - zz_pred ;

% export output 

Otest = horzcat (zz,err_test,abs(err_test));
csvwrite(test_output_file,Otest);


Opred = horzcat (zz_pred,err_pred,abs(err_pred));
csvwrite(predict_output_file,Opred);


