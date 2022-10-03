set Prod  ordered;            
set Item  ordered;  
set scenario;        

param T=8;
param ProdCost{Prod,1..T}>=0;

param mean{1..T}>0;
param sigma{1..T}>=0;
param SetupCost{Prod};
param BigM=1000;
param demand{j in Item,t in 1..T,m in scenario}=max(0,Normal(mean[t],sigma[t]));

param OverageCost {Prod,1..T} ;        # overage for items
param ShortageCost {Item,1..T} >= 0;      # shortage cost of demand for products
param SubstitutionCost {Prod,Item,1..T} >= 0;   

var Z{Prod,1..T} integer;
var ExcessInv {Prod,1..T,scenario} >= 0;            # excess inventory for items
var Shortage {Item,1..T,scenario} >= 0;            # shortage of demand 
var Substitutions {Prod,Item,1..T,scenario} >= 0;  
var ProQuantity{Prod,1..T}>=0;
#sum{i in Prod,j in Item, m in scenario}(Substitutions [i,j,m]* SubstitutionCost[i,j]) 

minimize total_cost: 
sum{i in Prod,t in 1..T}(ProdCost[i,t]*ProQuantity[i,t])

+1/400*(sum{i in Prod, t in 1..T}(SetupCost[i]*Z[i,t])+sum{i in Prod,j in Item, m in scenario,t in 1..T}(Substitutions [i,j,t,m]* SubstitutionCost[i,j,t])
+sum{i in Prod, m in scenario,t in 1..T }(ExcessInv[i,t,m]*OverageCost[i,t])
+sum{j in Item, m in scenario,t in 1..T}(Shortage[j,t,m]*ShortageCost[j,t]))
;
subject to SetUp{i in Prod, t in 1..T}: BigM*Z[i,t]>=ProQuantity[i,t];
subject to excess1 {i in Prod,m in scenario,t in 1..1}:  
   sum {j in Item: ord(j)>=ord(i)} (Substitutions [i,j,t,m]) 
    +ExcessInv[i,t,m]=ProQuantity[i,t];

subject to shortage1 {j in Item,m in scenario,t in 1..1}:
   sum {i in Prod: ord(i)<=ord(j)} (Substitutions [i,j,t,m]) 
   +Shortage[j,t,m]=demand[j,t,m];
   
subject to excess {i in Prod,m in scenario,t in 2..T}:  
   sum {j in Item: ord(j)>=ord(i)} (Substitutions [i,j,t,m]) 
    +ExcessInv[i,t,m]=ProQuantity[i,t]+ExcessInv[i,(t-1),m];

subject to shortage {j in Item,m in scenario,t in 2..T}:
   sum {i in Prod: ord(i)<=ord(j)} (Substitutions [i,j,t,m]) 
   +Shortage[j,t,m]=demand[j,t,m]+Shortage[j,(t-1),m];
   