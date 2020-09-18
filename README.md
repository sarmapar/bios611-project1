Project 1
===========

National Parks Dataset
======================

Proposal
========

Introduction
------------

There are many National Parks in America that contain several different species of plants and animals. Some states have several large national parks, while others only have a few small ones. 

Does the amount of land devoted to national parks correlate with the number of species found in those parks? Which states have the most land devoted to state parks, and do those states have a higher biodiversity in the parks?

This project will undertake descriptive statistics of several publicaly available data sets. 

Datasets
--------

The datasets I analyze here are publically available on Kaggle and usda.gov. They can be downloaded. 
This repo contains an analysis of the US National Park Biodiversity and State Acerage datasets.

Usage
-----
You'll need Docker and the ability to run Docker as your current user. 

To build the container:
    > docker build . -t project1-env

This Docker container is based on rocker/verse. To run rstudio server:
    
    > docker run -v `pwd`:/home/rstudio -p 8787:8787 -e PASSWORD = mypass -t project1-env

Then connect to the machine on port 8787.

To run Bash:
    > docker run -v `pwd`:/home/rstudio -e PASSWORD=mypass -it l6 sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"


Makefile
--------
To build figures