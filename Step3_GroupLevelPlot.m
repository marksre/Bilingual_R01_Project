c1MA=[0 0 0 0 1 0 0 0 0 0 0 0 0];
c2MA=[0 0 0 0 0 0 0 1 0 0 0 0 0];
c3MA=[0 0 0 0 0 0 0 0 0 0 1 0 0];
c4MA=[0 0 0 0 1 0 0 1 0 0 1 0 0];

ageMA=[1 0 0 0 0 0 0 0 0 0 0 0 0];
elmmMA=[0 1 0 0 0 0 0 0 0 0 0 0 0];
lwidMA=[0 0 1 0 0 0 0 0 0 0 0 0 0];
p1eduMA=[0 0 0 1 0 0 0 0 0 0 0 0 0];

[intensity11,p11]=getintensity(c1MA,GroupStatsMA);
[intensity12,p12]=getintensity(c2MA,GroupStatsMA);
[intensity13,p13]=getintensity(c3MA,GroupStatsMA);
[intensity14,p14]=getintensity(c4MA,GroupStatsMA);

[intensity2,p2]=getintensity(ageMA,GroupStatsMA);
[intensity3,p3]=getintensity(elmmMA,GroupStatsMA);
[intensity4,p4]=getintensity(lwidMA,GroupStatsMA);
[intensity5,p5]=getintensity(p1eduMA,GroupStatsMA);

c1PA=[0 0 0 0 1 0 0 0 0 0 0 0 0];
c2PA=[0 0 0 0 0 0 0 1 0 0 0 0 0];
c3PA=[0 0 0 0 0 0 0 0 0 0 1 0 0];
c4PA=[0 0 0 0 1 0 0 1 0 0 1 0 0];

agePA=[1 0 0 0 0 0 0 0 0 0 0 0 0];
ctoppPA=[0 1 0 0 0 0 0 0 0 0 0 0 0];
lwidPA=[0 0 1 0 0 0 0 0 0 0 0 0 0];
p1eduPA=[0 0 0 1 0 0 0 0 0 0 0 0 0];

[intensity61,p61]=getintensity(c1PA,GroupStatsPA);
[intensity62,p62]=getintensity(c2PA,GroupStatsPA);
[intensity63,p63]=getintensity(c3PA,GroupStatsPA);
[intensity64,p64]=getintensity(c4PA,GroupStatsPA);


[intensity7,p7]=getintensity(agePA,GroupStatsPA);
[intensity8,p8]=getintensity(ctoppPA,GroupStatsPA);
[intensity9,p9]=getintensity(lwidPA,GroupStatsPA);
[intensity10,p10]=getintensity(p1eduPA,GroupStatsPA);
%% Plot the 3D image

% MA
onlypositive=0;

figure

subplot(2,2,1)
plot(intensity11,onlypositive,p11);
title('MA Easy')

subplot(2,2,2)
plot(intensity12,onlypositive,p12);
title('MA Hard')

subplot(2,2,3)
plot(intensity13,onlypositive,p13);
title('MA Cont')

subplot(2,2,4)
plot(intensity14,onlypositive,p14);
title('MA Easy + Hard + Cont')
figure

subplot(2,2,1);
plot(intensity2,onlypositive,p2)
title('MAAGE')
subplot(2,2,2);
plot(intensity3,onlypositive,p3)
title('MAELMM')
subplot(2,2,3);
plot(intensity4,onlypositive,p4)
title('MALWID')
subplot(2,2,4);
plot(intensity5,onlypositive,p5)
title('MAP1_EDU')


% PA

figure

subplot(2,2,1)
plot(intensity61,onlypositive,p61);
title('PA Easy')

subplot(2,2,2)
plot(intensity62,onlypositive,p62);
title('PA Hard')

subplot(2,2,3)
plot(intensity63,onlypositive,p63);
title('PA Cont')

subplot(2,2,4)
plot(intensity64,onlypositive,p64);
title('PA Easy + Hard + Cont')

figure

subplot(2,2,1);
plot(intensity7,onlypositive,p7)
title('PAAGE')
subplot(2,2,2);
plot(intensity8,onlypositive,p8)
title('PACTOPP')
subplot(2,2,3);
plot(intensity9,onlypositive,p9)
title('PALWID')
subplot(2,2,4);
plot(intensity10,onlypositive,p10)
title('PAP1EDU')


%% Functions
function [intensity,p] = getintensity(c,GroupStats)
Contrast=GroupStats.ttest(c);
Contrasttable=Contrast.table;
% intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo')&ismember(Contrasttable.source,[1 2 3 4 5 6 7 8]));
intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo'));
p=Contrasttable.p(strcmp(Contrasttable.type,'hbo'));
end

function plot(intensity,onlypositive,p)
load CHMNI_Bilateral46_AUG2020.mat % Load Coordinates - Updated coordinates on Aug 2020
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