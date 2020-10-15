FROM rocker/verse
MAINTAINER Sarah Parker <sarmae@live.unc.edu>
RUN R -e "install.packages('reshape2')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('Rtsne')"
