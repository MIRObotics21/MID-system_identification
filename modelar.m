%% modelar
function[y] = modelar(u,rad_systemu,TH)
    y = zeros(size(u));
    for k = rad_systemu+1:length(u)
        sum = 0;
        for i=1:rad_systemu
            sum = sum + TH(i+rad_systemu)*u(k-i) - TH(i)*y(k-i); 
        end
        y(k) = sum;
    end
end