@echo off
cd /d %~dp0

setlocal
set CUR_DATE=%date%
set CUR_TIME=%time:~0,5%
set DEFAULT_MSG=작업(%CUR_DATE% %CUR_TIME%)

echo.
echo [0/4] 변경사항 스테이징 중...
git add .

echo.
echo ================= 커밋 대상 파일 =================
git status
echo ================================================

:CONFIRM
echo.
set /p confirm="위 파일들을 업로드할까요? (YES / NO): "

if /I "%confirm%"=="YES" goto CONTINUE
if /I "%confirm%"=="NO" goto RESET

echo.
echo 잘못된 입력입니다. YES 또는 NO만 입력하세요.
goto CONFIRM

:RESET
echo.
echo 작업을 취소합니다. (staging 초기화)
git reset
pause
exit /b

:CONTINUE
echo.
echo [1/4] 커밋 메시지 입력...
set /p msg="메시지 입력 (엔터 시 '%DEFAULT_MSG%'): "
if "%msg%"=="" set msg=%DEFAULT_MSG%
git commit -m "%msg%"

echo.
echo [2/4] 서버 업데이트 가져오기 (Pull)...
git pull
if %errorlevel% neq 0 (
    echo.
    echo !!!!!!!! 경고: 충돌Conflict 이 발생했습니다 !!!!!!!!
    pause
    exit /b
)

echo.
echo [3/4] 서버에 업로드 (Push)...
git push

echo.
echo 모든 작업이 성공적으로 완료되었습니다!
pause
