function [success_rate, tLL, gestureRecThreshold, found] = runHmm(testing, training, test_gesture)
% Modified version of test.m presented by Jonathan C. Hall

D = 3; % the number of dimensions to use: X, Y, Z
M = 12; % output symbols
N = 8; % states
LR = 2; % degree of play in the left-to-right HMM transition matrix 

%************************************************************
%
%  Initialize
%
%************************************************************

gestureRecThreshold = 0; % set below

[centroids N] = get_point_centroids(training,N,D);
ATrainBinned = get_point_clusters(training,centroids,D);
ATestBinned = get_point_clusters(testing,centroids,D);

%************************************************************
%
%  Training
%
%************************************************************

% Set priors:
pP = prior_transition_matrix(M,LR);

% Train the model:
cyc = 50;
[E,P,Pi,LL] = dhmm_numeric(ATrainBinned,pP,[1:N]',M,cyc,.00001);

%************************************************************
%
%  Testing
%
%************************************************************

sumLik = 0;
minLik = Inf;
for j=1:length(ATrainBinned)
	lik = pr_hmm(ATrainBinned{j},P,E',Pi);
	if (lik < minLik)
		minLik = lik;
	end
	sumLik = sumLik + lik;
end
gestureRecThreshold = 2.0*sumLik/length(ATrainBinned);
    
fprintf('\n\n********************************************************************\n');
fprintf('Testing %i sequences for a log likelihood greater than %f\n',length(ATestBinned),gestureRecThreshold);
fprintf('********************************************************************\n\n');

recs = 0;
tLL = zeros(length(ATestBinned),1);
for j=1:length(ATestBinned)
	tLL(j,1) = pr_hmm(ATestBinned{j},P,E',Pi);
	if (tLL(j,1) > gestureRecThreshold)
		recs = recs + 1;
		fprintf('Log likelihood: %f > %f (threshold) -- FOUND %s GESTURE!\n',tLL(j,1),gestureRecThreshold,test_gesture);
        found(j,1) = 1;
	else
		fprintf('Log likelihood: %f < %f (threshold) -- NO %s GESTURE.\n',tLL(j,1),gestureRecThreshold,test_gesture);
        found(j,1) = 0;
    end
end
success_rate = recs/length(ATestBinned);
fprintf('Recognition success rate: %f percent\n',100*success_rate);
