clc;
clear;
% clf;
close all;

global num_of_plotik;
num_of_plotik = 1;

% fkce pro nalezeni parametru PRBS, nechte zakomentovane (pouziva vicekrat odezva_2025.p), posledni vstup zpravidla generace plotu 
% identifikace_pro_PRBS(false);

% udaje zjistene z funkce "identifikace_pro_PRBS" a pak generace u a y pomoci PRBS, u funkce posledni vstup == plot
id = 239151;
amp_range = 0.9;                        % podchycuje nelinearitu
doba_nabehu = 30;                       % trochu delsi nez doba nabehu
min_vzorku_na_nabeh = 20;               % 10 na nabeh, ale jelikoz ho mam delsi, tak vic vzorku
pocet_vzorku = 10000-1;
Ts = doba_nabehu/min_vzorku_na_nabeh;   % automaticky dela step v zavislosti na datech nahore
[t,u,y] = generace_PRBS(id,amp_range,doba_nabehu,min_vzorku_na_nabeh,pocet_vzorku,true);    % see function

% jakej pomer chceme mezi trenovacima a validacnima - 0.7 -> 70% trenink 30% validace
podil = 0.7;
[t,u,y,tv,uv,yv] = delic(t,u,y,podil);

% pozadovany rad systemu
% pokud sem bouchnete 1 tak splnuje dobrovolnou cast zadani
rad_systemu = 3;

%% MNC Klasiker
tic
[Y,Phi] = maticator(rad_systemu,u,y);           % generace matic Y a Phi (Z je optional) -> koukni se na funkci

[Y,Phi] = segmentace(Y,Phi);                    % chytre skrtani -> koukni se na funkci

TH_MNC_klasik = Phi \ Y;                        % MNC na jeden radek ez

MNC_klasik_G = prenos(TH_MNC_klasik,rad_systemu,Ts)         % Theta do prenosu
toc

%% MNC Zpozdeny Pozorovatel
tic
d = 2;

[Y,Phi,Z] = maticator(rad_systemu,u,y,2,d);     % stejny postup jak u klasicke

[Y,Phi,Z] = segmentace(Y,Phi,Z);                % figuruje zde i mat. pomoc. prom.

TH_MNC_zpozdeny_pozorovatel = (Z'*Phi)\(Z'*Y);

MNC_zpozdeny_pozorovatel_G = prenos(TH_MNC_zpozdeny_pozorovatel,rad_systemu,Ts)
toc

%% MNC Dodatecny Model
tic
[Y,Phi] = maticator(rad_systemu,u,y);           % stejny postup jak u klasicke

[Y,Phi] = segmentace(Y,Phi);                    

TH_ivm = Phi \ Y;                               % nejprv pomocny model

yivm = modelar(u,rad_systemu,TH_ivm);           % generace yivm

[Y,Phi,Z] = maticator(rad_systemu,u,y,3,yivm);  % pak klasicky proces zopakujeme

[Y,Phi,Z] = segmentace(Y,Phi,Z);

TH_MNC_dodatecny_model = (Z'*Phi)\(Z'*Y);       % vysledky

MNC_dodatecny_model_G = prenos(TH_MNC_dodatecny_model,rad_systemu,Ts)
toc

%% IDENT
% ident model mam fakt slaby, kvuli malemu oknu dat (okno == sektor mezi dvema vypadky mereni)
load('ident_model.mat')                         % vycuc

ident_G = tf(arx221.B,arx221.A,Ts)              % arx 221 (otevri ident)

%% komputace y na validacnich datech
y_MNC_Klasik = modelar(uv,rad_systemu,TH_MNC_klasik);
y_MNC_zpozdeny_pozorovatel = modelar(uv,rad_systemu,TH_MNC_zpozdeny_pozorovatel);
y_MNC_dodatecny_model = modelar(uv,rad_systemu,TH_MNC_dodatecny_model);
y_ident_model = lsim(ident_G, uv, tv);

%% vizualizace
%separe do subplotu
figure(num_of_plotik)
num_of_plotik = num_of_plotik+1;

subplot(4,1,1)
ax1 = gca;
plot(tv,yv,'b',tv,y_MNC_Klasik,"r--");
xlabel("t[s]")
ylabel("y[-]")
legend('Skutecny Vystup','MNC Klasik');
subplot(4,1,2)
ax2 = gca;
plot(tv,yv,'b',tv,y_MNC_zpozdeny_pozorovatel,"r--");
xlabel("t[s]")
ylabel("y[-]")
legend('Skutecny Vystup','MNC se Zpozdenym Pozorovatelem');
subplot(4,1,3)
ax3 = gca;
plot(tv,yv,'b',tv,y_MNC_dodatecny_model,"r--");
xlabel("t[s]")
ylabel("y[-]")
legend('Skutecny Vystup','MNC s Dodatecnym Modelem');
subplot(4,1,4)
ax4 = gca;
plot(tv,yv,'b',tv,y_ident_model,"r--");
xlabel("t[s]")
ylabel("y[-]")
legend('Skutecny Vystup','Ident');
linkaxes([ax1,ax2,ax3,ax4])

%all-in-one
figure(num_of_plotik)
num_of_plotik = num_of_plotik+1;

plot(tv,yv,"b",tv,y_MNC_Klasik,'r',tv,y_MNC_zpozdeny_pozorovatel,'g',tv,y_MNC_dodatecny_model,'y',tv,y_ident_model,'m',tv,uv,'k')
title('all-in-one')
xlabel("t[s]")
ylabel("amplitude[-]")
legend('Skutecny Vystup','MNC Klasik','MNC se Zpozdenym Pozorovatelem','MNC s Dodatecnym Modelem','Ident','Vstupni PRBS');