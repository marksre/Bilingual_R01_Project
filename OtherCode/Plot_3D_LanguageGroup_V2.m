%% Get the beta values
GroupStats=GroupStats8;
channelremove=1;

c1=[1 1 1 -1 -1 -1];
% c1=[1 0 0 1 0 0 1 0 0 -1 0 0 -1 0 0 -1 0 0];
intensity1=getintensity(c1,GroupStats);

c2=[-1 -1 -1 1 1 1];
% c2=[-1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0];
intensity2=getintensity(c2,GroupStats);

c3=[1 1 1 0 0 0];
% c3=[1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
intensity3=getintensity(c3,GroupStats);

c4=[0 0 0 1 1 1];
% c4=[0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 1 0 0];
intensity4=getintensity(c4,GroupStats);

%% Plot the 3D image
figure
onlypositive=1;

subplot(2,2,1);
plot(intensity1,onlypositive,channelremove);
title('Easy+Hard (EN MA-PA)')
subplot(2,2,2);
plot(intensity2,onlypositive,channelremove)
title('Easy+Hard (EN PA-MA)')
subplot(2,2,3);
plot(intensity3,onlypositive,channelremove)
title('Easy + Hard (EN MA)')
subplot(2,2,4);
plot(intensity4,onlypositive,channelremove)
title('Easy + Hard (EN PA)')

%% Functions
function intensity = getintensity(c,GroupStats)
Contrast=GroupStats.ttest(c);
Contrasttable=Contrast.table;
intensity=Contrasttable.tstat(strcmp(Contrasttable.type,'hbo')&ismember(Contrasttable.source,[1 2 3 4 5 6 7 8]));
end

function plot(intensity,onlypositive,channelremove)
load MNIcoordTwoNewSource.mat % Load Coordinates
mx=4;
mn=-4;

% remove the negative intensity associated ind
if onlypositive
    negind=find(intensity<=0);
    intensity(negind)=[];
    MNIcoordNEW(negind,:)=[];
end

if channelremove
    MNIcoordNEW(end-7+1:end,:)=[];
end

MNIcoordstd=10*ones(length(MNIcoordNEW));

Plot3D_channel_registration_result(intensity, MNIcoordNEW, MNIcoordstd,mx,mn);

camlight('headlight','infinite');
lighting gouraud
material dull;
end