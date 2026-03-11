#!/bin/bash
set -e

# 阿里云镜像仓库配置
REGISTRY="registry.cn-hangzhou.aliyuncs.com"
NAMESPACE="yvan329"
REPOSITORY="waoowaoo"
TAG="${1:-latest}"

IMAGE_NAME="${REGISTRY}/${NAMESPACE}/${REPOSITORY}:${TAG}"

echo "=========================================="
echo "Building and pushing Docker image"
echo "=========================================="
echo "Registry: ${REGISTRY}"
echo "Namespace: ${NAMESPACE}"
echo "Repository: ${REPOSITORY}"
echo "Tag: ${TAG}"
echo "Full image name: ${IMAGE_NAME}"
echo "=========================================="

# 构建镜像
echo ""
echo "Step 1: Building Docker image..."
docker build -t "${IMAGE_NAME}" .

# 如果指定了 latest 标签，同时打上版本号标签
if [ "${TAG}" != "latest" ]; then
    LATEST_IMAGE="${REGISTRY}/${NAMESPACE}/${REPOSITORY}:latest"
    echo ""
    echo "Tagging as latest..."
    docker tag "${IMAGE_NAME}" "${LATEST_IMAGE}"
fi

# 登录阿里云容器镜像服务
echo ""
echo "Step 2: Logging in to Aliyun Container Registry..."
echo "Please enter your Aliyun credentials:"
docker login "${REGISTRY}"

# 推送镜像
echo ""
echo "Step 3: Pushing Docker image..."
docker push "${IMAGE_NAME}"

# 如果有 latest 标签也推送
if [ "${TAG}" != "latest" ]; then
    echo ""
    echo "Pushing latest tag..."
    docker push "${LATEST_IMAGE}"
fi

echo ""
echo "=========================================="
echo "✅ Successfully built and pushed!"
echo "Image: ${IMAGE_NAME}"
echo "=========================================="
