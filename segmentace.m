%% segmentatory
function[Y,Phi,Z] = segmentace(Y,Phi,Z)         % chytra all-in-one kombinace vsech funkci dole
    Y_Mask = masken(Y);
    Phi_Mask = masken(Phi);
    if nargin == 2 && nargout == 2                          % verze pro klasikou
        Mask = masken_kombinieren(Y_Mask,Phi_Mask);
        [Y,Phi] = pruner(Mask,Y,Phi);
    else                                                    % verze pro rozsirenou
        Z_Mask = masken(Z);             
        Mask = masken_kombinieren(Y_Mask,Phi_Mask,Z_Mask);
        [Y,Phi,Z] = pruner(Mask,Y,Phi,Z);
    end
end

%% single maska
function[Mask] = masken(A)                      % vytvoreni masky pro vektor/matici -> maska staci kdyz bude single vektor, v matici stejne odrizne cely radek
    Mask = ones(size(A,1),1);                   % init do jednicek
    for j = 1:size(A,2)                         % j pres sloupce A
        for i = 1:size(A,1)                     % i pres radky A
            if A(i,j) == 0                      % pokud vypadek -> (0)
                Mask(i,1) = 0;                  % dej odpovidajici prvek masky 0
            end
        end
    end

end

%% kombinovani masek
function[Mask] = masken_kombinieren(A,B,C)      % jednoducha kombinace masek - pronasobeni prvku vektoru .*
    Mask = A.*B;                                % verze pro klasikou
    if nargin == 3
        Mask = Mask.*C;                         % verze pro rozsirenou
    end
end

%% chytre skrtani
function[Y,Phi,Z] = pruner(Mask,Y,Phi,Z)
    for i=length(Mask):-1:1                     % jedeme od zadu, jelikoz prorezavame vektor a "ztracime" indexi
        if Mask(i) == 0                         % verze pro klasikou
            Y(i) = [];
            Phi(i,:) = [];
        end
        if Mask(i) == 0 && nargin == 4          % verze pro rozsirenou
            Z(i,:) = [];
        end
    end
end