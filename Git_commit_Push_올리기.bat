@echo off
cd /d %~dp0

setlocal
set CUR_DATE=%date%
set CUR_TIME=%time:~0,5%
set DEFAULT_MSG=작업(%CUR_DATE% %CUR_TIME%)

echo [1/3] 내 작업물 커밋...
git add .
set /p msg="메시지 입력 (엔터 시 '%DEFAULT_MSG%'): "
if "%msg%"=="" set msg=%DEFAULT_MSG%
git commit -m "%msg%"

echo.
echo [2/3] 서버 업데이트 가져오기 (Pull)...
git pull
:: pull 실패(충돌 등) 시 아래 구문이 작동함
if %errorlevel% neq 0 (
    echo.
    echo !!!!!!!! 경고: 충돌Conflict이 발생했습니다 !!!!!!!!
    pause
    exit /b
)

echo.
echo [3/3] 서버에 업로드 (Push)...
git push

echo.
echo 모든 작업이 성공적으로 완료되었습니다!
pause
