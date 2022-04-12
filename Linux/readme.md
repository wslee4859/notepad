# bash: ll: command not found 에러

jupyter lab termianl shell 색깔이 안나올 경우에도

```shell
echo "alias ll='ls --color=auto -alF'" >> ~/.bashrc
source ~/.bashrc
```
리눅스 환경 설정 파일들을 수정하기만 한다고 바로 내용이 적용되는 것은 아니다. 리부팅이나 쉘에 재로그인 하지 않고 수정된 새로운 환경 설정 내용을 즉시 적용하기 위해서 source 명령어가 사용된다.


alias를 설정하는 파일은 여러 가지가 있을 수 있으나 가장 대표적인 것은 ~/.bashrc 파일
현재 로그인한 해당 계정의 쉘(bash)에 대한 기본 설정을 선언해 두는 곳으로

만약, 모든 사용자에게 적용하기를 원하면 /etc/profile 에 선언.
