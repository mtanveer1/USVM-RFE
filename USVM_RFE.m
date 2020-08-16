clc;
clear all;
close all;
file1 = fopen('result_newton.txt','a+');
fprintf(file1,'%s\n',date);
max_trial =10;
global p1 p2;
% ep = 0.9;
            
for load_file = 1:1
    %% to load file
    switch load_file

       case 1
            file = 'wpbc';
            test_start =131;
  
        otherwise
            continue;
    end
%parameters 
%          cvs1=[10^-5,10^-4,10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3,10^4,10^5];

%         mus = [2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4,2^5];
                 
%Data file call from folder   
filename = strcat(file,'.txt');
    A = load(filename);
    [m,n] = size(A);
     label=A(:,n);
%define the class level +1 or -1    
    for i=1:m
        if A(i,n)==0
            A(i,n)=-1;
        end
    end
% Dividing the data in training and testing    
  [no_input,no_col] = size(A);
    test = A(test_start:m,:);
    train = A(1:test_start-1,:);
    x1 = train(:,1:no_col-1);
    y1 = train(:,no_col);
	    
    [no_test,no_col] = size(test);
    xtest0 = test(:,1:no_col-1);
    ytest0 = test(:,no_col);
% Normalize the data training and testing     
	me=repmat(mean(x1),size(x1,1),1);
	st=repmat(std(x1),size(x1,1),1);
	tme=repmat(mean(x1),size(xtest0,1),1);
	tst=repmat(std(x1),size(xtest0,1),1);

    x1 = (x1-me)./st;
    xtest0=(xtest0-tme)./tst;
 %
    %% Universum
    A=[x1 y1;xtest0 ytest0];
    [no_input,no_col] = size(A);
	obs = A(:,no_col);   
    C=A;
    C1= A(1:test_start-1,:);
    A = [];
	B = [];

for i = 1:test_start-1
    if(obs(i) == 1)
        A = [A;C1(i,1:no_col-1)];
    else
        B = [B;C1(i,1:no_col-1)];
    end;
end;
 u=ceil(0.3*(test_start-1));
sb1=size(A,1);
sb=size(B,1);
ptb1=sb1/u;
ptb=sb/u;
Au=A(1:ptb1:sb1,:);
Bu=B(1:ptb:sb,:);
di=size(Au,1)-size(Bu,1);
if(di>0)
Bu=[Bu ;Bu(1:abs(di),:)];
elseif(di<0)
Au=[Au ;Au(1:abs(di),:)];
end   
 U=(Au+Bu)/2;   

    
    %Combining all the column in one variable
    A=[x1];    %training data
    A_test=[xtest0];    %testing data
 %% initializing crossvalidation variables

    [lengthA,n] = size(A);
    t_feat=n;
    min_err = -10^-10.;

coord=[1:n];

c1=	10;												
c2=1;
e=0.5;

		count_3=0;count_5=0;count_8=0;count_10=0;count_13=0;count_15=0;count_20=0;count_25=0;count_30=0;count_35=0;count_40=0;count_45=0;count_50=0;count_70=0;
  for i = 1:1000
                                [accuracy,w,time] = gunnsvc(A,label(1:test_start-1),A_test,label(test_start:m),U,c1,c2,e); 
                                i
                                w_square=w.^2;
                                [val ind]=sort(w_square,'descend');
                                new=size(ind,2)-1;
                                new_ind=ind(1:new);
                                
                                new_ord_ind=sort(new_ind);
                                A=A(:,new_ord_ind);
                             
                                coord1=coord(new_ind);
                                weight_s=val(1:new);
                                coord=coord(new_ord_ind);
                                U=U(:,new_ord_ind);
                                A_test=A_test(:,new_ord_ind);
                                [no_input,no_col] = size(A);
                              
                                   DD=[[A;A_test] label]; 
                                   
                                 if(no_col<2)
                                    break;
                                 end 
                                 
                                       if(count_3==0&&no_col<ceil(0.03*t_feat))
                                        dlmwrite('best_feat_wpbc_3.txt',DD,'-append','delimiter','\t'); %Features%
                                        dlmwrite('best_feat_wpbc_rank_3.txt',coord1,'-append','delimiter','\t'); %Feature rank%
                                        dlmwrite('best_feat_wpbc_weight_3.txt',weight_s,'-append','delimiter','\t'); %Feature weights%
                                        count_3=1;
                                       elseif(count_5==0&&no_col<ceil(0.05*t_feat))
                                        dlmwrite('best_feat_wpbc_5.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_5.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_5.txt',weight_s,'-append','delimiter','\t');
                                        count_5=1;
                                       elseif(count_8==0&&no_col<ceil(0.08*t_feat))
                                        dlmwrite('best_feat_wpbc_8.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_8.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_8.txt',weight_s,'-append','delimiter','\t');
                                        count_8=1;
                                        elseif(count_10==0&&no_col<ceil(0.10*t_feat))
                                        dlmwrite('best_feat_wpbc_10.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_10.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_10.txt',weight_s,'-append','delimiter','\t');
                                        count_10=1;
                                         elseif(count_13==0&&no_col<ceil(0.13*t_feat))
                                        dlmwrite('best_feat_wpbc_13.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_13.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_13.txt',weight_s,'-append','delimiter','\t');
                                        count_13=1;
                                        elseif(count_15==0&&no_col<ceil(0.15*t_feat))
                                        dlmwrite('best_feat_wpbc_15.txt',DD,'-append','delimiter','\t');
                                         dlmwrite('best_feat_wpbc_rank_15.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_15.txt',weight_s,'-append','delimiter','\t');
                                        count_15=1;                                         
                                        elseif(count_20==0&&no_col<ceil(0.20*t_feat))
                                        dlmwrite('best_feat_wpbc_20.txt',DD,'-append','delimiter','\t');
                                         dlmwrite('best_feat_wpbc_rank_20.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_20.txt',weight_s,'-append','delimiter','\t');
                                        count_20=1;
                                         elseif(count_25==0&&no_col<ceil(0.25*t_feat))
                                        dlmwrite('best_feat_wpbc_25.txt',DD,'-append','delimiter','\t');
                                         dlmwrite('best_feat_wpbc_rank_25.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_25.txt',weight_s,'-append','delimiter','\t');
                                        count_25=1;
                                        elseif(count_30==0&&no_col<ceil(0.30*t_feat))
                                        dlmwrite('best_feat_wpbc_30.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_30.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_30.txt',weight_s,'-append','delimiter','\t');
                                        count_30=1;
                                        elseif(count_35==0&&no_col<ceil(0.35*t_feat))
                                        dlmwrite('best_feat_wpbc_35.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_35.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_35.txt',weight_s,'-append','delimiter','\t');
                                        count_35=1;
                                        elseif(count_40==0&&no_col<ceil(0.40*t_feat))
                                        dlmwrite('best_feat_wpbc_40.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_40.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_40.txt',weight_s,'-append','delimiter','\t');
                                        count_40=1;
                                        elseif(count_45==0&&no_col<ceil(0.45*t_feat))
                                        dlmwrite('best_feat_wpbc_45.txt',DD,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_rank_45.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_45.txt',weight_s,'-append','delimiter','\t');
                                        count_45=1;
                                        elseif(count_50==0&&no_col<ceil(0.50*t_feat))
                                        dlmwrite('best_feat_wpbc_50.txt',DD,'-append','delimiter','\t');
                                         dlmwrite('best_feat_wpbc_rank_50.txt',coord1,'-append','delimiter','\t');
                                        dlmwrite('best_feat_wpbc_weight_50.txt',weight_s,'-append','delimiter','\t');
                                        count_50=1;                                       
                                        end
                                        
                               
  end

  dlmwrite('best_feat_wpbc_1.txt',DD,'-append','delimiter','\t');
  dlmwrite('best_feat_wpbc_rank_1.txt',coord1,'-append','delimiter','\t');
  dlmwrite('best_feat_wpbc_weight_1.txt',weight_s,'-append','delimiter','\t');

end
 