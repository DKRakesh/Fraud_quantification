%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML122
% Project Title: Multi-Objective Feature selection using NSGA-II
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function data=LoadData()

    T=readtable('japanese.csv');
     %       ^^^^^^^^^------ your csv filename
    disp(size(T));
    %Input1=T{(10000:50000),(1:56)};
    Input1=T{:,(1:15)};
    Inputs=Input1';
    
        
    Targets=T{:,end}';
    save('mymat.mat','Inputs','Targets')

    %dataset=load('bodyfat_data');
    dataset=load('mymat');
    
    
    
    data.x=dataset.Inputs;
    data.t=dataset.Targets;
    
    data.nx=size(data.x,1);
    data.nt=size(data.t,1);
    data.nSample=size(data.x,2);

end