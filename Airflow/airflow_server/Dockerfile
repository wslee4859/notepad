FROM apache/airflow:2.2.3-python3.8
# User : root
USER root
# apt update
RUN sudo apt update

# sasl lib 설치 
RUN sudo apt-get install libsasl2-dev -y 

# build error 방지
RUN sudo apt-get install -y build-essential python-dev python3-dev libpq-dev

# JDBC 연결을 위한 패키지 Install
RUN sudo apt-get install -y openjdk-11-jdk

# 파일수정을 위한 모듈 
RUN sudo apt-get install -y vim

# user : airflow
USER airflow

# Pip Upgrade
# RUN pip install --upgrade setuptools
RUN pip install --upgrade pip 

RUN pip install airflow-code-editor

RUN pip install "pystan<2.18" fbprophet

# Custom Install 
COPY requirements.txt ./

RUN pip install -r requirements.txt

# docker build . -t "airflow_server"
# 이미지 빌드 후 docker-compose up을 해야합니다!
# docker-compose up