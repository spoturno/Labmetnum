u0 = 1.5;
v0 = 0;
T = 0.15153;
Dt = T/32;
tmax = 50*T;
%
u=[u0];
v=[v0];
a=[];
%
% PARAMETROS
met = 3; %EL ORDEN DEL METODO%
if (met == 3)
  t1 = 1/3;
  t2 = 2/3;
  t3 = 1;
  a11 = 1;
  a21 = -2/3;
  a22 =  2/3;
  a31 =  1/3;
  a32 = -2/3;
  a33 =  1/3;
  a41 = 0;
  a42 = 0;
  a43 = 0;
  a44 = 0;
elseif (met == 4)
  t1 = 1/3;
  t2 = 1/2;
  t3 = 1;
  a11 = 1;
  a21 = -3/5;
  a22 =  3/5;
  a31 =  3/5;
  a32 = -3/5;
  a33 = 0;
  a41 = 0;
  a42 = 0;
  a43 = 0;
  a44 = 0;
endif
% INTERPOLANTES
f12 = t1;
f22 = t2*(2*t1 - t2)/(2*t1);
f23 = t2^2/(2*t1);
f32 = t3*(2*t3^2 -3*t1*t3 -3*t2*t3 + 6*t1*t2)/(6*t1*t2);
f33 = t3^2*(2*t3-3*t2)/(6*t1*(t1-t2));
f34 = t3^2*(3*t1-2*t3)/(6*t2*(t1-t2));
f42 = 1 - (3 -4*(t1+t2+t3) + 6*(t1*t2 +t2*t3 +t3*t1))/(12*t1*t2*t3);
f43 = (3-4*t2 -4*t3 +6*t2*t3)/(12*t1*(-t1*t2 +t2*t3 -t3*t1 +t1^2));
f44 = (3-4*t1 -4*t3 +6*t1*t3)/(12*t2*(-t1*t2 -t2*t3 +t3*t1 +t2^2));
f45 = (3-4*t1 -4*t2 +6*t1*t2)/(12*t3*( t1*t2 -t2*t3 -t3*t1 +t3^2));
% MAS PROLIJO
u2v0 = (f22 + f23);
u2a0 = (f12*f23/t2^2 + a21/2);
u3v0 = (f32 + f33 + f34);
u3a0 = ((f12*f33 + f22*f34)/t3^2 + a31/2);
u3a1 = ((f23*f34/t3^2) + a32/2);
u4v0 = (f42 + f43 + f44 + f45);
u4a0 = (f12*f43 + f22*f44 + f32*f45) + a41/2;
u4a1 = (f23*f44 + f33*f45) + a42/2;
u4a2 = (f34*f45) + a43/2;
%
for i = 0:Dt:tmax
a0 = %DIFERENCIAL EN 0%
%
u1 = u0 +  f12*Dt*v0 + (t1*Dt)^2*(a11/2)*a0; %% HERMOSO
v1 = v0 +  f12*Dt*a0; %% HERMOSO
a1 = %DIFERENCIAL EN 1%
%
u2 = u0 + u2v0*Dt*v0 + (t2*Dt)^2*(u2a0*a0 + a22/2*a1); %% HERMOSO
v2 = v0 +  f22*Dt*a0 + f23*Dt*a1; %% HERMOSO
a2 = %DIFERENCIAL EN 2%
%
u3 = u0 + u3v0*Dt*v0 + (t3*Dt)^2*(u3a0*a0 + u3a1*a1 + a33/2*a2); %% HERMOSO
v3 = v0 +  f32*Dt*a0 + f33*Dt*a1 + f34*Dt*a2; %% HERMOSO
% HASTA ACA VA EL TRES CUANDO MET = 3
a3 = %DIFERENCIAL EN 3%
%
u4 = u0 + u4v0*Dt*v0 + Dt^2*(u4a0*a0 + u4a1*a1 + u4a2*a2 + a44/2*a3);
v4 = v0 +  f42*Dt*a0 + f43*Dt*a1 + f44*Dt*a2 + f45*Dt*a3;
%
  u=[u,u3];
  v=[v,v3];
  a=[a,a0];
u0=u3;
v0=v3;
endfor

plot(u, v);