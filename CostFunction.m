%% CostFunction.m 
% J  [OUT] : The objective Vector. J is a matrix with as many rows as
%            trial vectors in X and as many columns as objectives.
% X   [IN] : Decision Variable Vector. X is a matrix with as many rows as
%            trial vector and as many columns as decision variables.
% Dat [IN] : Parameters defined in NNCparam.m
% 
%%
%% Beta version 
% Copyright 2006 - 2012 - CPOH  
% Predictive Control and Heuristic Optimization Research Group
%      http://cpoh.upv.es
% ai2 Institute
%      http://www.ai2.upv.es
% Universitat Politècnica de València - Spain.
%      http://www.upv.es
%%
%% Author
% Gilberto Reynoso Meza
% gilreyme@upv.es
% http://cpoh.upv.es/en/gilberto-reynoso-meza.html
% http://www.mathworks.es/matlabcentral/fileexchange/authors/289050
%%
%% For new releases and bug fixing of this Tool Set please visit:
% http://cpoh.upv.es/en/research/software.html
% Matlab Central File Exchange
%%

%% Main call
function J=CostFunction(X,Dat)

if strcmp(Dat.CostProblem,'DTLZ2')
    J=DTLZ2(X,Dat);
elseif strcmp(Dat.CostProblem,'Myproblem')
    J=Myproblem(X,Dat);
    % Here comes the call for a cost function of your own multi objective
    % problem. 
end
end

%% DTLZ2 Benchmark function. Defined in:
% K. Deb, L. Tiele, M. Laummans, and E. Zitzler. Scalable test problems 
% for evolutionary multi-objective optimization. Institut fur Technische 
% Informatik und Kommunikationsnetze, ETH Zurich, Tech. Rep. TIK-Technical 
% Report No. 112, Feb. 2001.

%{
function J=DTLZ2(X,Dat)

Xpop=size(X,1);
Nvar=Dat.NVAR;
M=Dat.NOBJ;
K=Nvar+1-M;
disp('M');
disp(M);
J=ones(Xpop,M);

for xpop=1:Xpop
    Gxm=(X(xpop,M:Nvar)-0.5*ones(1,K))*(X(xpop,M:Nvar)-0.5*ones(1,K))';
    Cos=cos(X(xpop,1:M-1)*pi/2);

    J(xpop,1)=prod(Cos)*(1+Gxm);
    for nobj=1:M-1
     J(xpop,nobj+1)=(J(xpop,1)/prod(Cos(1,M-nobj:M-1)))...
         *sin(X(xpop,M-nobj)*pi/2);
    end
end
end
%}
%% Write your own cost function here....

function J = Myproblem(X,Dat)
Xpop=size(X,1);
Nvar=Dat.NVAR;
M=Dat.NOBJ;
J=ones(Xpop,M);
    
if sum(X == 1) == 0
  J = 1;
else
  for xpop=1:Xpop
    xtemp=X(xpop,:);    
    J(xpop,1)=sum(xtemp(xtemp==1));
    %disp('J(xpop)');
    if J(xpop,1)==0
        J(xpop,1)=Dat.feat_min;
        J(xpop,2)=Dat.error_min;
    disp(J(xpop,1));
    else 
        J(xpop,2) = jwrapperKNN(Dat.feat(:, xtemp == 1),Dat.label,Dat.Ho);
    end
  end
end
end


function error=jwrapperKNN(sfeat,label,HO)
k=2;

xtrain = sfeat(HO.training == 1,:);
ytrain = label(HO.training == 1); 
xvalid = sfeat(HO.test == 1,:); 
yvalid = label(HO.test == 1); 

Model     = fitcknn(xtrain,ytrain,'NumNeighbors',k); 
pred      = predict(Model,xvalid);
num_valid = length(yvalid); 
correct   = 0;
p=sum(yvalid(yvalid==1));
p1=sum(pred(pred==1));

p=p/num_valid;
p1=p1/num_valid;

error=abs(p-p1);

%print("MAE",MAE)

%MSE=np.square(abs(p-p1))

%print("MSE",MSE)

%{
for i = 1:num_valid
  if isequal(yvalid(i),pred(i))
    correct = correct + 1;
  end
end
Acc   = correct / num_valid; 
error = 1 - Acc;
%}
end

%% Release and bug report:
%
% November 2012: Initial release