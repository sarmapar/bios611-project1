project 1
===========
I'm going to analyze the biodiversity of American National Parks dataset.
This git repo will eventually include this analysis.

Usage
-----
You'll need Docker and the ability to run Docker as your current user. 

This Docker container is based on rocker/verse. To run rstudio server:
    
    > docker run -v `pwd`:/home/rstudio -p 8787:8787 -e PASSWORD = mypassword -t project1-env

THen connect to the machine on port 8787.