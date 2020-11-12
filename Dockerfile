FROM rocker/verse
MAINTAINER Matt Johnson <Johnson.Matt1818@gmail.com>
RUN R -e "install.packages('lubridate')"
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('MASS')"
RUN R -e "install.packages('pscl')"
RUN R -e "install.packages('gplots')"
RUN R -e "install.packages('glmnet')"
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('ggfortify')"
RUN R -e "install.packages('cluster')"
RUN R -e "install.packages('Rtsne')"
RUN R -e "install.packages('knitr')"
RUN R -e "install.packages('kableExtra')"
RUN R -e "install.packages('broom')"
RUN R -e "install.packages('leaps')"
RUN R -e "install.packages('olsrr')"





