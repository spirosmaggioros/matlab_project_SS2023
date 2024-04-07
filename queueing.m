% Μαγγιώρος Σπυρίδων ΑΜ: 03121834
% Τα παρακάτω τρέχουν σε matlab λόγω του ότι κάποια packages
% πλέον δεν λειτουργούν στο τελευταίο version των macos

%Εκθετική κατανομή

% A)
% μας δίνονται οι τιμές 1/λ, επομένως θα ορίσουμε τις τιμές του λ
mean = [0.5, 1.5, 4];
l = 1 ./ mean;

% Φτιάχνουμε το linspace του κ με step 0.00001
k = 0:0.00001:8
colors = ['r', 'g','b','m', 'b','t','s'];

figure(1);
hold on;
% για κάθε τιμή του λ υπολογίζουμε την pdf και την κάνουμε plot
% για το linspace του k. Δεν κάνουμε iterate με τόσο μικρό step 
% διότι δεν θα τελειώσει ποτέ, στο plot είναι optimized και μπορούμε
% να το χρησιμοποιήσουμε
for i=1:length(mean)
  plot(k, exppdf(k,mean(i)), colors(i), "linewidth", 1.5);
end
hold off;
title("PDF of exponential distribution");
xlabel("K");
ylabel("P(X)");
legend("λ1 = 2","λ_2 = 2/3","λ_3 = 1/4");

% B)

% έχουμε ήδη το exp_pdf για κάθε λ
figure(2);
hold on;
new_lambda = l(1) + l(2) + l(3);
new_mean = 1 ./ new_lambda;
for i=1:length(mean)
    % ξανά plot τα προηγούμενα
    plot(k, exppdf(k, mean(i)), colors(i), "LineWidth", 1.5);
end
% και τέλος plot την καινούργια PDF, με λ = λ1 + λ2 + λ3, E = 1 / (λ1 + λ2
% + λ3)
plot(k, exppdf(k, new_mean), colors(4), "LineWidth",1.5);
hold off;
title("X_1, X_2, X_3 and min(X_1, X_2, X_3)");
xlabel("K");
ylabel("P(X)");

% C)

% Δημιουργία της PDF για την Χ ~ Εκθ(0.4)
figure(3)
plot(k, exppdf(k, 2.5), colors(2), "LineWidth",1.5);
title("PDF of exponential distribution with λ = 0.4");
xlabel("K");
ylabel("P(X)");

% Διαδικασία Καταμέτρησης Poisson

% A)
lambda = 10;
mean = lambda;
% Επειδή θέλουμε τα γεγονότα να είναι διαδοχικά, ταξινομούμε τα γεγονότα
random_events = sort(exprnd(mean, [1 100]));
figure(4);
% Δημιουργούμε μια poisson cdf 
stairs(random_events, 1:length(random_events));
title("Poisson Count Process");
xlabel("random events");
ylabel("Number of events");

% Β)
mean_number_of_events = max(random_events) .* lambda;
display(mean_number_of_events);

figure(5);
% φτιάχνουμε ένα 3x3 figure
tiledlayout(3,3);
title("Plots for every number of events");
% το πλήθος των random events που θέλουμε να τεστάρουμε
num_events = [200, 400, 700, 1000, 5000, 50000, 100000];
for i=1:7
    % σε κάθε bucket βάζουμε το ένα subplot
    nexttile
    random_events = sort(exprnd(mean, [1 num_events(i)]));
    stairs(random_events, 1:length(random_events));
end
