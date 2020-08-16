function [accuracy,w,time,sen,spe,pre] = gunnsvc(trnX, trnY, tstX, tstY,U,c,c1,e)
ker = 'linear';
[nsv, beta, bias,time] = svc(trnX,trnY,ker,U,c,c1,e);
[accuracy,preY,w,sen,spe,pre]= svcerror(trnX,trnY,tstX,tstY,ker,beta,bias,U);
