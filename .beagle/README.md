# kube-vip

<https://github.com/kube-vip/kube-vip>

```bash
git remote add upstream git@github.com:kube-vip/kube-vip.git

git fetch upstream

git merge v0.5.0
```

## build

```bash
# cache
docker run \
--rm \
-v $PWD/:/go/src/github.com/kube-vip/kube-vip \
-w /go/src/github.com/kube-vip/kube-vip \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19-alpine \
rm -rf vendor && go mod tidy && go mod vendor

docker run \
--rm \
-v $PWD/:/go/src/github.com/kube-vip/kube-vip \
-w /go/src/github.com/kube-vip/kube-vip \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.19-alpine \
bash ./.beagle/build.sh
```

## cache

```bash
# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="cloud" \
  -e DRONE_REPO_NAME="kube-vip" \
  -e DRONE_COMMIT_BRANCH="master" \
  -e PLUGIN_MOUNT="./vendor" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="cloud" \
  -e DRONE_REPO_NAME="kube-vip" \
  -e DRONE_COMMIT_BRANCH="master" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```
