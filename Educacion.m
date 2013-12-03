clear;
clc;
close all;
disp("Linear Regression with one variable......Gradient Descent");
Egresados = csvread("C:/Users/guillermo/Documents/Programas Octave/cuadro-7-egresados-2001-2011.csv");
Estudiantes = csvread("C:/Users/guillermo/Documents/Programas Octave/cuadro-5-estudiantes-2001-2011.csv");
NInscriptos = csvread("C:/Users/guillermo/Documents/Programas Octave/cuadro-6-nuevos-inscriptos-2001-2011.csv");
Egresados=Egresados';
Egresados=[Egresados(2:12,1) Egresados(2:12,2) Egresados(2:12,3) Egresados(2:12,4)];
Estudiantes = Estudiantes';
Estudiantes=[Estudiantes(2:12,1) Estudiantes(2:12,2) Estudiantes(2:12,3) Estudiantes(2:12,4)];
NInscriptos = NInscriptos';
NInscriptos=[NInscriptos(2:12,1) NInscriptos(2:12,2) NInscriptos(2:12,3) NInscriptos(2:12,4)];
Totales =[Egresados(:,1)-2000 NInscriptos(:,4) Estudiantes(:,4) Egresados(:,4)]

#Estatal =[Egresados(:,1) NInscriptos(:,2) Estudiantes(:,2) Egresados(:,2)]
#figure(2);
#plot(Estatal(:,1),Estatal(:,2),'.',Estatal(:,1),Estatal(:,3),'.',Estatal(:,1),Estatal(:,4),'.')
#title("Estatal");
#xlabel("Periodo");
#ylabel("Cant. Alumnos");
#Privado =[Egresados(:,1) NInscriptos(:,3) Estudiantes(:,3) Egresados(:,3)]
#figure(3);
#plot(Privado(:,1),Privado(:,2),'.',Privado(:,1),Privado(:,3),'.',Privado(:,1),Privado(:,4),'.')
#title("Privados");
#xlabel("Periodo");
#ylabel("Cant. Alumnos");







% MSE = sum{[y-f(x)]^2}
function result = mse(y, x, a, c)
    result = 0;
    for i=1:size(x, 2)  % could be done with matrices, but I prefer to be clear
    #    result = result + (y(i) - (a * x(i)^2 + c))^2;
        result = result + (y(i) - (a * x(i) + c))^2;
    end
    result = result / size(x, 2);
end




% MSE derivative with respect to a: sum{2[y-f(x)]*(-2x)}
function d = a_direction_component(y, x, a, c)
#    d = sum(2*(y - a * (x .^ 2) - c) .* (-2 * x .^ 2));
    d = sum(2*(y - a * x - c) .* (-2 * x ));
end



% MSE derivative with respect to c: sum{2[y-f(x)]*(-1)}
function d = c_direction_component(y, x, a, c)
#    d = sum(2*(y - a * x .^ 2 - c) .* (-1));
    d = sum(2*(y - a * x  - c) .* (-1));
end



function Aprender = Learn(x,y)
% initialization
a = 0;
c = 0;
step = 0.0001;
mse(y, x, a, c)


for i=1:5000
#    sprintf("Iteration %d", i)
    gradient = [a_direction_component(y, x, a, c) c_direction_component(y, x, a, c)];
    a = a - step * gradient(1);
    c = c - step * gradient(2);
#    sprintf("Model learned: y = %f.2 * x^2 + %f.2", a, c)
    current_mse = mse(y, x, a, c);
end
#figure(1)
#plot(x+2000,y,'.',x+2000,(a*x+c))
sprintf("Model learned: y = %f * x + %f", a, c)
Aprender = [a c];
end



x=Totales(:,1);
yIng=Totales(:,2);
TotalIngres=Learn(x,yIng);
yEgr=Totales(:,4);
TotalEgres=Learn(x,yEgr);
yEst=Totales(:,3);
TotalEst=Learn(x,yEst);
#{
Censo = [1 36260130; 10 40091359]
xCenso=Censo(:,1)
yCenso=Censo(:,2)
TotalCenso=Learn(xCenso,yCenso)
#}
figure(1)
plot(Totales(:,1),Totales(:,2),'.',Totales(:,1),Totales(:,3),'.',Totales(:,1),Totales(:,4),'.',Totales(:,1),
	(TotalIngres(1)*(Totales(:,1))+TotalIngres(2)),Totales(:,1),(TotalEgres(1)*(Totales(:,1))+TotalEgres(2)),Totales(:,1),
	(TotalEst(1)*(Totales(:,1))+TotalEst(2)))
title("Totales");
xlabel("Periodo");
ylabel("Cant. Alumnos");
Ingresantes = TotalIngres(1)*20+TotalIngres(2);
Estudiantes = TotalEst(1)*20+TotalEst(2);
Egresados = (TotalEgres(1)*20)+TotalEgres(2)
Poblacion2020 = (425692*2020)-815549562
format("long");
disp("Ingresantes: "),disp(Ingresantes)
disp("Estudiantes: "),disp(Estudiantes)
disp("Egresados: "),disp(Egresados)
disp("Poblacion"),disp(Poblacion2020)
Poblacion2001 = 36260130;
Poblacion2010 = 40091359;
MatrizGrafico = [2001 2010 2020; 100*Totales(1,2)/Poblacion2001 100*Totales(10,2)/Poblacion2010 100*Ingresantes/Poblacion2020; 
	100*Totales(1,3)/Poblacion2001 100*Totales(10,3)/Poblacion2010 100*Estudiantes/Poblacion2020; 
	100*Totales(1,4)/Poblacion2001 100*Totales(10,4)/Poblacion2010 100*Egresados/Poblacion2020; 
	Poblacion2001 Poblacion2010 Poblacion2020]  
disp ("Porcentaje ingresantes 2001 = "),disp(100*Totales(1,2)/Poblacion2001)
disp ("Porcentaje ingresantes 2010 = "),disp(100*Totales(10,2)/Poblacion2010)
disp ("Porcentaje ingresantes 2020 = "),disp(100*Ingresantes/Poblacion2020)
disp ("Porcentaje estudiantes 2001 = "),disp(100*Totales(1,3)/Poblacion2001)
disp ("Porcentaje estudiantes 2010 = "),disp(100*Totales(10,3)/Poblacion2010)
disp ("Porcentaje estudiantes 2020 = "),disp(100*Estudiantes/Poblacion2020)
disp ("Porcentaje egresados 2001 = "),disp(100*Totales(1,4)/Poblacion2001)
disp ("Porcentaje egresados 2010 = "),disp(100*Totales(10,4)/Poblacion2010)
disp ("Porcentaje egresados 2020 = "),disp(100*Egresados/Poblacion2020)

MatrizGrafico = MatrizGrafico';
h2 = figure(2);
bar(MatrizGrafico(:,1),MatrizGrafico(:,2));
title("Porcentaje de Ingresantes con respecto a la poblacion total")
xlabel("Periodo");
ylabel("Porcentaje");
print(h2,'-dpng','-color','Ingresantes.png');
h3 = figure(3);
bar(MatrizGrafico(:,1),MatrizGrafico(:,3))
title("Porcentaje de Estudiantes con respecto a la poblacion total");
xlabel("Periodo");
ylabel("Porcentaje");
print(h3,'-dpng','-color','Estudiantes.png');
h4 = figure(4);
bar(MatrizGrafico(:,1),MatrizGrafico(:,4))
title("Porcentaje de Egresados con respecto a la poblacion total");
xlabel("Periodo");
ylabel("Porcentaje");
print(h4,'-dpng','-color','Egresados.png');
