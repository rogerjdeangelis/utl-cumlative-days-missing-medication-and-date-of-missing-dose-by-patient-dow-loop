Cumlative days missing medication and date of missing doses by patient dow loop                                                         
                                                                                                                                        
Improved solutions and comments by Paul Dorfman and Bartosz Jablonski (Thanks Paul and Bart)                                            
                                                                                                                                        
  1. Improved faster solution, elimination of 'by' on second loop of DOW by Paul Dorfman                                                
     Also Paul's sage comments on the overhead of by processing (with benchmarks)                                                       
     Paul Dorfman <sashole@bellsouth.net>                                                                                               
                                                                                                                                        
  2, Bart's innovative hash with parallel arrays                                                                                        
     Bartosz Jablonski                                                                                                                  
     yabwon@gmail.com                                                                                                                   
                                                                                                                                        
  3. Original (slower) DOW loop                                                                                                         
                                                                                                                                        
github                                                                                                                                  
http://tinyurl.com/yy6dwrms                                                                                                             
https://github.com/rogerjdeangelis/utl-cumlative-days-missing-medication-and-date-of-missing-dose-by-patient-dow-loop                   
                                                                                                                                        
SAS Forum (similar to)                                                                                                                  
http://tinyurl.com/yxrog54l                                                                                                             
https://communities.sas.com/t5/SAS-Programming/Number-of-missing-and-location-of-missing-across-rows-in/m-p/538433                      
                                                                                                                                        
INPUT                                                                                                                                   
=====                                                                                                                                   
                                                                                                                                        
data have;                                                                                                                              
 input pat dose date $10.;                                                                                                              
cards4;                                                                                                                                 
1 . 10/01/2018                                                                                                                          
1 2 10/02/2018                                                                                                                          
1 1 10/03/2018                                                                                                                          
1 1 10/04/2018                                                                                                                          
2 . 11/12/2018                                                                                                                          
2 . 11/13/2018                                                                                                                          
2 3 11/14/2018                                                                                                                          
3 . 11/11/2018                                                                                                                          
3 2 11/19/2018                                                                                                                          
3 . 11/20/2018                                                                                                                          
3 . 11/21/2018                                                                                                                          
4 2 12/11/2018                                                                                                                          
4 . 12/12/2018                                                                                                                          
4 . 12/13/2018                                                                                                                          
4 . 12/14/2018                                                                                                                          
;;;;                                                                                                                                    
run;quit;                                                                                                                               
                                                                                                                                        
EXAMPLE OUTPUT AND RULES                                                                                                                
------------------------                                                                                                                
                                                                                                                                        
 WORK.WANT total obs=15                                                                                                                 
                             |   RULES                                                                                                  
                             |                                                                                                          
                             |    CUM_               MISS                                                                               
  PAT    DOSE       DATE     |  MISSING              DATE                                                                               
                             |                                                                                                          
   1       .     10/01/2018  |     1 One        10/01/2018                                                                              
   1       2     10/02/2018  |     1 Missing                                                                                            
   1       1     10/03/2018  |     1 Dose                                                                                               
   1       1     10/04/2018  |     1                                                                                                    
                                                                                                                                        
   2       .     11/12/2018  |     2 Two        11/12/2018  -> date of first missing                                                    
   2       .     11/13/2018  |     2 Missing    11/13/2018  -> date of second missing                                                   
   2       3     11/14/2018  |     2 Doses                                                                                              
                                                                                                                                        
   3       .     11/11/2018  |     3            11/11/2018                                                                              
   3       2     11/19/2018  |     3                                                                                                    
   3       .     11/20/2018  |     3            11/20/2018                                                                              
   3       .     11/21/2018  |     3            11/21/2018                                                                              
                                                                                                                                        
   4       2     12/11/2018  |     3                                                                                                    
   4       .     12/12/2018  |     3            12/12/2018                                                                              
   4       .     12/13/2018  |     3            12/13/2018                                                                              
   4       .     12/14/2018  |     3            12/14/2018                                                                              
                                                                                                                                        
*_     ____             _                                                                                                               
/ |   |  _ \ __ _ _   _| |                                                                                                              
| |   | |_) / _` | | | | |                                                                                                              
| |_  |  __/ (_| | |_| | |                                                                                                              
|_(_) |_|   \__,_|\__,_|_|                                                                                                              
                                                                                                                                        
;                                                                                                                                       
                                                                                                                                        
data want;                                                                                                                              
                                                                                                                                        
  do _n_=1 by 1 until(last.pat);                                                                                                        
     set have;                                                                                                                          
     by pat;                                                                                                                            
     cum_missing + (dose=.);                                                                                                            
  end;                                                                                                                                  
                     ** Pauls enhancement;                                                                                              
  do _n_=1 to _n_;   ** no need for by group processing which is slower, note _n_=1 to _n_;                                             
     set have;                                                                                                                          
     if dose=. then miss_date=date;                                                                                                     
     else miss_date='';                                                                                                                 
     output;                                                                                                                            
  end;                                                                                                                                  
  cum_missing=0;                                                                                                                        
run;quit;                                                                                                                               
                                                                                                                                        
                                                                                                                                        
Roger,                                                                                                                                  
                                                                                                                                        
A very nice example of using the double DoW!                                                                                            
                                                                                                                                        
Let me just make one note: The principal idea behind _n_=1 by 1 is not so                                                               
much having this count available in the first loop (though it may be helpful, too)                                                      
as counting the number of records in the BY group using                                                                                 
_n_ in the second to eschew the second BY statement:                                                                                    
                                                                                                                                        
do _n_ = 1 by 1 until (last.k) ;                                                                                                        
  set have ;                                                                                                                            
  by k ;                                                                                                                                
  ...                                                                                                                                   
end ;                                                                                                                                   
do _n_ = 1 to _n_ ;                                                                                                                     
  set have ;                                                                                                                            
  * no BY here ;                                                                                                                        
  ...                                                                                                                                   
end ;                                                                                                                                   
                                                                                                                                        
On the surface, BY doesn't seem to matter much performance-wise.                                                                        
But it does add some overhead since it makes SAS compare,                                                                               
for every input record,  the BY key-values in the PDV with                                                                              
the key-values in the buffer in order to set FIRST.x and LAST.x.                                                                        
For a lot of record and/or many BY keys it can matter. Doing the                                                                        
counting has its own overhead, yet it's less onerous. Here's a simple experiment:                                                       
                                                                                                                                        
data v / view = v ;                                                                                                                     
  array k k1-k5 ;                                                                                                                       
  do _n_ = 1 to 1e8 ;                                                                                                                   
    do over k ;                                                                                                                         
      k = ceil (rand ("uniform") * 7) ;                                                                                                 
    end ;                                                                                                                               
    output ;                                                                                                                            
  end ;                                                                                                                                 
run ;                                                                                                                                   
                                                                                                                                        
data _null_ ;                                                                                                                           
  t = time() ;                                                                                                                          
  do until (z1) ;                                                                                                                       
    set v end = z1 ;                                                                                                                    
  end ;                                                                                                                                 
  time = time() - t ;                                                                                                                   
  put time= ;                                                                                                                           
  t = time() ;                                                                                                                          
  do until (z2) ;                                                                                                                       
    set v end = z2 ;                                                                                                                    
    by k1-k5 notsorted ;                                                                                                                
  end ;                                                                                                                                 
  time = time() - t ;                                                                                                                   
  put time= ;                                                                                                                           
  stop ;                                                                                                                                
run ;                                                                                                                                   
                                                                                                                                        
The two loops do exactly the same, except the second one has to                                                                         
do the BY bookkeeping while the first does not. Here're the read times:                                                                 
                                                                                                                                        
time=25.98                                                                                                                              
time=38.94                                                                                                                              
                                                                                                                                        
Best regards                                                                                                                            
                                                                                                                                        
                                                                                                                                        
*____      ____             _                                                                                                           
|___ \    | __ )  __ _ _ __| |_                                                                                                         
  __) |   |  _ \ / _` | '__| __|                                                                                                        
 / __/ _  | |_) | (_| | |  | |_                                                                                                         
|_____(_) |____/ \__,_|_|   \__|                                                                                                        
                                                                                                                                        
;                                                                                                                                       
                                                                                                                                        
                                                                                                                                        
And if I may, one more, little bit messy,                                                                                               
which replaces fires hash with parallel arrays;                                                                                         
                                                                                                                                        
all the best                                                                                                                            
Bart                                                                                                                                    
                                                                                                                                        
data _null_;                                                                                                                            
  dsid = open("have(obs=0)");                                                                                                           
                                                                                                                                        
  do _N_ = 1 to attrn(dsid,"nvars");                                                                                                    
    call symputX(cats("variableNM",_N_), VARNAME(dsid, _N_), "G");                                                                      
    call symputX(cats("variableTP",_N_), ifc(VARTYPE(dsid, _N_)="C", "$", ""), "G");                                                    
    call symputX(cats("variableLN",_N_), VARLEN(dsid, _N_), "G");                                                                       
  end;                                                                                                                                  
                                                                                                                                        
  call symputX("nvars", _N_-1, "G");                                                                                                    
  call symputX("nobs", attrn(dsid,"nobs"), "G");                                                                                        
  dsid = close(dsid);                                                                                                                   
  stop;                                                                                                                                 
run;                                                                                                                                    
%put _user_;                                                                                                                            
                                                                                                                                        
%macro arrays(nobs);                                                                                                                    
  %do i = 1 %to &nvars.;                                                                                                                
    array _&&variableNM&i[&nobs.] &&variableTP&i &&variableLN&i;                                                                        
  %end;                                                                                                                                 
%mend arrays;                                                                                                                           
                                                                                                                                        
%macro add(obsnum);                                                                                                                     
  %do i = 1 %to &nvars.;                                                                                                                
    _&&variableNM&i[&obsnum.] = &&variableNM&i;                                                                                         
  %end;                                                                                                                                 
%mend add;                                                                                                                              
                                                                                                                                        
%macro get(obsnum);                                                                                                                     
  %do i = 1 %to &nvars.;                                                                                                                
     &&variableNM&i = _&&variableNM&i[&obsnum.];                                                                                        
  %end;                                                                                                                                 
%mend get;                                                                                                                              
                                                                                                                                        
data want3;                                                                                                                             
  if 0 then set have;                                                                                                                   
  %arrays(&nobs.)                                                                                                                       
                                                                                                                                        
  declare hash missing();                                                                                                               
    missing.defineKey("pat");                                                                                                           
    missing.defineData("cum_missing");                                                                                                  
    missing.defineDone();                                                                                                               
                                                                                                                                        
  do until(eof);                                                                                                                        
   set have end = eof curobs=curobs;                                                                                                    
    %add(curobs);                                                                                                                       
                                                                                                                                        
    if missing.find() then                                                                                                              
      do;                                                                                                                               
        cum_missing=0;                                                                                                                  
      end;                                                                                                                              
      cum_missing + (dose=.);                                                                                                           
      missing.replace();                                                                                                                
  end;                                                                                                                                  
                                                                                                                                        
  do curobs = 1 to &nobs.;                                                                                                              
    %get(curobs)                                                                                                                        
    missing.find();                                                                                                                     
      if dose=. then miss_date=date;                                                                                                    
                else call missing(miss_date);                                                                                           
    output;                                                                                                                             
  end;                                                                                                                                  
  drop _:;                                                                                                                              
stop;                                                                                                                                   
run;                                                                                                                                    
                                                                                                                                        
*_____     ___       _       _             _                                                                                            
|___ /    / _ \ _ __(_) __ _(_)_ __   __ _| |                                                                                           
  |_ \   | | | | '__| |/ _` | | '_ \ / _` | |                                                                                           
 ___) |  | |_| | |  | | (_| | | | | | (_| | |                                                                                           
|____(_)  \___/|_|  |_|\__, |_|_| |_|\__,_|_|                                                                                           
                       |___/                                                                                                            
;                                                                                                                                       
                                                                                                                                        
data want;                                                                                                                              
  do _n_=1 by 1 until(last.pat);                                                                                                        
     set have;                                                                                                                          
     by pat;                                                                                                                            
     cum_missing + (dose=.);                                                                                                            
  end;                                                                                                                                  
  do _n_=1 by 1 until(last.pat);                                                                                                        
     set have;                                                                                                                          
     by pat;                                                                                                                            
     if dose=. then miss_date=date;                                                                                                     
     else miss_date='';                                                                                                                 
     output;                                                                                                                            
  end;                                                                                                                                  
  cum_missing=0;                                                                                                                        
run;quit;                                                                                                                               
                                                                                                                                        
                                                                                               
                                                                                                                               
