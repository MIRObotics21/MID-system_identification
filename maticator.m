%% maticator
function[Y,Phi,Z] = maticator(rad_systemu,u,y,method,d_or_yivm)   % vytvoreni matic Y,Phi, a optional Z ---- method=2 je pro zpozdeny pozorovatele a method=3 pro pomocny model
    Y = y;                                          % Y je ez
    Phi = zeros(length(y),rad_systemu*2);           % init Phi
    for j = 1:rad_systemu                           % j pres sloupce/2
        for i = 1:length(y)                         % i pres prvky
            if i-1-j < 0                            % pokud i-1-j mimo matrix tak skipujem
                continue
            else                                    % pokud existuje tak hazime do phi
                Phi(i,j) = -y(i-j);                 % zahazuju -1 protoze ve skutecnosti indexuju od 1, ne od 0
                Phi(i,j+rad_systemu) = u(i-j);      % tady doplnuju druhou polovinu matice - proto jdem jen pres polovinu sloupcu
            end
        end
    end
    if nargin == 5 && nargout == 3 && method == 2   % rozsireni pro mat pomoc. prom.
        Z = zeros(length(y),rad_systemu*2);         % init
        for j = 1:rad_systemu
            for i = 1:length(y)                     % -y jdou se zpozdenim o d
                if i-1-j-d_or_yivm < 0
                    continue
                else
                    Z(i,j) = -y(i-j-d_or_yivm);
                end
            end
            for i = 1:length(y)                     % u jsou v klidu stejne jako u Phi
                if i-1-j < 0
                    continue
                else
                    Z(i,j+rad_systemu) = u(i-j);
                end
            end
        end
    end
    if nargin == 5 && nargout == 3 && method == 3           % v podstate stejne jako phicko, jen sunu yivm misto y
        Z = zeros(length(d_or_yivm),rad_systemu*2);         % init
        for j = 1:rad_systemu
            for i = 1:length(d_or_yivm)                     % -yivm
                if i-1-j < 0
                    continue
                else
                    Z(i,j) = -d_or_yivm(i-j);
                end
            end
            for i = 1:length(d_or_yivm)                     % u jsou v klidu stejne jako u Phi
                if i-1-j < 0
                    continue
                else
                    Z(i,j+rad_systemu) = u(i-j);
                end
            end
        end
    end
end