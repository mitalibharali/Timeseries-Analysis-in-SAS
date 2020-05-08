*******************************************
* Lecture 5: Time Series (Exponential Smoothing)

*
*******************************************;

dm 'clear log'; dm 'clear output';  /* clear log and output */

libname session5 "E:\Users\mxb180027\Documents\My SAS Files\9.4\ESM";
title;

/* For Project */

proc esm data=session5.gsk
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance) 
		outstat=WORK.outnvo;
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=WINTERS;
	run;
/* where year(Attributes) > 2019; */

proc esm data=session5.gsk
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance) 
		where year(Attributes) > 2019;
		outstat=WORK.outgsk;
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=simple;
	run;

proc esm data=session5.nvo
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		where year(Attributes) > 2019; 
		outstat=WORK.outnvo;
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=simple;
	run;

proc esm data=session5.jnj
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		where year(Attributes) > 2019; 
		outstat=WORK.outjnj;
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=winters;
	run;


proc esm data=session5.nvs
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		where year(Attributes) > 2019; 
		outstat=WORK.outnvs;
		id ATTRIBUTES interval=day;
    forecast Close / alpha=0.05 model=winters;
	run;

proc esm data=session5.sny
		back=0 lead=12 
		plot=(modelforecasts forecastsonly)
		print=(estimates forecasts statistics performance)
		where year(Attributes) > 2019; 
		outstat=WORK.outnvo;
		id ATTRIBUTES interval=sny;
    forecast Close / alpha=0.05 model=winters;
	run;
