data = xlsread('test_data.xlsx');
data = data(:,3:end);
data = mean(data);
data = reshape(data,12,8)';

%Significant catalysis considered least 10% product conversion and
%t
negativeThresh = 10;
listSigCatalysis = [];

hsolvents = figure('units','normalized','outerposition',[0 0 1 1]);
listSigCatalysis = [];
for i=1:2:7,

    withcatalyst = data(:,i);
    withoutcatalyst = data(:,i+1);
    if i==1 || i==5,
        positiveControl = data(i:i+3,11);
    else
        positiveControl = data(i-2:i+1,12); %i will be 3 and 7 for Solvent 2 and 4
    end

    cutoff = positiveControl(2,1); %10 percent catalysis
    sigCatalysis = withcatalyst > withoutcatalyst * (1+negativeThresh/100) & withcatalyst > cutoff;

    tograph(1:8,1) = withoutcatalyst';
    tograph(1:8,2) = withcatalyst';
%         tograph(17:20) = positiveControl;

    subplot(2,2,(i+1)/2)
    x = 1:8;
    h1 = bar(x,tograph);
    l = {'.1 imid','.5 imid','1.0 imid','N/A','.1 Et3N','.1 H+sp.','.1 CSA','.1 AcOH'};
    set(gca,'xticklabel',l);
  
    hold on;
%     hAxes = gca;
%     hAxes_pos = get(hAxes,'Position');
%     
%     hAxes2 = axes('Position',hAxes_pos);
    h2 = plot(x,ones(1,8)*positiveControl(1),'--',x,ones(1,8)*positiveControl(2),'--',x,ones(1,8)*positiveControl(3),'--',x,ones(1,8)*positiveControl(4),'--');
%     set(hAxes2,'YAxisLocation','right','Color','none','XTickLabel',[])
    hold off;
    
%     subplot(2,2,(i+1)/2)
%     width1 = 0.5;
%     hBars = bar(withoutcatalyst,width1,'b');
%     set(hBars(1),'BaseValue',cutoff);
%     hBaseline = get(hBars(1),'BaseLine');
%     set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%     hold on;
%     hBars = bar(withcatalyst,width1/2,'r');
%     set(hBars(1),'BaseValue',cutoff);
%     hBaseline = get(hBars(1),'BaseLine');
%     set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%     l = {'.1 imid','.5 imid','1.0 imid','N/A','.1 Et3N','.1 H+sp.','.1 CSA','.1 AcOH'};
%     set(gca,'xticklabel',l);
%     hold off;


%         hBars = bar(tograph);
%         set(hBars(1),'BaseValue',cutoff);
%         hBaseline = get(hBars(1),'BaseLine');
%         set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);

    listSigCatalysis = [ listSigCatalysis , sigCatalysis ];

end
leg = legend([h1';h2],'W/o catalyst','With catalyst', '5','10','25','50','Location','NorthEastOutside');
set(leg, 'FontSize',7);
set(leg,'units','pixels');
set(leg,'position',[730 363 150 98])


%% 

%process buffers
bufferListSigCatalysis = [];
figure;
wC = [];
woC = [];
for i=1:2:7, 
    withcatalyst = data(i,9);
    withoutcatalyst = data(i+1,9);
    positiveControl = data(i:i+1,10);
    cutoff = positiveControl(1);
    sigCatalysis = withcatalyst > withoutcatalyst*(1+negativeThresh/100) & withcatalyst > cutoff;
    bufferListSigCatalysis = [bufferListSigCatalysis, sigCatalysis];
    
    
    woC = [woC, withoutcatalyst ];
    wC = [wC, withcatalyst ];
    subplot(2,2,(i+1)/2)
    bar((1:2),[withoutcatalyst,withcatalyst]);
   
    l = {'.1 imid','.5 imid','1.0 imid','N/A','.1 Et3N','.1 H+sp.','.1 CSA','.1 AcOH'};
    set(gca,'xticklabel',l);
    hold on;
    plot(x,ones(1,2)*cutoff);
    hold off;
    
%     width1 = 0.5;
%     hBars = bar(1,withoutcatalyst,width1,'b');
%     set(hBars(1),'BaseValue',cutoff);
%     hBaseline = get(hBars(1),'BaseLine');
%     set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%     hold on
%     hBars = bar(1,withcatalyst,width1/2,'r');
%     set(hBars(1),'BaseValue',cutoff);
%     hBaseline = get(hBars(1),'BaseLine');
%     set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%     hold off
    
end
% 
%     width1 = 0.5;
%     hBars = bar(woC,width1,'b');
%     set(hBars(1),'BaseValue',cutoff);
%     hBaseline = get(hBars(1),'BaseLine');
%     set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%     hold on
%     hBars = bar(wC,width1/2,'r');
%% 

%%Process methanol
rv = [1:4,7:8];
withcatalyst = data(rv,9);
withoutcatalyst = data(rv,10);
positiveControl = [data(5,9:10),data(6,9:10)];
cutoff = positiveControl(2);
sigCatalysis = withcatalyst > withoutcatalyst*(1+negativeThresh/100) & withcatalyst > cutoff;
figure;
width1 = 0.5;
hBars = bar(withoutcatalyst,width1,'b');
set(hBars(1),'BaseValue',cutoff);
hBaseline = get(hBars(1),'BaseLine');
set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
hold on
hBars = bar(withcatalyst,width1/2,'r');
set(hBars(1),'BaseValue',cutoff);
hBaseline = get(hBars(1),'BaseLine');
set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
hold off










    
    
    
   

