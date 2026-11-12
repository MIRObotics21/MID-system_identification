function[t,u,y] = generace_PRBS(id,amp_range,doba_nabehu,min_vzorku_na_nabeh,pocet_vzorku,ploticek)
    global num_of_plotik;
    Ts = doba_nabehu/min_vzorku_na_nabeh;                                           % vzorkovani
    stop_time = Ts*pocet_vzorku;                                                    % snad pochopitelny
    t = (0:Ts:stop_time)';
    N = length(t);
    
    u = idinput(N, 'prbs', [0 1/(doba_nabehu/Ts)], [-amp_range amp_range]);         % generace PRBS podle poznatku z hodiny a matlab help +++ min_vzorku_na_nabeh=doba_nabehu/Ts
    y = odezva_2025(id,u,t);                                                        % konecne y
    
    if ploticek == true                                                             % not needed
        figure(num_of_plotik)
        num_of_plotik = num_of_plotik + 1;
        plot(t,y,'b',t,u,'k')
        xlabel("t[s]")
        ylabel("amplitude[-]")
        legend('y','u');
        title('vstupni PRBS a y')
    end
end