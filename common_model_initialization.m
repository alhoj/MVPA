model.layersizes=[layers];
model.layersizesinitial=model.layersizes;

model.N=size(x,1);
%model.batchsize=200;
model.batchsize=20;
%model.batchsize=100;

model.target=y;

if intra
    model.epochs=1000; % for intrasubject
    model.update=100; % for intrasubject
    model.l1=1; % for intrasubject
else
    model.epochs=5000;
    model.update=500;
    model.l1=0;
end

model.fe_update=100000;
model.fe_thres=0.1/model.layersizes(1);

model.l2=0;
noins=size(x,2);
noouts=size(y,2);
lr=0.001; activation='relu';
%lr=0.01; activation='tanhact';

model.errofun='cross_entropy_cost';
%model.errofun='quadratic_cost';

for layeri=1:(length(layers)-1)
    
    model.layers(layeri).activation=activation;
    model.layers(layeri).lr=lr;
    model.layers(layeri).blr=lr;
    model.layers(layeri).Ws=[layers(layeri) layers(layeri+1)];
    model.layers(layeri).W=(randn(layers(layeri),layers(layeri+1)))*sqrt(1/model.layersizes(layeri));
    
    
    %model.layers(layeri).W=(randn(layers(layeri),layers(layeri+1)))/100;
    %model.layers(layeri).lr=ones(size(model.layers(layeri).W)).*lr;
    %model.layers(layeri).B=(randn(layers(layeri+1),1)-0.5)/10;
    model.layers(layeri).B=zeros(layers(layeri+1),1);
    
    
    model.layers(layeri).inds=1:model.layersizes(layeri); % To keep track of which nodes are removed etc
    
end


model.layers(layeri).lr=lr/1; model.layers(layeri).activation='softmaxact';



model.x_test=x_test;
model.y_test=y_test;
model.x=x;
model.y=y;