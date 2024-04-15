clc;
clear all;
close all;

pkg load queueing;

lambda = 5;
mu = 10;

% Έχουμε 4 συνολικά states όπως έχω σχεδιάσει και στην αναφορά
states = [0, 1, 2, 3];
initial_state = [1, 0, 0, 0];
% φτιάχνουμε τα birts/deaths του συστήματος
births = [lambda/2, lambda/3, lambda/4];
deaths = [mu, mu, mu];

% με το ctmcbd() φτιάχνω το transition matrix
transition_mtx = ctmcbd(births, deaths);
display(transition_mtx);

% με το ctmc() παίρνω τις εργοδικές πιθανότητες για να σιγουρευτώ ότι είναι αυτές
% που βρήκα και θεωρητικά
P_i = ctmc(transition_mtx);
for i=1:4
  display(P_i(i));  
endfor

% Ας κάνω και το γράφημα
figure(1);
hold on;
plot(states, P_i,"linewidth", 1.2);
xlabel("States");
ylabel("Probability");
title("Probability of each state");
hold off;

% Υπολογισμός του Pbl == πιθανότητα απόρριψης πελάτη
P_bl = P_i(4);
display("P_bl = ");
display(P_bl);

% Υπολογισμός του μέσου αριθμού πελατών στο σύστημα όταν βρίσκεται
% σε συνθήκη ισορροπίας 
mean_clients = 0;
for i=1:4
  mean_clients = mean_clients + i * P_i(i);  
endfor
display("Mean number of clients is : ");
display(mean_clients);

% Υπολογισμός του μέσου αριθμού πελατών που θα εξυπηρετηθεί από το σύστημα
% σε 60 secs αφού βρεθέι σε κατάσταση ισορροπίας.
% ---------

% Σχεδιασμός των διαγραμμάτων των πιθανοτήτων καταστάσεων από την αρχική κατάσταση 
% έως οι πιθανότητες να έχουν απόσταση μικρότερη του 1% από τις εργοδικές πιθανότητες
% του ερωτήματος 2
figures = 2;
for i=1:4
  ind = 0
  for lin = 0:0.01:100
    ind += 1;
    P = ctmc(transition_mtx, lin, initial_state); % εδώ χρησιμοποιώ την ctmc με ένα linspace σαν parameter    
    prob(ind) = P(i);
    if P - P_i < 0.01 %threshold
      break;
    endif
  endfor  
  __lin = 0:0.01:lin;
  figure(figures);
  hold on;
  plot(__lin, prob, "linewidth", 1.2);
  xlabel("time");
  ylabel("Probability");
  title(sprintf("State: %d", i));
  hold off;
  figures += 1;
endfor

% εκτελούμε τα ίδια για άλλες τιμές lambda και mu
% αρχικά ας φτιάξω το παραπάνω σε function 
function prob_diagrams(P_i, transition_mtx, lin, initial_state, figures)
  for i=1:4
    ind = 0
    for lin = 0:0.01:100
      ind += 1;
      P = ctmc(transition_mtx, lin, initial_state); % εδώ χρησιμοποιώ την ctmc με ένα linspace σαν parameter    
      prob(ind) = P(i);
      if P - P_i < 0.01 %threshold
        break;
      endif
    endfor  
    __lin = 0:0.01:lin;
    figure(figures);
    hold on;
    plot(__lin, prob, "linewidth", 1.2);
    xlabel("time");
    ylabel("Probability");
    title(sprintf("State: %d", i));
    hold off;
    figures += 1;
  endfor
endfunction

% για lambda = 5, mu = 1
lambda = 5;
mu = 1;
births = [lambda/2, lambda/3, lambda/4];
deaths = [mu, mu, mu];
transition_mtx = ctmcbd(births, deaths);
P_i = ctmc(transition_mtx);
prob_diagrams(P_i, transition_mtx, lin, initial_state, figures);

% για lambda = 5, mu = 5
lambda = 5;
mu = 5;
births = [lambda/2, lambda/3, lambda/4];
deaths = [mu, mu, mu];
transition_mtx = ctmcbd(births, deaths);
P_i = ctmc(transition_mtx);
prob_diagrams(P_i, transition_mtx, lin, initial_state, figures);

% για lambda = 5, mu = 20
lambda = 5;
mu = 20;
births = [lambda/2, lambda/3, lambda/4];
deaths = [mu, mu, mu];
transition_mtx = ctmcbd(births, deaths);
P_i = ctmc(transition_mtx);
prob_diagrams(P_i, transition_mtx, lin, initial_state, figures);












