function f=MPMOP_Value(probID, x, t)
% INPUT:
%       probID: test problem identifier (i.e. 'DF1')
%       x:      variable vector
%
% OUTPUT:
%       f:      objective vector
%

[~,n]=size(x); % number of variables
switch (probID)
    case 'MPMOP1'
        a=5*cos(0.5*pi*t);
        tmp=1./(1+exp(a*(x(:,1)-2.5)));
        g=1+sum((x(:,2:end)-tmp).^2,2);
        f(:,1)=g*(1+t)./x(:,1);
        f(:,2)=g.*x(:,1)/(1+t);
        
    case 'MPMOP2'
        G=sin(0.5*pi*t);
        a=2.25+2*cos(2*pi*t);
        tmp=G*sin(4*pi*x(:,1))./(1+abs(G));
        g=1+sum((x(:,2:end)-tmp).^2,2);
        f(:,1)=g.*(x(:,1)+0.1*sin(3*pi*x(:,1)));
        f(:,2)=g.*(1-x(:,1)+0.1*sin(3*pi*x(:,1))).^a;
        
    case 'MPMOP3'
        N=1+floor(10*abs(sin(0.5*pi*t)));
        g=1;
        for i=2:n
            tmp=x(:,i)-cos(4*t+x(:,1)+x(:,i-1));
            g=g+tmp.^2;
        end
        f(:,1)=g.*(x(:,1)+max(0, (0.1+0.5/N)*sin(2*N*pi*x(:,1))));
        f(:,2)=g.*(1-x(:,1)+max(0, (0.1+0.5/N)*sin(2*N*pi*x(:,1)))); 
        
    case 'MPMOP4'
        G=sin(0.5*pi*t);
        H=2.25+2*cos(0.5*pi*t);
        tmp=sin(2*pi*(x(:,1)+x(:,2)))/(1+abs(G));
        g=1+sum((x(:,3:end)-tmp).^2,2);
        f(:,1)=g.*sin(0.5*pi*x(:,1)).^H;
        f(:,2)=g.*sin(0.5*pi*x(:,2)).^H.*cos(0.5*pi*x(:,1)).^H;
        f(:,3)=g.*cos(0.5*pi*x(:,2)).^H.*cos(0.5*pi*x(:,1)).^H;
    case 'MPMOP5'
        G=abs(sin(0.5*pi*t));
        g=1+sum((x(:,3:end)-0.5*G*x(:,1)).^2,2);
        y=pi*G/6+(pi/2-pi*G/3)*x(:,1:2);
        f(:,1)=g.*sin(y(:,1));
        f(:,2)=g.*sin(y(:,2)).*cos(y(:,1));
        f(:,3)=g.*cos(y(:,2)).*cos(y(:,1));

    case 'MPMOP6'
        k=floor(10*sin(pi*t));
        r=1-mod(k,2);
        tmp1=x(:,3:end)-sin(t*x(:,1));
        tmp2=abs(sin(floor(k*(2*x(:,1:2)-r))*pi/2));
        g=1+sum(tmp1.^2,2)+prod(tmp2,2);
        f(:,1)=g.*cos(0.5*pi*x(:,2)).*cos(0.5*pi*x(:,1));
        f(:,2)=g.*sin(0.5*pi*x(:,2)).*cos(0.5*pi*x(:,1));
        f(:,3)=g.*sin(0.5*pi*x(:,1));
    case 'MPMOP12'
        % Two-objective, two-party; different g minima (c=0 vs c=1) -> no common PS
        c = (t<0.5);
        if n>=2
            g = 1+sum((x(:,2:end)-c).^2,2);
        else
            g = 1;
        end
        f(:,1) = g.*x(:,1);
        f(:,2) = g.*(1-x(:,1));
    case 'MPMOP13'
        % Variant with shifted first variable to avoid accidental overlap at boundaries
        c = (t<0.5)*0 + (t>=0.5)*1;
        if n>=2
            g = 1+sum((x(:,2:end)-c).^2,2);
        else
            g = 1;
        end
        x1 = 0.2 + 0.6*x(:,1);
        f(:,1) = g.*x1;
        f(:,2) = g.*(1-x1);
    case 'MPMOP14'
        % Three-objective, two-party; different g minima (c=0 vs c=1) -> no common PS
        c = (t<0.5);
        if n>=3
            g = 1+sum((x(:,3:end)-c).^2,2);
        else
            g = 1;
        end
        f(:,1)=g.*cos(0.5*pi*x(:,2)).*cos(0.5*pi*x(:,1));
        f(:,2)=g.*sin(0.5*pi*x(:,2)).*cos(0.5*pi*x(:,1));
        f(:,3)=g.*sin(0.5*pi*x(:,1));
    case 'MPMOP15'
        % Three-objective variant with distinct constants (c=0.25 vs c=0.75)
        c = 0.25 + 0.5*(t>=0.5);
        if n>=3
            g = 1+sum((x(:,3:end)-c).^2,2);
        else
            g = 1;
        end
        f(:,1)=g.*cos(0.5*pi*x(:,2)).*cos(0.5*pi*x(:,1));
        f(:,2)=g.*sin(0.5*pi*x(:,2)).*cos(0.5*pi*x(:,1));
        f(:,3)=g.*sin(0.5*pi*x(:,1));
    case 'MPMOP16'
        % Two-objective, two-party; distinct g minima (c=0.25 vs c=0.75) -> no common PS
        c = (t<0.5)*0.25 + (t>=0.5)*0.75;
        if n>=2
            g = 1+sum((x(:,2:end)-c).^2,2);
        else
            g = 1;
        end
        f(:,1) = g.*x(:,1);
        f(:,2) = g.*(1-x(:,1));

    case 'MPMOP17'
        % Two-objective per party, three-party; distinct g minima (c=0.0 vs c=0.5 vs c=1.0)
        % t in {0.0, 0.5, 1.0} selects c accordingly
        if t<=0.25
            c = 0.0;
        elseif t<0.75
            c = 0.5;
        else
            c = 1.0;
        end
        if n>=2
            g = 1+sum((x(:,2:end)-c).^2,2);
        else
            g = 1;
        end
        f(:,1) = g.*x(:,1);
        f(:,2) = g.*(1-x(:,1));
    otherwise
        disp('no such test problem.')
end
end
