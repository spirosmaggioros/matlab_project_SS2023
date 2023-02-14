%Όνομα : Μαγγιώρος Σπύρος
%ΑΜ : 03121834
%όλος ο κώδικας θα βρίσκεται και στο github μου , για αν τυχόν υπάρχουν προβλήματα :
% https://github.com/spirosmaggioros/matlab_project_SS2023
%προφανώς το έχω private εως ότου τελειώσει η προθεσμία


%Άσκηση 1

clc
close all;
warning off;
Fs = 8000;



%1b
[spiros,Fs] = audioread('spiros.wav');
t = linspace(0 , 3,3*Fs);
figure(1);
plot(t, spiros);
xlabel('time(s)');
title('Audio Graph');

starting_point = Fs*1.5;
ending_point = Fs*1.55;
%διάρκεια 50ms

window = spiros(starting_point:ending_point);%το window στο [starting_point,ending_point]
figure(2);
t2 = linspace(1.5 , 1.55 , length(window));
plot(t2 , window);
xlabel('time(s)');
title('window of audio signal');
sound(window);
%1b



%1c
normalized = normalize(spiros , 'range' , [-1,1]);%κανονικοποίηση σήματος στο [-1,1]
figure(3);
plot(t,normalized);
xlabel('time(s)');
title('Normalized audio graph');

M = 200;
n = linspace(0,M,2500);
w = 0.54 - 0.46*cos((2*pi*n) / M);
%το παράθυρο hamming έχει συνέλιξη του χ^2 και όχι του χ , επομένως
%θα πρέπει να κάνουμε conv(x^2 , w)

hamming = conv(normalized.*normalized, w);
normalized = normalize(normalized , 'range', [min(hamming) , max(hamming)]);
figure(4);
t4 = linspace(0 , 3 , length(hamming));
plot(t , normalized);
hold on;
plot(t4 , hamming);
hold off;
xlabel('time(s)');
legend('Audio signal' , 'hamming');
title("Signal Energy");
    
%1c

%1d
T = 1/8000;
dtft_window = fft(window , 1024) * T;%1024 δείγματα
%τύπος για dtft , αν κάναμε σκέτο fft() θα έπρεπε να διαιρέσω με την
%περίοδο και να κάνω πράξεις

t5 = linspace(0,8000,length(dtft_window));
figure(5);
plot(t5 , abs(dtft_window));
xlabel('freqency(Hz)');
title('DTFT linear scale');

figure(6);
plot(t5 , 20*log10(abs(dtft_window)));
xlabel('frequency(Hz)');
title('DTFT logarithmic scale');

%1d

%Τέλος Άσκησης 1





%Άσκηση 2
%2.a
leaf = imread("pictures/leaf3.png");
figure(100);
imshow(leaf);
%end 2.a

%2.b
%Η εικόνα είναι ήδη δυαδική , θα φτιάξουμε τα ζεύγη
%Η διάσταση του πίνακα είναι το μέγεθος της εικόνας, είναι δυαδικό
    
%φτιάχνουμε τα rows και columns
[row,col]  = find(leaf);%η εικόνα είναι δυαδική , άρα βρίσκω τα ζευγή για τα οποία [x,y] == 1
boundary = bwtraceboundary(leaf , [row(1),col(1)],'S');
figure(7);
plot(boundary(:,1));
hold on;
plot(boundary(:,2));
hold off;
legend('x' , 'y');
title('Image Tracing boundaries');

%end 2.b


%2.c
%για να τα εχω καλύτερα θα τα αποθηκεύσω σε variables
x = boundary(:,1);
y = boundary(:,2);
z = x + 1i*y;

plot_four = fft(z);
figure(8);
plot(abs(plot_four));
xlabel('frequency(Hz)');
title('DTFT of Z[k]');
%end 2.c

%2d
S = length(z);
z_10 = zeros(S , 1);%αρχικοποίηση στις κατάλληλες τιμές(για όλα τα z_M)
for n = 1:S
    z_10(n) = fourier(S , 10 , n , plot_four);
end
x_10 = abs(round(real(z_10)));%παίρνουμε το απόλυτο και floored κομμάτι του z_M
y_10 = abs(round(imag(z_10)));%ομοίως το φανταστικό
I_10 = reconstruct(x_10 , y_10);%έπειτα γεμίζουμε τον δυαδικό πίνακα I_M κατάλληλα(θυμίζουμε έχουμε δυαδική εικόνα)
figure(9);
imshow(I_10);%και την εμφανίζουμε

z_50 = zeros(S , 1);
for n = 1:S
    z_50(n) = fourier(S , 50 , n , plot_four);
end
x_50 = abs(round(real(z_50)));
y_50 = abs(round(imag(z_50)));
I_50 = reconstruct(x_50 , y_50);
figure(10);
imshow(I_50);

z_200 = zeros(S , 1);
for n = 1:S
    z_200(n) = fourier(S , 200 , n , plot_four);
end
x_200 = abs(round(real(z_200)));
y_200 = abs(round(imag(z_200)));
I_200 = reconstruct(x_200 , y_200);
figure(11);
imshow(I_200);

%end 2.d


%2.e
%με την ίδια λογική , έχουμε ήδη έτοιμες τις συναρτήσεις , το μόνο που
%αλλάζουμε είναι ότι τώρα χρησιμοποιούμε επιπλέον την fourier_log η οποία
%μας βοηθάει να υπολογίσουμε το άθροισμα που μας ζητείται

new_z_10 = zeros(S , 1);
for n = 1:S
    new_z_10(n) = fourier(S , 10/2 , n , plot_four) + fourier_log(S ,10 , n,plot_four);
end
new_x_10 = abs(round(real(new_z_10)));
new_y_10 = abs(round(imag(new_z_10)));
new_I_10 = reconstruct(new_x_10 , new_y_10);
figure(12);
imshow(new_I_10);

new_z_50 = zeros(S , 1);
for n = 1:S
    new_z_50(n) = fourier(S , 50/2 , n , plot_four) + fourier_log(S , 50 , n , plot_four);
end
new_x_50 = abs(round(real(new_z_50)));
new_y_50 = abs(round(imag(new_z_50)));
new_I_50 = reconstruct(new_x_50 , new_y_50);
figure(13);
imshow(new_I_50);

new_z_200 = zeros(S , 1);
for n = 1:S
    new_z_200(n) = fourier(S , 200/2 , n , plot_four) + fourier_log(S , 200 , n , plot_four);
end
new_x_200 = abs(round(real(new_z_200)));
new_y_200 = abs(round(imag(new_z_200)));
new_I_200 = reconstruct(new_x_200 , new_y_200);
figure(14);
imshow(new_I_200);

%end 2.e

%2.f
clearvars;
graph = imread("pictures/bfl.png");
figure(15);
imshow(graph);
binary_graph = im2bw(graph , 0.5);
figure(16);
imshow(binary_graph);
[rrow , ccol] = find(binary_graph);
boundary_graph = bwtraceboundary(binary_graph , [rrow(1),ccol(1)],'S');
x_graph = boundary_graph(:,1);
y_graph = boundary_graph(:,2);
z_new = x_graph + 1i*y_graph;

graph_fourier = fft(z_new);

N = length(z_new);
z_graph_10 = zeros(N , 1);
for n = 1:N
   z_graph_10(n) = fourier(N , 10/2 , n - 1 , graph_fourier) + fourier_log(N , 10 , n - 1 , graph_fourier);
end
x_graph_10 = abs(round(real(z_graph_10)));
y_graph_10 = abs(round(imag(z_graph_10)));
I_graph_10 = reconstruct(x_graph_10 , y_graph_10);
figure(17);
imshow(I_graph_10);

N = length(z_new);
z_graph_10 = zeros(N , 1);
for n = 1:N
   z_graph_10(n) = fourier(N , 50/2 , n - 1 , graph_fourier) + fourier_log(N , 50 , n - 1 , graph_fourier);
end
x_graph_10 = abs(round(real(z_graph_10)));
y_graph_10 = abs(round(imag(z_graph_10)));
I_graph_10 = reconstruct(x_graph_10 , y_graph_10);
figure(18);
imshow(I_graph_10);

N = length(z_new);
z_graph_10 = zeros(N , 1);
for n = 1:N
   z_graph_10(n) = fourier(N , 200/2 , n - 1 , graph_fourier) + fourier_log(N , 200 , n - 1 , graph_fourier);
end
x_graph_10 = abs(round(real(z_graph_10)));
y_graph_10 = abs(round(imag(z_graph_10)));
I_graph_10 = reconstruct(x_graph_10 , y_graph_10);
figure(19);
imshow(I_graph_10);

%end 2.f


%Τέλος Άσκησης 2

%Άσκηση 3

%3.1

poles = [0.51+0.68i; 0.51-0.68i];
zeros = [0.8;-1];
figure(20);
zplane(zeros , poles);

K = 0.15;
[b,a] = zp2tf(zeros , poles , 0.15);
figure(21);
freqz(b,a);

figure(22);
impz(b,a);

figure(23);
stepz(b,a);

poles_new_1 = [0.57 + 0.76i; 0.57 - 0.76i];
poles_new_2 = [0.6 + 0.8i; 0.6 - 0.8i];
poles_new_3 = [0.63 + 0.84i; 0.63 - 0.84i];

[b_new_1 , a_new_1] = zp2tf(zeros , poles_new_1 , 0.15);
figure(24);
freqz(b_new_1 , a_new_1);
figure(25)
stepz(b_new_1 , a_new_1)

[b_new_2 , a_new_2] = zp2tf(zeros , poles_new_2 , 0.15);
figure(26);
freqz(b_new_2 , a_new_2);
figure(27);
stepz(b_new_2 , a_new_2);
figure(28); 
zplane(zeros , poles_new_2);

n = 0:99;%δεν χρειαζόταν , γιατί παίρνω κατευθείαν t = 100s με παλμό 1sec , νομίζω.
x = sin(0.3*pi*n) + sin(0.7*pi*n);

y = filter(b,a,x);

figure(29);
plot(n ,x,'b',n, y , 'r');
legend('Input' , 'Output');

new_poles = [0.68 + 0.51i; 0.68 - 0.51i];
[b_new_3 , a_new_3] = zp2tf(zeros , new_poles , 0.15);
figure(30);
freqz(b_new_3 , a_new_3);
figure(31);
stepz(b_new_3 , a_new_3);

%Τέλος 3.1

%3.2

Fs_1 = 44100;%sampling frequency in Hz
T_1 = 1 / Fs_1;%sampling period
[viola,Fs_1] = audioread("audios/viola_series.wav");
sound(viola);
figure(32);
plot(linspace(0 , Fs_1 , length(viola)) , viola);
title("Signal of Viola");

f_viola_series = fft(viola);
figure(33);
plot(linspace(0 , Fs_1 , length(f_viola_series)) , f_viola_series);
title("FFT of viola");


[viola_note,Fs_1] = audioread("audios/viola_note.wav");

f_viola_note = fft(viola_note);
figure(34);
plot(linspace(0 , Fs_1 , length(f_viola_note)) , abs(f_viola_note));
title("FFT of viola note");

%magnitude of DFT
viola_magn = abs(f_viola_note);

%η μεγαλύτερη συχνότητα αντιπροσωπεύει την θεμελιώδη συχνότητα του fft του
%σήματος
[~,max_ind] = max(viola_magn);

%μετατροπή συχνότητας απο bin σε Hz 
fund_freq = (max_ind - 1)*Fs_1 / length(f_viola_note);
figure(35);
plot(viola_magn);
title("Magnitude of DFT");
figure(36);
plot(fund_freq);

%3.2d
%για να εξάγουμε την 2η αρμονική , φίλτρο
poles_2nd = [0.995 + 0.092i; 0.995 + 0.092i; 0.995 - 0.092i; 0.995 - 0.092i];
zeros_2nd = [0.998; 0.998i; -0.998; -0.998i];
figure(37);
zplane(zeros_2nd , poles_2nd);

%όπως και στα προηγούμενα , φτιάχνω τα α,β μου
[b_2nd,a_2nd] = zp2tf(zeros_2nd , poles_2nd , 10^-7);
%περνάω το σήμα απο το φίλτρο που μολις εφτιαξα
y_2nd = filter(b , a , viola_note);
figure(38);
shiftarw για να κεντραριστεί
y_fft = fftshift(fft(y_2nd));
plot(linspace(-Fs_1/2 , Fs_1/2 , length(y_fft)) , abs(y_fft));
title("DFT of 2nd harmonic");

figure(39);
%γράφημα για το φιλτραρισμένο
plot(linspace(0,600,length(y_2nd(2000:3000))) , y_2nd(2000:3000));
xlabel("time(s)");
title("plot of viola\_note after filtering");

%για την 3η αρμονικη
poles_3rd = [0.990 + 0.138i; 0.990 + 0.138i; 0.990 - 0.138i; 0.990 - 0.138i];
zeros_3rd = [0.994; 0.994i; -0.994; -0.994i];
figure(40);
zplane(zeros_3rd , poles_3rd);
[b_3rd , a_3rd] = zp2tf(zeros_3rd , poles_3rd , 10^-7);
y_3rd = filter(b_3rd , a_3rd , viola_note);
figure(41);
y3rd_fft = fftshift(fft(y_3rd));
plot(linspace(-Fs_1 / 2 , Fs_1/2 , length(y3rd_fft)) , abs(y3rd_fft));
title("DFT of 3rd harmonic");

figure(42);
plot(linspace(0 , 2000 , length(y3rd_fft(2000:8000))) , y_3rd(2000:8000));
xlabel("Time(s)");
title("plot of viola\_note after filtering");




%end 3.2d

%Τέλος 3.2

%Τέλος Άσκησης 3


%Άσκηση 4
%4.1
Fs2 = 16000;
[mix,Fs2] = audioread('audios/mixture.wav');
[mix2,Fs2] = audioread('audios/mixture.wav');
sound(mix);
mix_f = fft(mix);
figure(43);
plot(linspace(0 , Fs2 , length(mix_f)) , abs(mix_f));
%συμμετρικό , άρα κόβουμε το σήμα μέχρι το 6000 για να φανεί καλύτερα.
title("FFT of mixture");
xlim([0 6000]);
%end of 4.1

%4.b
f1 = 350;
f2 = 440;
%για την πρώτη νότα
h2_1 = 2*f1;
h3_1 = 3*f1;
h4_1 = 4*f1;
h5_1 = 5*f1;
%για την 2η νοτα
h2_2 = 2*f2;
h3_2 = 3*f2;
h4_2 = 4*f2;
h5_2 = 5*f2;

%για τις κανονικοποιημένες συχνότητες της πρώτης νότας
%στα παρακάτω hi_j -> i-στη αρμονική της j-οστης νότας
h1_1_normalized = (f1 / Fs2)*2*pi;
h2_1_normalized = (2*f1/Fs2)*2*pi;
h3_1_normalized = (3*f1/Fs2)*2*pi;
h4_1_normalized = (4*f1/Fs2)*2*pi;
h5_1_normalized = (5*f1/Fs2)*2*pi;
%για τις κανονικοποιημένες συχνότητες της 2ης νότας
h1_2_normalized = (2*f2/Fs2)*2*pi;
h2_2_normalized = (2*f2/Fs2)*2*pi;
h3_2_normalized = (2*f2/Fs2)*2*pi;
h4_2_normalized = (2*f2/Fs2)*2*pi;
h5_2_normalized = (2*f2/Fs2)*2*pi;
%end of 4.b

%4c
%1η νοτα
%1η αρμονικη
poles_1st_h=[0.990+0.137i; 0.990+0.137i; 0.990-0.137i; 0.990-0.137i];
zeros_1st_h=[0.994; 0.994i; -0.994; -0.994i]; 
[b_1st_h,a_1st_h] = zp2tf(zeros_1st_h,poles_1st_h,10^-7);
y_1_h = filter(b_1st_h,a_1st_h,mix);
%2η αρμονικη
poles_2nd_h = [0.962+0.271i; 0.962+0.271i; 0.962-0.271i; 0.962-0.271i];
zeros_2nd_h = [0.994; 0.994i; -0.994; -0.994i];
[b_2nd_h , a_2nd_h] = zp2tf(zeros_2nd_h , poles_2nd_h , 10^-7);
y_2_h = filter(b_2nd_h , a_2nd_h , mix);
%3η αρμονικη
poles_3nd_h = [0.916+0.400i; 0.916+0.400i; 0.916-0.400i; 0.916-0.400i];
zeros_3nd_h = [0.994; 0.994i; -0.994; -0.994i];
[b_3nd_h , a_3nd_h] = zp2tf(zeros_3nd_h , poles_3nd_h , 10^-7);
y_3_h = filter(b_3nd_h , a_3nd_h , mix);
%4η αρμονική
poles_4nd_h = [0.852+0.522i; 0.852+0.522i; 0.852-0.522i; 0.852-0.522i];
zeros_4nd_h = [0.994; 0.994i; -0.994; -0.994i];
[b_4nd_h , a_4nd_h] = zp2tf(zeros_4nd_h , poles_4nd_h , 10^-7);
y_4_h = filter(b_4nd_h , a_4nd_h , mix);
%5η αρμονική 
poles_5nd_h = [0.770+0.637i; 0.770+0.637i; 0.770-0.637i; 0.770-0.637i];
zeros_5nd_h = [0.994; 0.994i; -0.994; -0.994i];
[b_5nd_h , a_5nd_h] = zp2tf(zeros_5nd_h , poles_5nd_h , 10^-7);
y_5_h = filter(b_5nd_h , a_5nd_h , mix);

first_note = y_1_h + y_2_h + y_3_h + y_4_h + y_5_h;
fft_first_note = fftshift(fft(first_note));
t = linspace(0 , Fs2 , length(first_note));
figure(44);
plot(linspace(-Fs2/2 , Fs2/2 , length(fft_first_note)) , abs(fft_first_note));
title("FFT of first note");
xlabel("Freq(Hz)");

%2η νότα

%1η αρμονική
%κουράστηκα να γράφω διαφορετικά ονόματα για κάθε p,z και εχω και carpal
%tunnel
p=[0.9962+0.0862i; 0.9962+0.0862i; 0.9962-0.0862i; 0.9962-0.0862i];
z=[0.9162; 0.9162i; -0.9162; -0.9162i];
[b_1st_2nd,a_1st_2nd] = zp2tf(z,p,10^-8.6);
y_1_2nd = filter(b_1st_2nd,a_1st_2nd,mix);   
%2η αρμονικη
p=[0.985+0.171i; 0.985+0.171i; 0.985-0.171i; 0.985-0.171i];
z=[0.9162; 0.9162i; -0.9162; -0.9162i];
[b_2nd_2nd , a_2nd_2nd] = zp2tf(z , p, 10^-7);
y_2_2nd = filter(b_2nd_2nd , a_2nd_2nd , mix);
%3η αρμονικη
p=[0.966+0.256i; 0.966+0.256i; 0.966-0.256i; 0.966-0.256i];
z=[0.9162; 0.9162i; -0.9162; -0.9162i];
[b_3nd_2nd , a_3nd_2nd] = zp2tf(z , p , 10^-6.7);
y_3_2nd = filter(b_3nd_2nd , a_3nd_2nd , mix);
%4η αρμονικη
p=[0.940+0.338i; 0.940+0.338i; 0.940-0.338i; 0.940-0.338i];
z=[0.9162; 0.9162i; -0.9162; -0.9162i];
[b_4nd_2nd , a_4nd_2nd] = zp2tf(z,p,10^-6.5);
y_4_2nd = filter(b_4nd_2nd , a_4nd_2nd , mix);
%5η αρμονική 
p=[0.908+0.418i; 0.908+0.418i; 0.908-0.418i;  0.908-0.418i];
z=[0.9162; 0.9162i; -0.9162; -0.9162i];
[b_5nd_2nd , a_5nd_2nd] = zp2tf(z,p , 10^-6.4);
y_5_2nd = filter(b_5nd_2nd ,a_5nd_2nd , mix);
%end of 4c

%με την ίδια λογική
second_note = y_1_2nd + y_2_2nd + y_3_2nd + y_4_2nd + y_5_2nd;
figure(45);
second_note_fft = fftshift(fft(second_note));
Fs = 16000;
plot(linspace(-Fs2/2 , Fs2/2 , length(second_note_fft)), abs(second_note_fft));
title("FFT of second note");
xlabel("Freq(Hz)");

%4.d
flute_sound = audioread("audios/flute_acoustic_002-069-025.wav");
reed_sound = audioread("audios/reed_acoustic_037-065-075.wav");
flute_fft = fftshift(fft(flute_sound));
reed_fft = fftshift(fft(reed_sound));

figure(46);
plot(linspace(-8000,8000,length(flute_fft)), abs(flute_fft));
title("DFT of flute");
xlabel("Freq(Hz)");
figure(47);
plot(linspace(-8000 , 8000, length(reed_fft)) , abs(reed_fft));
title("DFT of reed");
xlabel("Freq(Hz)");


mix2 = audioread("audios/mixture2.wav");
Fs = 16000;
mix2_fft = fftshift(fft(mix2));
figure(48);
plot(linspace(-8000 , 8000, length(mix2_fft)), abs(mix2_fft));
title("DFT of mixed notes");
xlabel("Freq(Hz)");

%ελεγχός ήχου
%πρώτη νότα και reed
sound(first_note);
sound(reed_sound);
%δεύτερη νότα και flute
sound(second_note);
sound(flute_sound);



%βασική συχνότητα των 2 νότων
f1 = 440;
f2 = 220;

h2_1 = 2*f1;
h3_1 = 3*f1;
h4_1 = 4*f1;
h5_1 = 5*f1;
%για την 2η νοτα
h2_2 = 2*f2;
h3_2 = 3*f2;
h4_2 = 4*f2;
h5_2 = 5*f2;

%για τις κανονικοποιημένες συχνότητες της πρώτης νότας
%στα παρακάτω hi_j -> i-στη αρμονική της j-οστης νότας
%h1_1_normalized = (f1 / Fs2) *2*pi;
%h2_1_normalized = (2*f1/Fs2)*2*pi;
%h3_1_normalized = (3*f1/Fs2)*2*pi;
%h4_1_normalized = (4*f1/Fs2)*2*pi;
%h5_1_normalized = (5*f1/Fs2)*2*pi;
%%για τις κανονικοποιημένες συχνότητες της 2ης νότας
%h1_2_normalized = (2*f2/Fs2)*2*pi;
%h2_2_normalized = (2*f2/Fs2)*2*pi;
%h3_2_normalized = (2*f2/Fs2)*2*pi;
%h4_2_normalized = (2*f2/Fs2)*2*pi;
%h5_2_normalized = (2*f2/Fs2)*2*pi;

%1h νοτα
%1η αρμονική
poles_1st_2nd=[0.985+0.1719i; 0.985+0.1719i; 0.985-0.1719i; 0.985-0.1719i];
zeros_1st_2nd=[0.994; 0.994i; -0.994; -0.994i]; 
[b_1st_2nd,a_1st_2nd] = zp2tf(zeros_1st_2nd,poles_1st_2nd,10^-7);
y_1_h = filter(b_1st_2nd,a_1st_2nd,mix2);   
%2η αρμονικη
poles_2nd_2nd = [0.940+0.338i; 0.940+0.338i; 0.940-0.338i; 0.940-0.338i];
zeros_2nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_2nd_2nd , a_2nd_2nd] = zp2tf(zeros_2nd_2nd , poles_2nd_2nd , 10^-7);
y_2_h = filter(b_2nd_2nd , a_2nd_2nd , mix2);
%3η αρμονικη
poles_3nd_2nd = [0.868+0.495i; 0.868+0.495i; 0.868-0.495i; 0.868-0.495i];
zeros_3nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_3nd_2nd , a_3nd_2nd] = zp2tf(zeros_3nd_2nd , poles_3nd_2nd , 10^-7);
y_3_h = filter(b_3nd_2nd , a_3nd_2nd , mix2);
%4η αρμονικη
poles_4nd_2nd = [0.770+0.637i; 0.770+0.637i; 0.770-0.637i; 0.770-0.637i];
zeros_4nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_4nd_2nd , a_4nd_2nd] = zp2tf(zeros_4nd_2nd , poles_4nd_2nd , 10^-7);
y_4_h = filter(b_4nd_2nd , a_4nd_2nd , mix2);
%5η αρμονική 
poles_5nd_2nd = [0.649+0.760i; 0.649+0.760i; 0.649-0.760i; 0.649-0.760i];
zeros_5nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_5nd_2nd , a_5nd_2nd] = zp2tf(zeros_5nd_2nd , poles_5nd_2nd , 10^-7);
y_5_h = filter(b_5nd_2nd ,a_5nd_2nd , mix2);


first_note = y_1_h + y_2_h + y_3_h + y_4_h + y_5_h;
fft_first_note = fftshift(fft(first_note));
t = linspace(0 , Fs2 , length(first_note));
figure(49);
plot(linspace(0 , Fs2 , length(fft_first_note)) , abs(fft_first_note));
title("FFT of first note");
xlabel("Freq(Hz)");


%2h νοτα
%1η αρμονική
poles_1st_2nd=[0.9962+0.0862i; 0.9962+0.0862i; 0.9962-0.0862i; 0.9962-0.0862i];
zeros_1st_2nd=[0.994; 0.994i; -0.994; -0.994i]; 
[b_1st_2nd,a_1st_2nd] = zp2tf(zeros_1st_2nd,poles_1st_2nd,10^-7);
y_1_2nd = filter(b_1st_2nd,a_1st_2nd,mix2);   
%2η αρμονικη
poles_2nd_2nd = [0.985+0.171i; 0.985+0.171i; 0.985-0.171i; 0.985-0.171i];
zeros_2nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_2nd_2nd , a_2nd_2nd] = zp2tf(zeros_2nd_2nd , poles_2nd_2nd , 10^-7);
y_2_2nd = filter(b_2nd_2nd , a_2nd_2nd , mix2);
%3η αρμονικη
poles_3nd_2nd = [0.966+0.256i; 0.966+0.256i; 0.966-0.256i; 0.966-0.256i];
zeros_3nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_3nd_2nd , a_3nd_2nd] = zp2tf(zeros_3nd_2nd , poles_3nd_2nd , 10^-7);
y_3_2nd = filter(b_3nd_2nd , a_3nd_2nd , mix2);
%4η αρμονικη
poles_4nd_2nd = [0.940+0.338i; 0.940+0.338i; 0.940-0.338i; 0.940-0.338i];
zeros_4nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_4nd_2nd , a_4nd_2nd] = zp2tf(zeros_4nd_2nd , poles_4nd_2nd , 10^-7);
y_4_2nd = filter(b_4nd_2nd , a_4nd_2nd , mix2);
%5η αρμονική 
poles_5nd_2nd = [0.908+0.418i; 0.908+0.418i; 0.908-0.418i;  0.908-0.418i];
zeros_5nd_2nd = [0.994; 0.994i; -0.994; -0.994i];
[b_5nd_2nd , a_5nd_2nd] = zp2tf(zeros_5nd_2nd , poles_5nd_2nd , 10^-7);
y_5_2nd = filter(b_5nd_2nd ,a_5nd_2nd , mix2);

n_second_note = y_1_2nd + y_2_2nd + y_3_2nd + y_4_2nd + y_5_2nd;
n_second_note_f = fftshift(fft(n_second_note));
t = linspace(-Fs/2, Fs/2,length(n_second_note));
figure(50);
plot(t,abs(n_second_note_f));
title("DFT of second note");
xlabel("Frequency(Hz)");

%ελεγχός ήχου
%πρώτη νότα και reed
sound(first_note);
sound(reed_sound);
%δεύτερη νότα και flute
sound(n_second_note);
sound(flute_sound);
%βασική συχνότητα των 2 νότων


%Τέλος Άσκησης 4






function [z_complex] = fourier(N, M, n, z) %function that calculates dft of a complex signal Z
    z_complex = 0;
    for k = 1:M+1 
        z_complex = z_complex + (1/N)*(z(k)*exp(1i*2*pi*(k-1)*n/N));
    end
end

function [I] = reconstruct(x, y) %function to reconstruct the real and imaginary values of the DSE
    %I_r = zeros(length(x), length(y));
    for i = 1:length(x)
            d = x(i);
            e = y(i);
            I(d+1, e+1) = 1;
    end 
end

function [z_complex] = fourier_log(N , M , n , z)
    z_complex = 0;
    K = N - (M/2);
    for i = K:(N-1)
        z_complex = z_complex + (1/N)*(z(i+1)*exp(1i*2*pi*i*n/N));
    end
end


%same approach , it didn't work tho :(
function [reconstructedImage] = reconstructImage(M , z)
%RECONSTRUCTIMAGE Reconstruct an image using the first M+1 coefficients of its DFT
%   Inputs:
%       z:  Complex signal representing the image
%       M:  Number of coefficients to use in reconstruction
%   Output:
%       reconstructedImage:  Reconstructed image using the first M+1 coefficients of the DFT of z

w = length(z);
reconstructedImage = zeros(w,1);

for n = 0:w-1
    for k = 0:M
        reconstructedImage(n+1) = reconstructedImage(n+1) + (1/w)*(z(k+1)*exp(1i*2*pi*k*n/w));
    end
end

end

function [f] = filtered_harmonnic(p,z,signal,k)
    [b,a] = zp2tf(z,p,k);
    y = filter(b,a,signal);
    f = y;
end
