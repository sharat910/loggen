# loggen

A golang application that uses [zerolog](https://github.com/rs/zerolog) to produce some dummy logs. 
An INFO level log message is generated ever second and a DEBUG level log message is generated every one-tenth of a second.
Log messages are written to a file and (pretty-)printed out.

This simple application is dockerized and can be built and run on local machine or a remote server 
via the use of `docker context`. 

Refer to the self-explanatory `Makefile` to understand the process.