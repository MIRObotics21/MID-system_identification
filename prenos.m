function[G] = prenos(TH,rad_systemu,Ts)         % funkce na dynamickou tvorbu prenosu
    num = zeros(1,rad_systemu);
    den = zeros(1,rad_systemu);
    for i=1:rad_systemu
        num(i) = TH(i+rad_systemu);
        den(i) = TH(i);
    end
    G = tf([0 num],[1 den],Ts);
end