function [val, rate] = smcSeekatUNO(ico, voltage, rate)
% driver for Seekat (Arduino UNO)
% hacked together on 2017-06-29 by Elena Lazareva:

global smdata;


switch ico(2)
    case {1,2,3,4,5,6,7,8}	% set channel
        switch ico(3)
            case 1 % set voltage
                
                if voltage > 10
                    voltage = 10.0;
                elseif voltage < -10
                    voltage = -10.0;
                end
                
                switch ico(2)
                    case 1
                        n1 = 19;
                        n2=0;
                        m1=1;
                        m2=0;
                    case 2
                        n1 = 18;
                        n2=0;
                        m1=1;
                        m2=0;
                    case 3
                        n1 = 17;
                        n2=0;
                        m1=1;
                        m2=0;
                    case 4
                        n1 = 16;
                        n2=0;
                        m1=1;
                        m2=0;
                    case 5
                        n1 = 0;
                        n2=19;
                        m1=0;
                        m2=1;
                    case 6
                        n1 = 0;
                        n2=18;
                        m1=0;
                        m2=1;
                    case 7
                        n1 = 0;
                        n2=17;
                        m1=0;
                        m2=1;
                    case 8
                        n1 = 0;
                        n2=16;
                        m1=0;
                        m2=1;
                end
                if voltage >= 0
                    dec16 = round((2^15-1)*voltage/10); %Decimal equivalent of 16 bit data
                else
                    dec16 = round(2^16 - abs(voltage)/10 * 2^15); %Decimal equivalent of 16 bit data
                end
                bin16 = de2bi(dec16,16,2,'left-msb'); %16 bit binary
                d1=bi2de(fliplr(bin16(1:8))); %first 8 bits
                d2=bi2de(fliplr(bin16(9:16))); %second 8 bits
                % disp([255,254,253,n1,d1*m1,d2*m1,n2,d1*m2,d2*m2]); %uncomment to check what�s being sent to the Arduino
                pause(.005);
                fwrite(smdata.inst(ico(1)).data.inst,[255,254,253,n1,d1*m1,d2*m1,n2,d1*m2,d2*m2]);
                while smdata.inst(ico(1)).data.inst.BytesAvailable
                    fscanf(smdata.inst(ico(1)).data.inst,'%e');
                end
            otherwise %unable to read the voltage
                error('Operation not supported');
        end
    otherwise
        %error('Operation not supported');
        error(['Channel ', num2str(ico(2)) ,' is not available']);
end
