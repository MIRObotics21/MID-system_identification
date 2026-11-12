%% delic u
function[t,u,y,tv,uv,yv] = delic(t,u,y,podil)
    n = length(t)*podil;                        % konkretni pocet treninkovych
    tv = zeros(length(t)-n,1);                  % init testovacich
    uv = zeros(length(t)-n,1);
    yv = zeros(length(t)-n,1);
    for i = 1:length(t)-n                       % vyplnuju testovaci od n+1 do konce
        tv(i) = t(i+n)-t(1+n);
        uv(i) = u(i+n);
        yv(i) = y(i+n);
    end
    for i = length(t):-1:n+1                    % potom co mam hotove testovaci, tak je killnu v treninkovych, jo a killuju od zadu kvuli indexaci
        t(i) = [];
        u(i) = [];
        y(i) = [];
    end
end