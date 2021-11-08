%%%%%%%%% PENDULO RESORTE - MET3
Lo  = 0.5;
g   = 9.81;
ksm = 98.1;
MP = [Lo,g,ksm]; %%% Matriz de parámetros
[ur0, vr0, ua0, va0] = deal(0.25, 0, pi/2, 0); %% Valores iniciales
%
function [res] = ar(MP,ur,ua,va)
  Lo  = MP(1);
  g   = MP(2);
  ksm = MP(3);
  res = (Lo+ur)*va^2 +g*cos(ua) -ksm*ur;
endfunction
%
function [res] = aa(MP,ur,vr,ua,va)
  Lo  = MP(1);
  g   = MP(2);
  res = -(2*vr*va +g*sin(ua))/(Lo+ur);
endfunction
%
Dt = 0.1;
tmax = 50;
rango = 0:Dt:tmax;
%
ur=[ur0];
vr=[vr0];
ua=[ua0];
va=[va0];
%
for i = rango
  ar0 = ar(MP,ur0,ua0,va0);     %%%
  aa0 = aa(MP,ur0,vr0,ua0,va0); %%%
  %
  ur1 = ur0 + 1/3*Dt*vr0 + 1/18*Dt^2*ar0; %%%
  ua1 = ua0 + 1/3*Dt*va0 + 1/18*Dt^2*aa0; %%%
  vr1 = vr0 + 1/3*Dt*ar0; %%%
  va1 = va0 + 1/3*Dt*aa0; %%%
  ar1 = ar(MP,ur1,ua1,va1); %%%
  aa1 = aa(MP,ur1,vr1,ua1,va1); %%%
  %%%
  ur2 = ur0 + 2/3*Dt*vr0 + 1/27*Dt^2*(2*ar0 + 4*ar1);
  ua2 = ua0 + 2/3*Dt*va0 + 1/27*Dt^2*(2*aa0 + 4*aa1);
  vr2 = vr0 + 2/3*Dt*ar1;
  va2 = va0 + 2/3*Dt*aa1;
  ar2 = ar(MP,ur2,ua2,va2);
  aa2 = aa(MP,ur2,vr2,ua2,va2);
  %
  ur3 = ur0 + Dt*vr0 + 1/6*Dt^2*(ar0 + ar1 + ar2);
  ua3 = ua0 + Dt*va0 + 1/6*Dt^2*(aa0 + aa1 + aa2);
  vr3 = vr0 + 1/4*Dt*(ar0 + 3*ar2);
  va3 = va0 + 1/4*Dt*(aa0 + 3*aa2);
%
   ur=[ur,ur3]; 
   vr=[vr,vr3];
   ua=[ua,ua3]; 
   va=[va,va3];
%
  ur0=ur3;
  ua0=ua3;
  vr0=vr3;
  va0=va3;
endfor
plot(ua)
%plot(ur.*sin(ua),ur.*cos(ua))