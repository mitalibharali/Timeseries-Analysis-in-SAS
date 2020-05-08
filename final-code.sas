proc import datafile = '/folders/myfolders/sasuser.v94/gsk_full.csv'
			out = gsk 
			dbms = csv replace;
run;
proc import datafile = '/folders/myfolders/sasuser.v94/nvs_full.csv'
			out = nvs
			dbms = csv;
run;
proc import datafile = '/folders/myfolders/sasuser.v94/sny_full.csv'
			out = sny
			dbms = csv;
run;
proc import datafile = '/folders/myfolders/sasuser.v94/jnj_full.csv'
			out = jnj
			dbms = csv;
run;
proc import datafile = '/folders/myfolders/sasuser.v94/nvo_full.csv'
			out = nvo 
			dbms = csv replace;
		
run;

*****plot Trend*************;

title "Trend Plot of GSK";
proc sgplot data = gsk;
   series x = Attributes y = Close;
run;
title "Trend Plot of JNJ";
proc sgplot data = jnj;
   series x = Attributes y = Close;
run;
title "Trend Plot of SNY";
proc sgplot data = sny;
   series x = Attributes y = Close;
run;
title "Trend Plot of NVO";
proc sgplot data = nvo;
   series x = Attributes y = Close;
run;
title "Trend of NVS";
proc sgplot data = nvs;
   series x = Attributes y = Close;
run;

*****differencing*************;
title "Differencing of gsk";
proc arima data=gsk;
  identify var=Close(1) stationarity=(adf);
run;
title "Differencing of jny";
proc arima data=jnj;
  identify var=Close(1) stationarity=(adf=1);
run;
title "Differencing of sny";
proc arima data=sny;
  identify var=Close(1) stationarity=(adf=1);
run;
title "Differencing of nvs";
proc arima data=nvs;
  identify var=Close(1) stationarity=(adf=1); **white noise series;
run;
title "Differencing of nvo";
proc arima data=nvo;
  identify var=Close(0) stationarity=(adf=1);**white noise series;
run;

******random walk model for nvo and nvs*********;
title "Random Walk - nvs";
proc arima data = nvs
	plots(only) = (series(corr crosscorr) residual(corr normal) forecast(forecastonly));
	identify var=Close(1);
	estimate p=(0) q=(0) method=ML outstat = resultsnvs;
	forecast lead=30 back=10 alpha=0.05 id=Attributes interval=day;
	outlier;
run;
proc print data=resultsnvs;
run;
quit;
title "Random Walk - nvo";
proc arima data = nvo
	plots(only) = (series(corr crosscorr) residual(corr normal) forecast(forecastonly));
	identify var=Close(1);
	estimate p=(0) q=(0) method=ML outstat = resultsnvo ;
	forecast lead=30 back=10 alpha=0.05 id=Attributes interval=day;
	outlier;
run;
proc print data=resultsnvo;
run;
quit;

************* estimate*********;
title "Estimate of gsk";
proc arima data = gsk
	plots= all;
	identify var=Close(1);
	estimate p=(1) q=(1) method=ML outstat = resultsgsk;
	forecast lead=30 back=10 alpha=0.05 id=Attributes interval=day;
run;
quit;
proc print data=resultsgsk; *print out SSE;
run;

title "Estimate of sny";
proc arima data = sny
	plots(only) = (series(corr crosscorr) residual(corr normal));
	identify var=Close(1);
	estimate p=(1 2) q=(1) method=ML outstat = resultssny;
	forecast lead=0 back=30 alpha=0.05 id=Attributes interval=day;
	outlier sigma=MSE;;
run;
proc print data=resultssny;
run;
title "Estimate of jnj";
proc arima data = jnj
	plots(only) = (series(corr crosscorr) residual(corr normal));
	identify var=Close(1);
	estimate p=(1 2) q=(1 2) method=ML outstat = resultsjnj;
	forecast lead=0 back=30 alpha=0.05 id=Attributes interval=day;
	outlier sigma=MSE;
run;
quit;
proc print data=resultsjnj;
run;

proc esm data=gsk
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance) 
		outstat=outnvo;
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=WINTERS;
	run;
/* where year(Attributes) > 2019; */

proc esm data=gsk
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		outstat=outgsk;
		where year(ATTRIBUTES) > 2019;
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=simple;
	run;

proc esm data=nvo
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		outstat=outnvo;
		where year(Attributes) > 2019; 
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=simple;
	run;

proc esm data=jnj
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		outstat=outjnj;
		where year(Attributes) > 2019; 
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=winters;
	run;


proc esm data=nvs
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		outstat=outnvs;
		where year(Attributes) > 2019; 
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=winters;
	run;

proc esm data=sny
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		outstat=outnvo;
		where year(Attributes) > 2019; 
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=winters;
	run;



