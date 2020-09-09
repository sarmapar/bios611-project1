Project 1
===========
I'm going to analyze the biodiversity of American National Parks dataset from https://www.kaggle.com/nationalparkservice/park-biodiversity?select=species.csv. 
This git repo will eventually include this analysis.

Usage
-----
You'll need Docker and the ability to run Docker as your current user. 

This Docker container is based on rocker/verse. To run rstudio server:
    
    > docker run -v `pwd`:/home/rstudio -p 8787:8787 -e PASSWORD = mypassword -t project1-env

Then connect to the machine on port 8787.