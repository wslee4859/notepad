# docker ssh 작업시  
docker compose 할때 volumn 을 .ssh 경로로 지정
```
  volumes:
    # - .:/opt/airflow
    - ./logs:/opt/airflow/logs
    - ./plugins:/opt/airflow/plugins
    - /var/run/docker.sock:/var/run/docker.sock
    - /home/lotte/lcaf_v4/infrastructure/pipeline:/opt/airflow/dags
    - /home/lotte/.ssh:/home/airflow/.ssh

```

* local .ssh 폴더의 권한 변경이 필요  




# ssh conn 함수

load_system_host_keys 지정 필수

```
class sftp_adaptor():
    # SFTP 
    def sftp_conn(HOST, PORT, USER, PASSWORD=''):
        SFTP_HOST = HOST
        SFTP_PORT = PORT
        SFTP_USER = USER
        SFTP_PASSWORD = PASSWORD

        
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.load_system_host_keys(os.path.expanduser(os.path.join("~", ".ssh", "known_hosts")))
        #ssh.load_host_keys(os.path.expanduser(os.path.join("~", ".ssh", "known_hosts")))
        ssh.connect(SFTP_HOST, SFTP_PORT, SFTP_USER, SFTP_PASSWORD)
        
        ftp = ssh.open_sftp()

        return ftp

```





[참고] (https://velog.io/@solar/SSH-%EC%9D%B8%EC%A6%9D%ED%82%A4-%EC%83%9D%EC%84%B1-%EB%B0%8F-%EC%84%9C%EB%B2%84%EC%97%90-%EB%93%B1%EB%A1%9D-%EA%B0%84%ED%8E%B8%ED%95%98%EA%B2%8C-%EC%A0%91%EC%86%8D%ED%95%98%EA%B8%B0)


로컬에서 ssh key를 생성하고, 생성된 ssh key를 서버에 등록하면 해당 서버에 접속하려는 계정의 비밀번호 입력없이 ssh 접속이 가능

클라이언트는 비밀키를 가지고 있고, 서버에 공개키(id_rsa.pub)를 가지고 있도록 하여 접속하는 방식이다.

ssh-kegen으로 공개키/비밀키 한 쌍을 생성한다.

공개키를 접속할 서버(접속할 대상서버)의 ~/.ssh/authorized_keys 파일에 키값을 저장한다.

클라이언트에서 ssh userId@serverIP로 접속 가능하다.


클라이언트에서 인증키를 생성
-t : 키 타입 지정 (rsa, dsa)
-C : comment 를 남길경우 사용

```
 ~/.ssh  ssh-keygen -t rsa -C "EC2"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/ssun/.ssh/id_rsa): /Users/ssun/.ssh/my_ssh_key #키이름
Enter passphrase (empty for no passphrase): #비밀번호
Enter same passphrase again:
```
my_ssh_key와 my_ssh_key.pub 가 생성되었다. *.pub 파일은 공개키로 접속하고자 하는 서버에 등록하면 비밀번호 없이 접속 가능하다.
