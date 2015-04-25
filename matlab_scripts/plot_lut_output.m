% Read data from file
file_cos = fopen('c:\Users\murai\Documents\vik_bme_msc\logikai_tervezes\hazi_feladat\qam\\cos_output.txt','r');
file_sin = fopen('c:\Users\murai\Documents\vik_bme_msc\logikai_tervezes\hazi_feladat\qam\\sin_output.txt','r');
file_p_1 = fopen('c:\Users\murai\Documents\vik_bme_msc\logikai_tervezes\hazi_feladat\qam\\parallel_1.txt','r');
file_p_0 = fopen('c:\Users\murai\Documents\vik_bme_msc\logikai_tervezes\hazi_feladat\qam\\parallel_0.txt','r');

cos_lut = fscanf(file_cos,'%s');
sin_lut = fscanf(file_sin,'%s');
parallel_1 = fscanf(file_p_1,'%s');
parallel_0 = fscanf(file_p_0,'%s');

 cos_a(1:(length(cos_lut)/16),1:16) = 0;
 sin_a(1:(length(sin_lut)/16),1:16) = 0;

% Binary to decimal conversion
j = 1;
for i = (1:16:length(cos_lut))
    for k = 1:16
        cos_a(j,k) = str2num(cos_lut(i+k-1));    
        sin_a(j,k) = str2num(sin_lut(i+k-1));
    end
    j = j + 1;
end

parallel_1_a(1:length(parallel_1))=0;
parallel_0_a(1:length(parallel_0))=0;


for i=(1:length(parallel_1))
    parallel_1_a(i)=str2num(parallel_1(i));
    parallel_0_a(i)=str2num(parallel_0(i));
end

cos_dec(1:length(cos_a)) = 0;
sin_dec(1:length(sin_a)) = 0;
neg_c = 0;
neg_s = 0;
carry_c = 0;
carry_s = 0;


 for i = (1:length(cos_a))
     if(cos_a(i,1) == 1)
         for(k = 16:-1:1)
            if(k == 16) cos_a(i,k) = cos_a(i,k) - 1;
            end
            cos_a(i,k) = cos_a(i,k) - carry_c;
            if(cos_a(i,k) < 0)
                cos_a(i,k) = 1;
                carry_c = 1;
            else carry_c = 0;
            end
         end
         for(k = 1:16) 
             cos_a(i,k) = ~cos_a(i,k);
         end
         neg_c = 1;
     else neg_c = 0;
     end
     if(sin_a(i,1) == 1)
         for(k = 16:-1:1)
            if(k == 16) sin_a(i,k) = sin_a(i,k) - 1;
            end
            sin_a(i,k) = sin_a(i,k) - carry_s;
            if(sin_a(i,k) < 0)
                sin_a(i,k) = 1;
                carry_s = 1;
            else carry_s = 0;
            end
         end
         for(k = 1:16) 
              sin_a(i,k) = ~sin_a(i,k);
         end
         neg_s = 1;
     else neg_s = 0;
     end
     for j = (2:16)
         cos_dec(i) = cos_dec(i) + cos_a(i,j)*(1/(2^(j-1)));
         sin_dec(i) = sin_dec(i) + sin_a(i,j)*(1/(2^(j-1)));
     end
     if (neg_c == 1) cos_dec(i) = cos_dec(i) * - 1;
     end
     if (neg_s == 1) sin_dec(i) = sin_dec(i) * - 1;
     end
 end
 
 % Plot the modulated signals
 t = 1:19990;
 
 figure(1);
 plot(t,cos_dec,t,parallel_0_a);
 axis([0 20000 -1.1 1.1])
 
 figure(2);
 plot(t,sin_dec,t,parallel_1_a);
 axis([0 20000 -1.1 1.1])
 
 figure(3);
 plot(t,cos_dec+sin_dec);
 axis([0 20000 -1.8 1.8])