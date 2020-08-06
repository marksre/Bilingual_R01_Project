%% Contrasts controlling for age & maternal education
c1MA=[1 0 0 1 0 0 1 0 0 0 0]; %3 conditions
c2MA=[1 0 0 0 0 0 0 0 0 0 0]; %easy
c3MA=[0 0 0 1 0 0 0 0 0 0 0]; %hard
c4MA=[0 0 0 0 0 0 1 0 0 0 0]; %control

c5MA=[1 0 0 1 0 0 0 0 0 0 0]; %task > rest
c6MA=[1 0 0 1 0 0 -1 0 0 0 0]; %task > control
c7MA=[1 0 0 0 0 0 -1 0 0 0 0]; %easy > control
c8MA=[0 0 0 1 0 0 -1 0 0 0 0]; %hard > control

ageMA=[0 0 0 0 0 0 0 0 0 1 0]; %age only
sesMA=[0 0 0 0 0 0 0 0 0 0 1]; %maternal ed only


[intensity1,p1]=getintensity(c1MA,GroupStats1);
[intensity2,p2]=getintensity(c2MA,GroupStats1);
[intensity3,p3]=getintensity(c3MA,GroupStats1);
[intensity4,p4]=getintensity(c4MA,GroupStats1);
[intensity5,p5]=getintensity(c5MA,GroupStats1);
[intensity6,p6]=getintensity(c6MA,GroupStats1);
[intensity7,p7]=getintensity(c7MA,GroupStats1);
[intensity8,p8]=getintensity(c8MA,GroupStats1);
[intensity9,p9]=getintensity(ageMA,GroupStats1);
[intensity10,p10]=getintensity(sesMA,GroupStats1);

%% Plot the 3D image
onlypositive=0;

%% Figure 1: All task conditions
figure
subplot(2,2,1)
plot(intensity1,onlypositive,p1);
title('MA All')

subplot(2,2,2)
plot(intensity2,onlypositive,p2);
title('Easy')

subplot(2,2,3)
plot(intensity3,onlypositive,p3);
title('Hard')

subplot(2,2,4)
plot(intensity14,onlypositive,p14);
title('Control')

%% Figure 2: Contrasts between conditions
figure
subplot(2,2,1)
plot(intensity5,onlypositive,p5);
title('Easy+Hard > Rest')

subplot(2,2,2)
plot(intensity6,onlypositive,p6);
title('Easy+Hard > Control')

subplot(2,2,3)
plot(intensity7,onlypositive,p7);
title('Easy > Control')

subplot(2,2,4)
plot(intensity8,onlypositive,p8);
title('Hard > Control')

%% Figure 3: Covariates of no interest
figure
subplot(2,1,1);
plot(intensity9,onlypositive,p9)
title('Age')

subplot(2,1,2);
plot(intensity10,onlypositive,p10)
title('MatEd')


%% Functions
function [intensity,p] = getintensity(c,GroupStats)
Contrast=GroupStats.ttest(c);
Contrasttable=Contrast.table;
intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo'));
p=Contrasttable.p(strcmp(Contrasttable.type,'hbo'));
end

function plot(intensity,onlypositive,p)
load CHMNI_Bilateral46_AUG2020.mat % Load Coordinates - Updated Aug 2020
    % MNIcoordUnilateral23_AUG2020: Left hemisphere, removed channels 7 & 8 
    % Localization fixed August 2020, all coordinates shifted down slightly
mx=4;
mn=-4;

% remove the negative intensity associated ind
if onlypositive
    negind=find(intensity<=0);
else
    negind=[];
end

insigind=find(p>=0.05);


if ~isempty(negind)
    rind=unique([negind insigind]);
else
    rind=insigind;
end

intensity(rind)=[];
CHMNI(rind,:)=[];

MNIcoordstd=10*ones(length(CHMNI));

Plot3D_channel_registration_result(intensity, CHMNI, MNIcoordstd,mx,mn);

camlight('headlight','infinite');
lighting gouraud
material dull;
end