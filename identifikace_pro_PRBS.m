%% identifikace ze stepiku
function[] = identifikation_von_sprungantwort(ploticek)
global num_of_plotik;
    Ts = 0.1;                                                               % hezky malinkatej step
    max = 150;                                                              % doba
    step_strengths = 0.89:0.001:0.91;                                       % stepiky, ktery budu prochazet
    % step_strengths = [0.5 0.8 0.85 0.88 0.89 0.9 0.91 0.92 0.93 1];  
    gains = zeros(1,length(step_strengths));                                % init observovanych gainu

    if ploticek == true                                                     % bs ploticek
        figure(num_of_plotik)
        num_of_plotik = num_of_plotik + 1;
        hold on
    end

    for i=1:length(step_strengths)                                          % pro kazdy stepik generuje odezvu
        t = 0:Ts:max;
        u = ones(1,length(t))*step_strengths(i);
        y = odezva_2025(239151,u,t);
        avrg = mean(y(end-100:end));                                        % average 100 konecnych hodnot
        gain = round(avrg/step_strengths(i),2,"decimals");                  % vypocet gainu z average a stepiku
        gains(i) = gain;

        if ploticek == true                                                 % extra ploticek (zbytecny)
            plot(t,y)
            plot(t,avrg*ones(1,length(t)))
        end
        if i>1 && gain ~= gains(i-1)
            fprintf('step strenghts and their corresponding gains:\n\n')
            disp(step_strengths(i-5:i))
            disp(gains(i-5:i))
            break
        end
    end
end