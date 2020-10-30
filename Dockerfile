FROM rocker/verse
MAINTAINER Sarah Parker <sarmae@live.unc.edu>
RUN R -e "install.packages('reshape2')"
RUN R -e "install.packages('MLmetrics')"
RUN R -e "install.packages('gbm')"
RUN R -e "install.packages('ggfortify')"
RUN R -e "install.packages('caret', dependencies=TRUE)"
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine matplotlib pandasql bokeh
