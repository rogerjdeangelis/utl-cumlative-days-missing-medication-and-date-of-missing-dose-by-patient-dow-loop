Cumlative days missing medication and date of missing dose by patient dow loop                                                 
                                                                                                                               
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
                                                                                                                               
                                                                                                                               
SOLUTION                                                                                                                       
========                                                                                                                       
                                                                                                                               
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
                                                                                                                               
                                                                                                                               
                                                                                                                               
