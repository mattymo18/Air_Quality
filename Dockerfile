FROM rocker/verse
MAINTAINER Matt Johnson <Johnson.Matt1818@gmail.com>
RUN R -e "install.packages('lubridate')"
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('MASS')"
RUN R -e "install.packages('pscl')"
RUN R -e "install.packages('gplots')"
RUN R -e "install.packages('glmnet')"
RUN R -e "install.packages('dplyr')"


