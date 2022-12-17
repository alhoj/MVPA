function h1=violin_funct(str,gap,smoothfactor,varargin)

if nargin>3
    
    colorr=varargin{1};
    display(num2str(colorr))
else
    colorr=[0 0 1]
    
end
width=0.3
for stri =1:length(str)
    [str(stri).yy,str(stri).xx]=hist(str(stri).data,floor(min(str(stri).data)):gap:ceil(max(str(stri).data)));
    str(stri).xx=[str(stri).xx(1) str(stri).xx str(stri).xx(end)]; 
    str(stri).yy=[0 str(stri).yy 0]/sum(str(stri).yy);
    
    if smoothfactor>0
        str(stri).yy=smooth(str(stri).yy,smoothfactor);
    end
    
    str(stri).yy=(str(stri).yy/max(str(stri).yy))*width;
    if isfield(str(stri),'data2')
        [str(stri).yy2,str(stri).xx2]=hist(str(stri).data2,floor(min(str(stri).data2)):gap:ceil(max(str(stri).data2))); str(stri).xx2=[str(stri).xx2(1) str(stri).xx2 str(stri).xx2(end)]; str(stri).yy2=[0 str(stri).yy2 0]/sum(str(stri).yy2);
        
        if  smoothfactor>0
            str(stri).yy2=smooth(str(stri).yy2,smoothfactor);
        end
        
        str(stri).yy2=(str(stri).yy2/max(str(stri).yy2))*width;
    end
end

h1=fill(str(stri).location-str(stri).yy,str(stri).xx,colorr,'EdgeColor','none')

if isfield(str(stri),'data2')
    
    fill(str(stri).location+str(stri).yy2,str(stri).xx2,[1 0 0],'EdgeColor','none')
else
    
    fill(str(stri).location+str(stri).yy,str(stri).xx,colorr,'EdgeColor','none')
end