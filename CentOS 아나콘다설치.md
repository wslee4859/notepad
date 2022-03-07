# conda docker packages 설치 시 NotFoundError
 
 * docker-py 로 설치

```shell
# docker 관련된 패키지 검색
conda search docker

conda install docker-py

```

python dag 실행시 docker module 을 못 읽어올 때     
docker 모듈 설치 에러 문구

```shell

Collecting package metadata (current_repodata.json): done
Solving environment: failed with initial frozen solve. Retrying with flexible solve.
Collecting package metadata (repodata.json): done
Solving environment: failed with initial frozen solve. Retrying with flexible solve.

PackagesNotFoundError: The following packages are not available from current channels:

  - docker

Current channels:

  - https://conda.anaconda.org/conda-forge/linux-64
  - https://conda.anaconda.org/conda-forge/noarch

To search for alternate channels that may provide the conda package you're
looking for, navigate to

    https://anaconda.org

and use the search bar at the top of the page.
  
```

# Anaconda 설치



참고 : https://jjeongil.tistory.com/1447

### 아나콘다 설치파일 다운로드 

```shell
# 아나콘다 설치
cd /tmp
curl -O https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh

```



스크립트의 데이터 무결성을 확인

sha256sum 명령을 사용하여 스크립트 체크섬을 확인

다음과 같은 출력이 표시되어야 합니다.

```
sha256sum Anaconda3-5.3.1-Linux-x86_64.sh

# d4c4256a8f46173b675dd6a62d12f566ed3487f932bab6bb7058f06c124bcc27  Anaconda3-5.3.1-Linux-x86_64.sh
```

위의 명령에서 출력된 해시가 해당 아나콘다 버전에 적합한 64비트 Linux 페이지의 Anaconda와 Python 3에서 사용할 수 있는 해시와 일치하는지 확인합니다.

```
https://docs.anaconda.com/anaconda/install/hashes/Anaconda3-5.3.1-Linux-x86_64.sh-hash.html
```



### 아나콘다 설치 스크립트 실행

**bunzip2: 명령을 찾을 수 없다는 오류가 표시되면 다음을 사용하여 bzip2 패키지를 설치하십시오.**

```shell
yum install bzip2
```



```
cd /tmp
bash Anaconda3-5.3.1-Linux-x86_64.sh
```

계속하려면 ENTER를 누르고 라이센스를 스크롤하려면 ENTER를 누르십시오. 라이센스 검토가 완료되면 라이센스 조건을 승인하라는 메시지가 표시됩니다. 

yes를 입력하여 라이센스를 수락하면 설치 위치를 선택하라는 메시지가 표시됩니다.

경로를 선택한다.

```
# Do you accept the license terms? [yes|no]Copy
# Type yes to accept the license and you’ll be prompted to choose the installation location.
# 
# Anaconda3 will now be installed into this location:
# /home/linuxize/anaconda3
# 
#     - Press ENTER to confirm the location
#     - Press CTRL-C to abort the installation
#     - Or specify a different location below
```

경로 선언 : /data/anaconda3



bashrc  경로 

/root/ .bashrc



아나콘다 설치를 활성화하려면 다음 명령을 사용하여 아나콘다 설치 관리자가 추가한 새 PATH 환경 변수를 현재 셸 세션에 로드합니다.

```
source ~/.bashrc
```















### Anaconda 계정 만들기

<user> | <group>

```sudo useradd anaconda | anaconda```



