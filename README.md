# OpenShift 運用ハンズオン

## 環境構築

このハンズオンを実施するには、以下の用意が必要です。

* `ssh` クライアント
* [terraform](https://www.terraform.io/)
* AWS( https://aws.amazon.com )のアカウント
* RHN( https://www.redhat.com/en )のアカウント
* OCPの評価用サブスクリプション( https://www.redhat.com/wapps/eval/index.html?evaluation_id=1026 )

### ローカルマシンの準備

#### 本ハンズオンプロジェクトのダウンロード

このプロジェクトをローカルマシンにgit cloneするか、「Download ZIP」でダウンロードして適当なディレクトリに解凍してください。

#### terraform コマンドにパスを通す

ダウンロードした `terraform` コマンドを、パスの通っている場所に配置してください。

```bash
terraform version
```

任意のディレクトリで上記コマンドを実行し、結果が出力されることを確認します。

#### AWS認証情報の設定

AWSへアクセスできるよう、認証情報を設定します。
前もってAWSのアカウントを作成し、AWSのアクセスキーIDとシークレットアクセスキーを用意してください。

https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-environment.html

* Windows
  ```
  set AWS_ACCESS_KEY_ID=xxx
  set AWS_SECRET_ACCESS_KEY=xxx
  set AWS_DEFAULT_REGION=ap-northeast-1
  ```
* Linux, macOS, or Unix
  ```
  export AWS_ACCESS_KEY_ID=xxx
  export AWS_SECRET_ACCESS_KEY=xxx
  export AWS_DEFAULT_REGION=ap-northeast-1
  ```

## ハンズオン

### OpenShiftのインストール

[OpenShiftのインストール](/docs/install.md)

### OpenShiftクラスタのヘルスチェック

[OpenShiftのヘルスチェック](/docs/cluster_health.md)

### OpenShiftクラスタに管理ユーザーを追加する

[OpenShiftのユーザー権限](/docs/add_admin.md)

### OpenShiftクラスタのメトリクスを確認する

[OpenShiftクラスタのメトリクス](/docs/metrics.md)

### OpenShiftのログ集約機能を有効にする

[ログ集約機能](/docs/logging.md)

### OpenShiftにノードを追加する

[ノードの追加](/docs/add_node.md)

### OpenShiftからノードを削除する

[ノードの削除](/docs/delete_node.md)

### ベースイメージの管理

[ベースイメージの管理](/docs/base_image.md)

## 後片付け

### サブスクリプションの解除

踏み台で以下コマンドを実行し、システムの登録を解除します。

```bash
ansible all -i ./inventory.yml -a "subscription-manager unregister"
sudo subscription-manager unregister
```

ローカルマシンに戻り、プロジェクトのディレクトリで以下コマンドを実行してください。

```bash
terraform destroy
```
