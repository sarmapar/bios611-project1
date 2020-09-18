FROM rocker/verse
MAINTAINER Sarah Parker <sarmae@live.unc.edu>
RUN R -e "install.packages('reshape2')"
