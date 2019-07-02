%Read the data %
train_input_file = 'data/input/test_train_wrk3.csv';
predict_input_file = 'data/input/predict_wrk3.csv';
predict_output_file = 'data/output/predict_output_ann_MAX_wrk3.csv';
test_output_file = 'data/output/test_output_ann_MAX_wrk3.csv';
total_size = 3531
train_size = 3031 

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
Ytrain = maximum(1:train_size);

Xtrain = transpose(Xtrain);
Ytrain = transpose(Ytrain);

tic;
% Create feedforward network with hidden layer 

net = feedforwardnet([5]);
net.layers{1}.transferFcn = 'purelin';

% set early stopping parameters
net.divideParam.trainRatio = 1.0; % training set [%]
net.divideParam.valRatio = 10.0; % validation set [%]
net.divideParam.testRatio = 20.0; % test set [%]
% train a neural network
net.trainParam.epochs = 100;
[net,tr] = train(net,Xtrain,Ytrain);

toc

% Test the net
Xtest = horzcat( imagesize((train_size+1):end),vmType((train_size+1):end),noVMreq((train_size+1):end),CPUUtilization((train_size+1):end),MemoryUtilization((train_size+1):end),NetworkUtil((train_size+1):end));
Xtest = transpose(Xtest);
Ytest = maximum((train_size+1):end);
Ytest = transpose(Ytest);
tic;
Ytestpred = net(Xtest);
toc
err_test = Ytest - Ytestpred;

coeffTest = corrcoef(Ytest,Ytestpred)
mse_test = mse(err_test)
mae_test = mae(err_test)
rmse_test = sqrt(mean((err_test).^2))


Ytpred = transpose(Ytestpred);
YTtest = transpose(Ytest);
XTtest = transpose(Xtest);


% Load the dataset for prediction 

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

%Prep data for Prediction 
Xpred = horzcat( imagesize_t,vmType_t,noVMreq_t,CPUUtilization_t,MemoryUtilization_t,NetworkUtil_t);
Xpred = transpose(Xpred);

Yactual = maximum_t;

tic;
Ypred = net(Xpred);
toc
err_pred = Yactual - (transpose(Ypred));

YTpred = transpose(Ypred);
YTactual = transpose(Yactual);
XTpred = transpose(Xpred);

tmp = corrcoef ( YTactual,YTpred)
mse_pred = mse(err_pred)
mae_pred = mae(err_pred)
rmse_test = sqrt(mean((err_pred).^2))

% export output 

Otest = horzcat (YTtest,Ytpred,XTtest,transpose(err_test),transpose(abs(err_test)));
csvwrite(test_output_file,Otest);

Xpred = transpose(Xpred);
Opred = horzcat (transpose(YTactual),YTpred,XTpred,err_pred,abs(err_pred));
csvwrite(predict_output_file,Opred);






