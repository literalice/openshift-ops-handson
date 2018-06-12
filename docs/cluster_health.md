# クラスタのヘルスチェック

https://docs.openshift.com/container-platform/3.9/day_two_guide/environment_health_checks.html#day-two-guide-network-connectivity

クラスタと必要なコンポーネントが正しく動作していることを確認します。クラスタの状態がおかしいなと思ったらこちらの方法で確認してみてください。

## アプリケーションがデプロイできることを確認する

### プロジェクトの作成

OpenShiftのコンソール画面から、「Create Project」を選択し、「playground」と入力してアプリケーションを作成します。

![Create First Project](/docs/images/create_project_web.png)

### アプリケーションのデプロイ

アプリケーションがデプロイできることを確認します。

1. OpenShiftのコンソール画面から、「Search Catalog」に「node」と入力し、「Node.js」を選択する。 ![Search Node.js](/docs/images/search_catalog_nodejs.png)
2. Application Nameに「hello」を、Git Repositoryに「Try Sample Repository」をクリックしてソースコードのURLの入力する。 ![Search Node.js](/docs/images/create_nodejs_app.png)
3. 「Create」ボタンを押下してプロジェクトをデプロイする。

### アプリケーションへアクセスできるよう、hostsファイルを登録する

本ハンズオンの構成ではmasterサーバーにRouterがデプロイされているので、デプロイしたアプリケーションにはmasterサーバー経由でアクセスします。
（Routerをmasterサーバー以外の独立したInfraサーバーにデプロイしている場合は、そのInfraサーバー経由でアプリケーションにアクセス）

RouterはDNS名でアクセス先のアプリケーションを振り分けているので、以下のようにアプリケーションのホスト名をhostsに登録して、ホスト名でOpenShiftにアクセスできるようにしてください。

アプリケーションのホスト名は、OpenShiftのコンソール画面から確認できます。

![Confirm App Route](/docs/images/confirm_app_route.png)

```bash
xx.xx.xx.xx master.ocp.example.com
xx.xx.xx.xx(master(↑)と同じIP) hello-playground.app.ocp.example.com
```

### アプリケーションがデプロイされていることを確認

1. ブラウザで http://hello-playground.app.ocp.example.com へアクセスする
2. masterサーバーで `oc get pods -n playground` コマンドを実行して `hello` アプリケーションが表示されることを確認する

```bash
# 踏み台に入る
ssh `terraform output bastion_ssh` -i ./.platform_private_key

# masterサーバーで oc get podsコマンドを実行する
ansible -i inventory.yml master.ocp.internal -a "oc get pods -n playground" --become-user=cloud-user
```

## ノードのヘルスチェック

クラスタが起動しており、masterサーバーとの接続状態が保たれていることを確認します。

踏み台からmasterサーバーに入り、 `oc get nodes` コマンドを実行してください。

```bash
# 踏み台に入る
ssh `terraform output bastion_ssh` -i ./.platform_private_key

# masterサーバーで oc get podsコマンドを実行する
ansible -i inventory.yml master.ocp.internal -a "oc get nodes" --become-user=cloud-user
NAME                                             STATUS    ROLES     AGE       VERSION
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1h        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     master    1h        v1.9.1+a0ce1bc657
```

上記の出力にノードが全て含まれており、STATUSがReadyになっていることを確認してください。

## etcdの状態確認

クラスタの状態を保持するDBであるetcdクラスタの状態を確認するには、masterサーバーで `etcdctl2` コマンドを実行します。

踏み台からmasterサーバーに入り、 以下のようにコマンドを実行してください。

```bash
# 踏み台に入る
ssh `terraform output bastion_ssh` -i ./.platform_private_key

# masterサーバーでetcdctlコマンドを実行する
ssh cloud-user@master.ocp.internal
sudo su -
etcdctl2 cluster-health

member xxx is healthy: got healthy result from https://xx.xx.xx.xx:2379
cluster is healthy
```

## ルーターとコンテナイメージレジストリが起動しているか確認する

OpenShift外部からのアクセスをOpenShift内部のコンテナに振り分ける主要コンポーネントの一つ、ルーターが起動しているか確認するには、以下コマンドを実行します。

```bash
# 踏み台に入る
ssh `terraform output bastion_ssh` -i ./.platform_private_key

# masterサーバーでocコマンドを実行する
ansible -i inventory.yml master.ocp.internal -a "oc -n default get deploymentconfigs/router" --become-user=cloud-user

NAME      REVISION   DESIRED   CURRENT   TRIGGERED BY
router    1          1         1         config
```

DESIREDとCURRENTが同じ値になっていることを確認します。

同様に、クラスタにデプロイされるコンテナのレジストリが起動しているか確認するには以下コマンドを実行します。

```bash
ansible -i inventory.yml master.ocp.internal -a "oc -n default get deploymentconfigs/docker-registry" --become-user=cloud-user

NAME              REVISION   DESIRED   CURRENT   TRIGGERED BY
docker-registry   1          1         1         config
```

## ネットワークの接続性

### サービスディスカバリー

masterサーバーで稼働するSkyDNSはサービスディスカバリーを提供しており、クラスタ内でコンテナにアクセスする際にIPでなく名前でアクセスできるようにします。

コンテナのIPは常に変動するため、コンテナ間で通信するにはコンテナが起動しているだけでなくこの機能が動作していることが重要です。

masterサーバーで以下コマンドを実行して、クラスタ内のアドレスが取得できることを確認します。

```bash
ansible -i inventory.yml master.ocp.internal -a "dig +short docker-registry.default.svc.cluster.local" --become-user=cloud-user

172.30.150.7
```

上記の結果が、クラスタの管理コマンドが返す結果と一致していればサービスディスカバリーは正しく動作しています。

```bash
ansible -i inventory.yml master.ocp.internal -a "oc get svc/docker-registry" --become-user=cloud-user

NAME              CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
docker-registry   172.30.150.7   <none>        5000/TCP   3d
```

### クラスタの管理APIと管理コンソールが動作しているか

クラスタの管理用APIと管理コンソールは以下コマンドで正しく接続できるか確認できます。

これらのAPIやコンソール画面はアプリケーションのデプロイなどで使用されるため、クラスタを使用する人全員からアクセスできるようになっている必要があります。
ローカルのマシンから以下コマンドを実行して接続性を確認してください。

```bash
curl -k https://master.ocp.example.com:8443/version

{
  "major": "1",
  "minor": "9",
  "gitVersion": "v1.9.1+a0ce1bc657",
  "gitCommit": "a0ce1bc",
  "gitTreeState": "clean",
  "buildDate": "2018-05-26T11:56:37Z",
  "goVersion": "go1.9.4",
  "compiler": "gc",
  "platform": "linux/amd64"
}

curl -k https://master.ocp.example.com:8443/healthz
ok
```

curlコマンドが無い場合は、ブラウザで上記URLに移動してみてください。
