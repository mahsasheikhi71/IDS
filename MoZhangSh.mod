set n  ordered;   
set nn  ordered;            
set scenario;        

param P{n}>=0;
param C{n}>=0;
param S{n}>=0;
param Sh{n}>=0;
param e{n,n}>=0;
param mean{n}>=0;
param sigma{n}>=0;


param D{i in n ,k in scenario}=Uniform (mean[i],sigma[i]);

var alf{n,n} >=0;
var ds {n,scenario} >= 0;           
var up {n,scenario} >= 0;  
var un {n,scenario} >= 0;             
var Q{n}>=0;


maximize total_cost: 
sum{i in n}((P[i]-C[i])*Q[i])-1/150*(sum{i in n, k in scenario}((P[i]-S[i])*up[i,k])+
            sum{i in n, k in scenario}((Sh[i])*un[i,k])+
            sum{i in n, k in scenario, j in n: i!=j}(alf[i,j]*D[j,k]*e[i,j]));
            
subject to Cons1{i in n, k in scenario}: ds[i,k]= sum{j in n: i !=j}(alf[i,j]*D[j,k])-sum{j in n: i !=j}(alf[j,i]*D[i,k]);
subject to Cons2{j in n}: sum{i in n}(alf[i,j])<=1; 
subject to Cons3{i in n, k in scenario}: up[i,k]>= Q[i]-ds[i,k]; 
subject to Cons4{i in n, k in scenario}: un[i,k]>= ds[i,k]-Q[i]; 

