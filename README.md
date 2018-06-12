# OpenShift 運用ハンズオン

## 環境構築

このハンズオンを実施するには、以下の用意が必要です。

* `ssh` クライアント
* [terraform](https://www.terraform.io/)
* RHN( https://www.redhat.com/en )のアカウント
* OCPの評価用サブスクリプション( https://www.redhat.com/wapps/eval/index.html?evaluation_id=1026 )

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

### テンプレートの作成と登録

TBD

## 後片付け

プロジェクトのディレクトリで、以下コマンドを実行してください。

```bash
../bin/terraform destroy
```