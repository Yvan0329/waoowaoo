@echo off
setlocal enabledelayedexpansion

REM 阿里云镜像仓库配置
set REGISTRY=registry.cn-hangzhou.aliyuncs.com
set NAMESPACE=yvan329
set REPOSITORY=waoowaoo
set TAG=%1
if "%TAG%"=="" set TAG=latest

set IMAGE_NAME=%REGISTRY%/%NAMESPACE%/%REPOSITORY%:%TAG%

echo ==========================================
echo Building and pushing Docker image
echo ==========================================
echo Registry: %REGISTRY%
echo Namespace: %NAMESPACE%
echo Repository: %REPOSITORY%
echo Tag: %TAG%
echo Full image name: %IMAGE_NAME%
echo ==========================================

REM 构建镜像
echo.
echo Step 1: Building Docker image...
docker build -t "%IMAGE_NAME%" .
if errorlevel 1 (
    echo Error: Docker build failed
    exit /b 1
)

REM 如果指定了版本号标签，同时打上 latest 标签
if not "%TAG%"=="latest" (
    set LATEST_IMAGE=%REGISTRY%/%NAMESPACE%/%REPOSITORY%:latest
    echo.
    echo Tagging as latest...
    docker tag "%IMAGE_NAME%" "!LATEST_IMAGE!"
)

REM 登录阿里云容器镜像服务
echo.
echo Step 2: Logging in to Aliyun Container Registry...
echo Please enter your Aliyun credentials:
docker login %REGISTRY%
if errorlevel 1 (
    echo Error: Docker login failed
    exit /b 1
)

REM 推送镜像
echo.
echo Step 3: Pushing Docker image...
docker push "%IMAGE_NAME%"
if errorlevel 1 (
    echo Error: Docker push failed
    exit /b 1
)

REM 如果有 latest 标签也推送
if not "%TAG%"=="latest" (
    echo.
    echo Pushing latest tag...
    docker push "!LATEST_IMAGE!"
)

echo.
echo ==========================================
echo ✅ Successfully built and pushed!
echo Image: %IMAGE_NAME%
echo ==========================================

endlocal
