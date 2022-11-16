** 108 / 110 / 111 Server 공통
    1. Docker install

       # CentOS 업데이트
       sudo yum update

       # Docker Update에 필요한 Tool 설치
       sudo yum install -y yum-utils device-mapper-persistent-data lvm2

       # Docker 공식 Repository 추가
       sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

       # 설치가능한 Docker version 확인
       sudo yum list docker-ce --showduplicates | sort -r

       # 최신 Docker version 설치
       sudo yum install -y docker-ce

       # Docker 시작
       systemctl start docker

       # Docker 상태 확인
       systemctl status docker

        # Docker-compose Version 1.25.5
        # docker-compose 파일 설치
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

        # docker-compose 파일 실행 권한 부여
        sudo chmod +x /usr/local/bin/docker-compose

        # docker-compose의 링크가 생성되지 않아 docker-compose가 실행되지 않을때 아래와 같이 링크를 만들어 줌 
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/

        sudo ln -s /usr/local/bin/gitlab-runner /usr/bin/

        # docker-compose 확인 
        docker-compose --version


        # daemon.json 설정 / docker.sock
        # Docker 설정 변경을 위해 Docker stop
        systemctl stop docker docker.socket

        # DNS 설정을 위해 daemon.json 생성 혹은 수정
        vi /etc/docker/daemon.jsonll

        # Docker의 Data 저장소 변경 시 기존 데이터 복사
        sudo rsync -aP /var/lib/docker/ /path/to/your/docker

        # daemon.json 내용 추가
        {
            "dns": ["10.120.1.24", "10.120.1.25"],
            "dns-search": ["lottechilsung.co.kr"],
            "data-root": "path/to/your/docker"
        }

        # docker.socket Permission 변경
        sudo chmod 777 /var/run/docker.sock

        # docker 재시작
        systemctl start docker


    2. gitlab-runner install

        # Git install
        sudo yum install -y git

        # Gitlab-Runner Version 14.5.2
        # 저장소 다운로드
        sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"

        # 실행권한 부여
        sudo chmod +x /usr/local/bin/gitlab-runner

        # 서비스 생성
        sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/lotte

        # Gitlab-Runner 등록
        sudo gitlab-runner register

        # gitlab 주소 입력(사진에 4번 부분)
        $ Enter the GitLab instance URL (for example, https://gitlab.com/):
        http://git.lottechilsung.co.kr:7777/

        # token 입력(사진에 5번 부분)
        $Enter the registration token:
        aeYy2sLjQB8oYnCbgZDy

        # runner 설명
        $Enter a description for the runner: 
        landing_runner

        # tag를 통해 JOB을 지정하므로 다른 Runner와 중복되지 않아야 함
        # runner tag 지정
        $Enter tags for the runner (comma-separated):
        landing_runner

        # 실행형식에 따라 입력 정보가 다름
        # runner 실행형식 지정
        $Enter an executor: parallels, shell, virtualbox, docker+machine, docker-ssh+machine, kubernetes, custom, docker, docker-ssh, ssh: 
        shell

        # 등록성공 메세지
        Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!

        # Runner Start
        sudo gitlab-runner start

        # "Gitlab-Runner 설치 지정한 working-directory에 생성된 .gitlab-runner 폴더로 이동

        # 해당 폴더에 있는 config.toml 수정
        vi config.toml (파일 수정 명령어) 
        [runners.custom_build_dir]하단에 
        enabled = true 추가


    3. Airflow Server up

        # git clone
        git clone http://git.lottechilsung.co.kr:7777/datalake/infrastructure.git

        # Airflow image build
        cd infrastructure/airflow_server
        docker build . -t 'airflow_server'

        # Airflow compose up
        docker-compose -f docker-compose_landing.yaml up

== 108 Used Port ==
mlflow -> 5000
redis -> 6379
postgres1 -> 5433
postgres2 -> 5432
airlfow_webserver -> 8081

--

# JupyterHub 설치

    # Docker를 이용하여 Jupyterhub를 구축

    1. git clone 
    git clone https://github.com/jupyterhub/the-littlest-jupyterhub.git

    2. Docker image build
    docker build -t tljh-systemd . -f integration-tests/Dockerfile

    3. Docker 실행 Shell 작성
    cat > start-tljh.sh
    sudo docker run --privileged --detach --name=tljh-dev -v $(pwd):/srv/src -v ${pwd}/home:/home --net=host tljh-systemd

    ./start-tljh.sh 

    4. Docker 컨테이너 접속
    docker exec -it tljh-dev /bin/bash

    5. 서비스 실행
    # In Docker Container
    python3 /srv/src/the-littlest-jupyterhub/bootstrap/bootstrap.py --admin <ID:PW>

    # docker network host이므로 18010포트로 http접속을 할 수 있도록 설정 후 reload
    # In  Docker Container
    6. tljh-config set http.port 18010 / 
    tljh-config set https.port 19010 / 
    tljh-config reload proxy

    6-1. Login한 유저의 기본 Interface lab으로 변경
    sudo tljh-config set user_environment.default_app jupyterlab
    sudo tljh-config reload hub

    6-2. tljh가 유휴 컬링 서비스(동작이 없을 시 Server down)는 기본적으로 활성화되어있기에(Default = 10min) 비활성화 옵션 추가
    sudo tljh-config set services.cull.enabled False
    sudo tljh-config reload

    7. 접속확인
    http://10.120.4.106:18010/



--

    -- 1. airflow docker-compose 수정
    -- 2. image 빌드
    -- 3. directory 구성
    -- 4. Docker 설정 변경
    -- 5. gitlab-runner 설정


# Postgres Install

    # repo 추가
    sudo yum install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

    # Postgresql 11 Install
    ※ repo 추가 후 처음 yum install 진행 시 repo 인증을 위해 GPG 인증 요청 시 모두 y로 진행
    sudo yum install postgresql11-server
    sudo yum install postgresql11-contrib

    # postgresql11 실행
    sudo /usr/pgsql-11/bin/postgresql-11-setup initdb

    # Service 확인
    systemctl status postgresql-11

    # Service 실행 및 확인
    systemctl start postgresql-11
    systemctl status postgresql-11

    # 설정 변경을 위해 Service 종료
    systemctl stop postgresql-11

    # Directory 변경
    ## 저장될 데이터 폴더 생성
    sudo mkdir /data/postgres
    sudo chown postgres:postgres /data/postgres

    # Postgres Directory  설정 변경
    sudo vi /var/lib/pgsql/11/data/postmaster.opts

    #/usr/pgsql-11/bin/postgres "-D" "/var/lib/pgsql/11/data/"  -> 기존 내용 주석처리
    /usr/pgsql-11/bin/postgres "-D" "/data/postgres/data/"      -> 내용 추가

    sudo vi /usr/lib/systemd/system/postgresql-11.service
    # Environment=PGDATA=/var/lib/pgsql/11/data/            -> 기존 내용 주석
    Environment=PGDATA=/data/postgres/data/                 -> 내용 추가

    # 기존 데이터 -> 변경할 데이터 폴더로 복사
    sudo cp -aP /var/lib/pgsql/11/data /data/postgres/

    # Service 재시작
    systemctl daemon-reload
    systemctl start postgresql-11
    systemctl status postgresql-11 ----> ─5542 /usr/pgsql-11/bin/postmaster -D /data/postgres/data/ 디렉토리가 변경되어 있다면 성공

    # postgres 접속
    sudo -u postgres psql

    # data_directory 변경 확인
    postgres=# show data_directory;

    /data/postgres/data --> 이 경로로 잡혀 있다면 성공

    # postgres 설정 변경
    sudo vi /data/postgres/data/postgresql.conf

    #listen_addresses = 'localhost'         # what IP address(es) to listen on;
    listen_addresses = '*'                                                                      -> 내용 추가
                                            # comma-separated list of addresses;
                                            # defaults to 'localhost'; use '*' for all
                                            # (change requires restart)
    #port = 5432                            # (change requires restart)
    port = 5432                                                                                 -> 내용 추가


    sudo vi /data/postgres/data/pg_hba.conf

    # 기존 내용들 복사 및 주석처리 후 아래 내용대로 수정

    # "local" is for Unix domain socket connections only
    #local   all             all                                     peer
    # IPv4 local connections:
    #host    all             all             127.0.0.1/32            ident
    # IPv6 local connections:
    #host    all             all             ::1/128                 ident
    # Allow replication connections from localhost, by a user with the
    # replication privilege.
    #local   replication     all                                     peer
    #host    replication     all             127.0.0.1/32            ident
    #host    replication     all             ::1/128                 ident


    # "local" is for Unix domain socket connections only
    local   all             all                                     trust
    # IPv4 local connections:
    host    all             all             0.0.0.0/0               trust
    # IPv6 local connections:
    host    all             all             ::1/128                 trust
    # Allow replication connections from localhost, by a user with the
    # replication privilege.
    local   replication     all                                     trust
    host    replication     all             127.0.0.1/32            trust
    host    replication     all             ::1/128                 trust


    # 변경된 설정 적용을 위해 Service 재시작
    systemctl restart postgresql-11


    # postgres 접속
    sudo -u postgres psql

    # 비밀번호 변경

    ## ALTER USER postgres PASSWORD '변경할 비밀번호';
    ALTER USER postgres PASSWORD 'postgres';


    # 유저 생성
    # CREATE USER [유저명] PASSWORD '비밀번호';
    # CREATE USER lotte PASSWORD 'Clf4949#' SUPERUSER; -> SUPERUSER로 생성
    postgres=# CREATE USER lotte PASSWORD 'Clf4949#';   # 110번 서버에선 SUPERUSER로 생성함

    # 유저 확인
    postgres=# select * from pg_user;

    # 유저에 CREATEDB 권한 부여
    ## ALTER USER [유저명] 권한             # 유저명까지 입력 후 TAB 누르면 부여할 수 있는 권한 볼 수 있음
    postgres=# ALTER USER lotte CREATEDB;    

    # DB 생성
    CRAETE DATABASE (DB_NAME) WITH OWNER (USER_NAME) ENCODING 'UTF8';

    # DB에 유저의 모든 권한 부여
    GRANT ALL PRIVILEGES ON DATABASE (DB_NAME) TO (USER_NAME);


    ※ DBeaver / telnet 에서 접속 시 연결이 안될 경우 방화벽 문제로 유추됨
    # 방화벽 확인
    sudo firewall-cmd --list-all

    # 방화벽 종료
    systemctl stop firewalld



=== 설치 목록 ===

** 108 Server Edge Server
1. Docker install
2. Gitlab-runner install
3. Airflow Server up

** 110 Server 분석서버3
1. Docker install
2. gitlab-runner install
3. Postgres install
4. Airflow worker up
5. JupyterHub up

** 111 Server 분석서버4
1. Docker install
2. gitlab-runner install
3. Postgres install
4. Airflow worker up
5. JupyterHub up


※ Airflow ssh 인증서

=== 운영 방향 ===

108 Airflow (운영) --- 107(GPU 소유), 111(GPU X)
109 Airflow (개발) --- 106(GPU 소유), 110(GPU X)
