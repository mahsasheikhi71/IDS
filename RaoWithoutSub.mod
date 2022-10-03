set Prod  ordered;            
set Item  ordered;  
set scenario; 


param T;       
param ProdCost{Prod,1..T}>=0;

param mean{1..T};
param sigma{1..T};

param demand{i in Prod,t in 1..T,m in scenario}=Normal(mean[t],sigma[t]);

param OverageCost {Prod,1..T} ;        # overage for items
param ShortageCost {Prod,1..T} >= 0;      # shortage cost of demand for products

var ExcessInv {Prod,1..T,scenario} >= 0;            # excess inventory for items
var Shortage {Prod,1..T,scenario} >= 0;            # shortage of demand  
var ProQuantity{Prod,1..T}>=0;

minimize total_cost: 
sum{i in Prod, t in 1..T}(ProdCost[i,t]*ProQuantity[i,t])

+0.2*((sum{i in Prod, m in scenario,t in 2..T  }(ExcessInv[i,t,m]*OverageCost[i,t])
+sum{i in Prod, m in scenario,t in 1..T}(Shortage[i,t,m]*ShortageCost[i,t])));
 
         
subject to excess1 {i in Prod,m in scenario,t in 1..1}:  
    ExcessInv[i,t,m]-Shortage[i,t,m]=ProQuantity[i,t]-demand[i,t,m];

subject to excess {i in Prod,m in scenario,t in 2..T}:  
    ExcessInv[i,t,m]-Shortage[i,t,m]=ProQuantity[i,t]-demand[i,t,m]+ExcessInv[i,t-1,m]-Shortage[i,t-1,m];