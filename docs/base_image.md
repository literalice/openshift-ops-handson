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

## 登録したベースイメージの確認

### ベースイメージから新しいアプリケーションをビルドしてみる

踏み台で以下のようなビルド設定を作成し、OpenShiftに登録してみます。

```bash
vi hello-jdk-build.yml
```

```bash
apiVersion: v1
kind: "ImageStream"
metadata:
  name: "hello-jdk"

---

kind: "BuildConfig"
apiVersion: "v1"
metadata:
  name: "hello-jdk"
spec:
  runPolicy: "Serial"
  source: 
    dockerfile: "FROM centos:7\nCMD java -version; exec /bin/bash -c 'trap : TERM INT; sleep infinity & wait'"
  strategy: 
    dockerStrategy:
      from:
        kind: "ImageStreamTag"
        name: "jdk:10.0"
        namespace: "openshift"
  output: 
    to:
      kind: "ImageStreamTag"
      name: "hello-jdk:latest"
```

```bash
oc apply -f hello-jdk-build.yml -n playground
```

### 新しいアプリケーションをデプロイしてみる

OpenShiftのコンソールから、上記でビルドしたコンテナイメージをデプロイしてみます。

「Add to Project」から、「Deploy Image」を選択してください。

![Add Image](/docs/images/add_image_to_project.png)

ダイアログに、以下の通り入力して「Deploy」を押下し、ビルドしたイメージをデプロイします。

![Deploy Image](/docs/images/deploy_image.png)

デプロイが完了したら、サイドメニューから「Applications」-> 「Pods」を選択し、デプロイしたコンテナを選択します。

「Terminal」タブでデプロイしたコンテナに入り、動作を確認してみてください。

![Confirm Image](/docs/images/confirm_deployed_image.png)

これで、OpenShift上に新しいベースイメージが登録され、開発者が登録されたOpenJDK 10のイメージを使って開発できるようになりました。
