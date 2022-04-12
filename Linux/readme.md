# bash: ll: command not found 에러

jupyter lab termianl shell 색깔이 안나올 경우에도

```shell
echo "alias ll='ls --color=auto -alF'" >> ~/.bashrc
source ~/.bashrc
```
리눅스 환경 설정 파일들을 수정하기만 한다고 바로 내용이 적용되는 것은 아니다. 리부팅이나 쉘에 재로그인 하지 않고 수정된 새로운 환경 설정 내용을 즉시 적용하기 위해서 source 명령어가 사용된다.
