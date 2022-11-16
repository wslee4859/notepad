# airflow 기동절차



# airflow server volume dag 경로

1. wsl 실행

2. /mnt/ 들어가면 실제 윈도우 물리경로가 마운트 됨. 

3. pipeline 소스가 포함된 경로를 airflow dag 경로로 선언

   ​

   ```
       volumes: #컨테이너에서 저장된 데이터들을 살려두기 위한 부분 
       - /mnt/d/DataLake/Airflow/pipeline:/opt/airflow/dags
       - ./logs:/opt/airflow/logs
       - ./plugins:/opt/airflow/plugins
       - /var/run/docker.sock:/var/run/docker.sock
   ```

   ​

4. pipeline image 만들기

   1. docker python:3.8.12-slim 이미지 받아오기

   2. 기본 pythone lib pipeline module

      ```
      docker pull python:3.8.12-slim
      docker build . -t "pipeline_module" -f Dockerfile-module
      docker built
      ```

      ​


# Trouble​ Shooting

1. dags 경로 마운트 못하는 경우
   1. docker compose volumes 경로가 잘못된경우
   2. **docker-compose up 명령어를 어느 운영체제에서 실행하느냐에 따라 실제 마운트경로가 다르므로 wsl 이나 linux에서 실행** 

2. Airflow DAG 실행 시 log 를 찾지 못해 DAG 배치가 실패하는 경우

   1. Docker에 생성된 Airflow log 파일에 쓰기 권한이 먹지 않는 경우 발생

   2. log 파일을 별도 폴더로 생성하고 docker-compose 파일에서 log도 별도 생성된 펼도로 mount 지정

   3. ```
      volumes: #컨테이너에서 저장된 데이터들을 살려두기 위한 부분 
          # - /your/pipeline/path:/opt/airflow/dags       #like under line
          - /mnt/d/DataLake/AirFlow/pipeline:/opt/airflow/dags
          # - airflow.cfg:/opt/airflow/airflow.cfg
          - /mnt/d/DataLake/logs:/opt/airflow/logs
          - ./plugins:/opt/airflow/plugins
          - /var/run/docker.sock:/var/run/docker.sock
      ```