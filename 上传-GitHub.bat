@echo off
chcp 65001 >nul
title 设计保研工作台 - 一键上传到 GitHub
cd /d "%~dp0"

set REPO=design-baoyan-workbench
set USER=gaocrypto123
set BRANCH=main

echo ============================================
echo   设计保研工作台 - 上传到 GitHub
echo   仓库: %USER%/%REPO%
echo ============================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo [X] 没找到 git，请先安装 Git for Windows
  pause & exit /b 1
)
echo [1/5] 检查 git ..................... OK

if not exist ".git" (
  echo [2/5] 初始化本地仓库 ..............
  git init -b %BRANCH% >nul 2>&1
  if errorlevel 1 ( git init >nul 2>&1 )
) else (
  echo [2/5] 已有仓库，跳过 init .........
)

echo [3/5] 检查远端 .....................
git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin https://github.com/%USER%/%REPO%.git
  echo         已添加远端
) else (
  echo         远端已存在
)

echo [4/5] 提交 .........................
git add -A
git -c user.name="gaocrypto123" -c user.email="1489914259@qq.com" commit -m "feat: 设计保研工作台 v1 - 单文件 HTML，含政策卡、成绩绩点、加分台账、作品集科研、时间轴材料、投递看板" -q
if errorlevel 1 (
  echo         没有可提交的改动（之前已提交过）
)

echo [5/5] 推送 .........................
git push -u origin %BRANCH%
if errorlevel 1 (
  echo.
  echo [X] 推送失败。常见原因：
  echo     1) 仓库还不存在 —— 先去 https://github.com/new 建一个空仓库，名字填 %REPO%
  echo     2) 没登录 —— 重新跑一次： git credential-manager github login
  echo     3) 代理没开 —— git 已配 127.0.0.1:7890，确保代理软件开着
  echo     4) 想要免密码 —— 改用 SSH：把 id_rsa.pub 粘到 GitHub SSH Keys 里
  echo.
  pause & exit /b 1
)

echo.
echo ============================================
echo   上传成功！
echo   仓库地址: https://github.com/%USER%/%REPO%
echo ============================================
echo.
echo 下一步（可选）：拿到在线链接
echo   进入仓库 → Settings → Pages → Source 选 Deploy from branch
echo   branch 选 %BRANCH%，目录选 /(root) → Save
echo   等 1~2 分钟，访问 https://%USER%.github.io/%REPO%/
echo.
echo 注意：这个 Pages 链接是国内学员大概率打不开的，
echo       真要发给学员，请用文件 / 网盘 / Gitee Pages。
echo.
pause
