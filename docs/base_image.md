# ベースイメージの管理

https://docs.openshift.com/container-platform/3.9/dev_guide/managing_images.html

ここでは、OpenShiftのユーザーが使用できるベースイメージを追加します。

## jdk10の登録

LTS版でないJava9や10は、Red Hatから提供される公式イメージがないので、使うには自分でインポートする必要があります。

ここでは、Java10を使いたいという場合を想定して、DockerHubからOpenShiftにインポートします。

以下コマンドを実行して、JDK10を全ユーザーが使用できるベースイメージとして登録します。

```bash
oc import-image jdk --from=docker.io/openjdk --all --confirm -n openshift
```