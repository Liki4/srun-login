# ⚡ srun-login ![Go](https://github.com/vidar-team/srun-login/workflows/Go/badge.svg) [![Go Report Card](https://goreportcard.com/badge/github.com/vidar-team/srun-login)](https://goreportcard.com/report/github.com/vidar-team/srun-login) [![Sourcegraph](https://img.shields.io/badge/view%20on-Sourcegraph-brightgreen.svg?logo=sourcegraph)](https://sourcegraph.com/github.com/vidar-team/srun-login)

杭州电子科技大学校园网 Wi-Fi 登录 / 深澜（srun）校园网模拟登录

2021 年暑期学校网络大改造，更换了新的深澜上网认证系统。Vidar-Team 信息安全实验室需要适配学校新的认证系统进行自动登录接入网络，因此有了本项目。

## Build


```bash
docker buildx build -t autologin:latest-arm64 --platform linux/arm64 --output=type=docker .
docker save autologin:latest-arm64 > autologin-arm64.tar
```

## License

MIT License
