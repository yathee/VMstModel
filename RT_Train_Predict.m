%Read the data %
train_input_file = 'data/input/test_train_wrk3.csv';
predict_input_file = 'data/input/predict_wrk3.csv';
predict_output_file = 'data/output/predict_output_wrk3_avg.csv';
test_output_file = 'data/output/test_output_wrk3_avg.csv';

total_size = 3531   
train_size = 2900 
prune_level = 360
%setFold = 8
%%% WRK4 WRK4 WRK4 
%%% total_size = 2635   
%%% train_size = 2035 
%%% prune_level = 280 for Avg WRK4, total 300 
%%% prune_level = 289 for min WRK4, total 296
%%% prune_level = 277 for max wrk4, total 288

%%% WRK5 WRK5 WRK5 
%%% total_size = 3334   
%%% train_size = 2734 
%%% prune_level = 340 for Avg WRK5, total 358 
%%% prune_level = 339 for min WRK5, total 359
%%% prune_level = 385 for max wrk5, total 393

%%% WRK6 WRK6 WRK6 
%%% total_size = 3038   
%%% train_size = 2438 
%%% prune_level = 328 for Avg WRK6, total 336 
%%% prune_level = 310 for min WRK6, total 316
%%% prune_level = 318 for max wrk6, total 327
 
%%% 
delimiterIn = ',';
headerlinesIn = 1;
InA = importdata(train_input_file ,delimiterIn,headerlinesIn);
AverageTime = InA.data(:,1);
minimum = InA.data(:,2);
maximum = InA.data(:,3);
imagesize = InA.data(:,4);
vmType = InA.data(:,5);
noVMreq = InA.data(:,6);
CPUUtilization = InA.data(:,7);
MemoryUtilization = InA.data(:,8);
NetworkUtil = InA.data(:,9);

%Prep data for training 

Xtrain = horzcat( imagesize(1:train_size),vmType(1:train_size),noVMreq(1:train_size),CPUUtilization(1:train_size),MemoryUtilization(1:train_size),NetworkUtil(1:train_size));

Ytrain = AverageTime(1:train_size);

% Test data

Xtest = horzcat( imagesize((train_size+1):end),CPUUtilization((train_size+1):end),MemoryUtilization((train_size+1):end),NetworkUtil((train_size+1):end),noVMreq((train_size+1):end),vmType((train_size+1):end));
Yact = AverageTime((train_size+1):end);



% Training 
tic;
tr = fitrtree(Xtrain,Ytrain);
toc

%cross validation 
% 
% crsValMdl = crossval(tr,'KFold',10)
% 
% L = kfoldLoss(crsValMdl)

% View the model 
view (tr,'Mode', 'graph');
tr1 = prune(tr,'Level',prune_level);

% Testing 
% 
tic;
Ytest = predict(tr1 ,Xtest);
%Ytest = predict(crsValMdl.Trained{setFold} ,Xtest);
toc
err_test = Yact - Ytest;

coeffTest = corrcoef(Yact,Ytest)
mse_test = mse(err_test)
mae_test = mae(err_test)
rmse_test = sqrt(mean((err_test).^2))

% Data preparations for the Prediction 

InAP = importdata(predict_input_file,delimiterIn,headerlinesIn);
AverageTime_t = InAP.data(:,1);
minimum_t = InAP.data(:,2);
maximum_t = InAP.data(:,3);
imagesize_t = InAP.data(:,4);
vmType_t = InAP.data(:,5);
noVMreq_t = InAP.data(:,6);
CPUUtilization_t = InAP.data(:,7);
MemoryUtilization_t = InAP.data(:,8);
NetworkUtil_t = InAP.data(:,9);


Xpred = horzcat( imagesize_t,vmType_t,noVMreq_t,CPUUtilization_t,MemoryUtilization_t,NetworkUtil_t);
Yactual = AverageTime_t;

% Prediction 
tic;
Ypred = predict(tr1 ,Xpred);
toc
err_pred = Yactual - Ypred;
abs_err_pred = abs(err_pred);
std_abs_err = std(abs_err_pred)
mean_abs_err = mean(abs_err_pred)
rel_std_abs_err = std_abs_err / mean_abs_err
coeffPred = corrcoef(Yactual,Ypred)

mse_pred = mse(err_pred)
mae_pred = mae(err_pred)
rmse_pred = sqrt(mean((err_pred).^2))

% export output 

Otest = horzcat (Yact,Ytest,Xtest,err_test,abs(err_test));
csvwrite(test_output_file,Otest);

Opred = horzcat (Yactual,Ypred,Xpred,err_pred,abs(err_pred));
csvwrite(predict_output_file,Opred);
