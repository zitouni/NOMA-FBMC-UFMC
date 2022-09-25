function PrototypeFilter = PrototypeFilter_Hermite(T0,dt,OF)
            % The pulse is orthogonal for a time-spacing of T=T_0 and a frequency-spacing of F=2/T_0
            t_filter=-(OF*T0):dt:(OF*T0-dt);
            D0=1/sqrt(T0)*HermiteH(0,sqrt(2*pi)*(t_filter./(T0/sqrt(2))))  .*exp(-pi*(t_filter./(T0/sqrt(2))).^2);
            D4=1/sqrt(T0)*HermiteH(4,sqrt(2*pi)*(t_filter./(T0/sqrt(2))))  .*exp(-pi*(t_filter./(T0/sqrt(2))).^2);
            D8=1/sqrt(T0)*HermiteH(8,sqrt(2*pi)*(t_filter./(T0/sqrt(2))))  .*exp(-pi*(t_filter./(T0/sqrt(2))).^2);
            D12=1/sqrt(T0)*HermiteH(12,sqrt(2*pi)*(t_filter./(T0/sqrt(2)))).*exp(-pi*(t_filter./(T0/sqrt(2))).^2);
            D16=1/sqrt(T0)*HermiteH(16,sqrt(2*pi)*(t_filter./(T0/sqrt(2)))).*exp(-pi*(t_filter./(T0/sqrt(2))).^2);
            D20=1/sqrt(T0)*HermiteH(20,sqrt(2*pi)*(t_filter./(T0/sqrt(2)))).*exp(-pi*(t_filter./(T0/sqrt(2))).^2);
            H0= 1.412692577;
            H4= -3.0145e-3;
            H8=-8.8041e-6;
            H12=-2.2611e-9;
            H16=-4.4570e-15;
            H20 = 1.8633e-16;
            PrototypeFilter=(D0.*H0+D4.*H4+D8.*H8+D12.*H12+D16.*H16+D20.*H20).';
            PrototypeFilter = PrototypeFilter/sqrt(sum(abs(PrototypeFilter).^2)*dt);       
end

function Hermite = HermiteH(n,x)
    if n==0
        Hermite=ones(size(x));
    elseif n==4
        Hermite=12+(-48).*x.^2+16.*x.^4;
    elseif n==8
        Hermite = 1680+(-13440).*x.^2+13440.*x.^4+(-3584).*x.^6+256.*x.^8;
    elseif n==12
        Hermite = 665280+(-7983360).*x.^2+13305600.*x.^4+(-7096320).*x.^6+1520640.* ...
                  x.^8+(-135168).*x.^10+4096.*x.^12;
    elseif n==16
        Hermite = 518918400+(-8302694400).*x.^2+19372953600.*x.^4+(-15498362880).* ...
                  x.^6+5535129600.*x.^8+(-984023040).*x.^10+89456640.*x.^12+( ...
                  -3932160).*x.^14+65536.*x.^16;
    elseif n==20
        Hermite = 670442572800+(-13408851456000).*x.^2+40226554368000.*x.^4+( ...
                  -42908324659200).*x.^6+21454162329600.*x.^8+(-5721109954560).* ...
                  x.^10+866834841600.*x.^12+(-76205260800).*x.^14+3810263040.*x.^16+ ...
                  (-99614720).*x.^18+1048576.*x.^20;
    end
end     