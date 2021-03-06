function [ listSigCatalysis, methanolOrbufferListSigCatalysis ] = process_well_data(fileName, percentPositive, negativeThresh, wellnum)
%proess_well_data takes a file of fluorescent data and determines which
%catalysts are significantly increasing the rate of reaction on the basis
%of positive and negative controls
%   percentPositive - the amount of product that must be produced accroding
%   to fluorescence to indicate significant catalysis. This is a percent
%   (i.e. at least fluroescence corresponding to 25 percent)
%   negativeThresh - the mimimum percent catalysis needed relative to
%   negative control (i.e. if negative control is 1 then if negativeThresh
%   is 40% percent, fluorescent threshold is 1.4)
%   fileName must be xls file (can be changed in inconvenient)
%   wellnum specifies either the first well or the second

%   Preprocess data
    data = xlsread(fileName);
    data = data(:,3:end);
    data = mean(data);
    data = reshape(data,12,8)';
    
    if percentPositive == 5,
        thresh = 1;
    elseif percentPositive == 10,
        thresh = 2;
    elseif percentPositive == 25,
        thresh = 3;
    else
        thresh = 4;
    end
    
    if wellnum == 1,
        titles = {'Solvent 1','Solvent 2','Solvent 3','Solvent 4'};
    elseif wellnum == 2;
        titles = {'Solvent 5','Solvent 6','Solvent 7','Solvent 8'};
    else
        quit
    end
    
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
        
        cutoff = positiveControl(thresh); %thresh specifies 5,10,25, or 50 percent threshold for fluorescence
        sigCatalysis = withcatalyst > withoutcatalyst * (1+negativeThresh/100) & withcatalyst > cutoff;
        listSigCatalysis = [ listSigCatalysis , sigCatalysis ];
        
    
        tograph(1:8,1) = withoutcatalyst';
        tograph(1:8,2) = withcatalyst';
        subplot(2,2,(i+1)/2)
        x = 1:8;
        h1 = bar(x,tograph);
        l = {'.1 imid','.5 imid','1.0 imid','N/A','.1 Et3N','.1 H+sp.','.1 CSA','.1 AcOH'};
        set(gca,'xticklabel',l);
        hold on;
        h2 = plot(x,ones(1,8)*positiveControl(1),'--',x,ones(1,8)*positiveControl(2),'--',x,ones(1,8)*positiveControl(3),'--',x,ones(1,8)*positiveControl(4),'--','LineWidth',4);
        hold off;
%         width1 = 0.5;
%         hBars = bar(withoutcatalyst,width1,'b');
%         set(hBars(1),'BaseValue',cutoff);
%         hBaseline = get(hBars(1),'BaseLine');
%         set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%         hold on;
%         hBars = bar(withcatalyst,width1/2,'r');
%         set(hBars(1),'BaseValue',cutoff);
%         hBaseline = get(hBars(1),'BaseLine');
%         set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%         l = {'.1 imid','.5 imid','1.0 imid','N/A','.1 Et3N','.1 H+sp.','.1 CSA','.1 AcOH'};
%         set(gca,'xticklabel',l);
%         legend('W/o catalyst','With catalyst');
%         hold off;
        title(titles{(i+1)/2});
        
    end
    
    leg = legend([h1';h2],'W/o catalyst','With catalyst', '5','10','25','50','Location','NorthEastOutside');
    set(leg, 'FontSize',7);
    set(leg,'units','pixels');
    set(leg,'position',[730 363 150 98])
          
    
    %Process buffers or methanol
    if wellnum == 1,
        %process buffers
        methanolOrbufferListSigCatalysis = [];
        figure;
        %Buffer can only have threshold of 10 or 25% so adjust default to
        %10%
        if thresh ~= 2 && thresh ~= 3,
            thresh == 2;
        end
        
        titles = {'Buffer A','Buffer B','Buffer C','Buffer D'};
        woC = [];
        wC = [];
        for i=1:2:7, 
            withcatalyst = data(i,9);
            withoutcatalyst = data(i+1,9);
            positiveControl = data(i:i+1,10);
            cutoff = positiveControl(1);
            sigCatalysis = withcatalyst > withoutcatalyst*(1+negativeThresh/100) & withcatalyst > cutoff;
            methanolOrbufferListSigCatalysis = [methanolOrbufferListSigCatalysis, sigCatalysis];
            woC = [woC, withoutcatalyst ];
            wC = [wC, withcatalyst ];

            
%             width1 = 0.5;
%             hBars = bar(1,withoutcatalyst,width1,'b');
%             set(hBars(1),'BaseValue',cutoff);
%             hBaseline = get(hBars(1),'BaseLine');
%             set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%             hold on
%             hBars = bar(1,withcatalyst,width1/2,'r');
%             set(hBars(1),'BaseValue',cutoff);
%             hBaseline = get(hBars(1),'BaseLine');
%             set(hBaseline,'LineStyle',':','Color','red','LineWidth',2);
%             hold off
            
        end
        x = 1:4;
        bar(x,[woC', wC']);
        hold on;
        plot(x,ones(4)*positiveControl(1),'--',x,ones(4)*positiveControl(2),'--','LineWidth',4);
        title(titles{(i+1)/2});
        legend('W/o catalyst','With catalyst');
    elseif wellnum == 2,
        %process methanol
        rv = [1:4,7:8];
        withcatalyst = data(rv,9);
        withoutcatalyst = data(rv,10);
        positiveControl = [data(5,9:10),data(6,9:10)];
        cutoff = positiveControl(thresh);
        methanolOrbufferListSigCatalysis = withcatalyst > withoutcatalyst*(1+negativeThresh/100) & withcatalyst > cutoff;
        figure;
        x = 1:6;
        bar(x,[withoutcatalyst , withcatalyst]);
        hold on;
        plot(x,ones(size(x,2))*positiveControl(1),'--',x,ones(size(x,2))*positiveControl(2),'--',x,ones(size(x,2))*positiveControl(3),'--',x,ones(size(x,2))*positiveControl(4),'--','LineWidth',4);
        l = {'.1 imid','.5 imid','1.0 imid','N/A','.1 CSA','.1 AcOH'};
        set(gca,'xticklabel',l);
        title('Methanol Analysis');
        legend('W/o catalyst','With catalyst');
    else
        quit
    end

end

