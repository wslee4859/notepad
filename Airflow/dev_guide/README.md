# DataLake Project

Airflow : [http://airflow.lottechilsung.co.kr:8081/]  
MLFlow : [http://mlflow.lottechilsung.co.kr:5000/#/]  
FastAPI : [http://10.120.4.109:8000/docs]    
JupyterHub : [http://jupyterhub01.lottechilsung.co.kr:18010/]  

106번 Airflow Worker Name : 106_worker

--- 
## Docker Compose up / down

### **109 랜딩서버**
Airflow / MLFlow (Airflow / MLFlow 분리 가능)
 - /data/infrastructure/airflow_server 경로 이동
 - docker-compose -f "docker-compose_landing.yaml" up           # Service 실행
 - docker-compose -f "docker-compose_landing.yaml" down           # Service 중지

FastAPI
 - docker run -d -p 8000:8000 -v /data/log/fastapi:/app/server/data/log/fastapi --name fastapi_v1 fastapi_v1   # Service 실행
 - docker stop fastapi_v1    # Service 중지


### **106 분석서버**
Airflow-worker
 - /data/infrastructure/airflow_server 경로 이동
 - docker-compose -f "docker-compose_worker.yaml" up           # Service 실행
 - docker-compose -f "docker-compose_worker.yaml" down           # Service 중지

JupyterHub
 - /data/jupyterdock 경로 이동
 - start-tljh.sh            # Service 실행
 - docker stop tljh-dev     # Service 중지

Landing Server Airflow와 통신을 위한 2375 Open Container
 - docker run -p 2375:2375 -v /var/run/docker.sock:/var/run/docker.sock --name 2375portopen jarkt/docker-remote-api
 - docker stop 2375portopen

--- 

## 설치경로

### **109 랜딩서버** 
Airflow : /data/infrastructure/airflow_server/docker-compose_landing.yaml  
MLFlow : /data/infrastructure/airflow_server/docker-compose_landing.yaml  
FastAPI : /data/fastapi/analysis_service/Dockerfile  

### **106 분석서버**  
Airflow-worker : /data/infrastructure/airflow_server/docker-compose_worker.yaml  
JupyterHub : /data/jupyterdock

---

## 설치 볼륨 및 포트

### **109 랜딩서버**

Airflow
 - 볼륨 경로
   - log : /data/infrastructure/airflow_server/logs
   - plugins : /data/infrastructure/airflow_server/plugins
   - pipeline : /data/infrastructure/pipeline  
   - 인증서 : /home/lotte/.ssh
   - docker 연결 파일 : /var/run/docker.sock
 - Port
   - Airflow Postgres : 5432
   - MLFlow Postgres : 5433
   - Redis : 6379  
   - MLFlow : 5000
   - Webserver : 8081

FastAPI
 - 볼륨 경로
   - log : /data/log/fastapi
 - Port
   - FastAPI Web : 8000

### **106 분석서버**  
Airflow-Worker
 - 볼륨 경로
   - log : /data/airflow/logs
   - plugins : /data/infrastructure/airflow_server/plugins
   - docker 연결 파일 : /var/run/docker.sock
   - pipeline : /data/infrastructure/pipeline
   - 인증서 : /home/lotte/.ssh
 - Port
   - Worker : 8793
   - Landing Server Airflow와 통신을 위한 Port : 2375

JupyterHub
 - 볼륨 경로
   - JupyterHub 설정 파일 : /data/jupyterdock
   - JupyterHub 계정 : /data/jupyterdock/home
 - Port
   - JupyterHub : 18010

실행 중인 Docker의 자세한 정보(Port및 Status)는 docker ps 명령어로 확인 가능

---

## Guideline 목록

- Data_pipeline.md

---

### Data_pipeline.md
Airflow / MLflow 에 관한 가이드라인

서버 환경 설정 및 로컬 개발 환경 설정에 대한 설명 기재

**로컬 환경 설정 CheckList**
 - [ ] WSL  
 - [ ] Docker  
 - [ ] Docker Setting ( docker.sock Permission | Docker Engine | [Storage Change] )  
 - [ ] 개발 Tool  
 - [ ] Git Clone   
 - [ ] Image Build ( Airflow | Pipeline Module | Pipeline Dir | MLFlow | FastAPI )  
 - [ ] Compose Up ( Airflow | MLFlow | FastAPI )   


