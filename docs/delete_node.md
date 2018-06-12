# ノードの削除

https://docs.openshift.com/container-platform/3.9/admin_guide/manage_nodes.html#deleting-nodes

## 現状の確認

踏み台からmasterにsshログインし、現時点のノードの数を確認します。

```bash
[cloud-user@ip-xx-xx-xx-xx ~]$ oc get nodes
NAME                                             STATUS    ROLES     AGE       VERSION
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1h        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1m        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     master    1h        v1.9.1+a0ce1bc657
```

## 削除するノードからアプリケーションコンテナを追い出す

https://docs.openshift.com/container-platform/3.9/admin_guide/manage_nodes.html#evacuating-pods-on-nodes

踏み台に入り、以下のコマンドを実行してノードからアプリケーションコンテナを追い出してください。

```bash
ssh `terraform output bastion_ssh` -i ./.platform_private_key

oc adm drain ip-xxx.xxx.xxx.xxx --delete-local-data
```

## 追い出されたアプリケーションが新しいノードに移動され、アクセスできることを確認する

http://hello-playground.app.ocp.example.com

にアクセスし、問題なくアクセス出来ていることを確認します。

## ノードを削除する

踏み台で以下のコマンドを実行し、ノードをクラスタから削除してください。

```bash
ssh `terraform output bastion_ssh` -i ./.platform_private_key

oc delete node ip-xx-xx-xx-xx.ap-northeast-1.compute.internal

node "ip-xx-xx-xx-xx.ap-northeast-1.compute.internal" deleted
```

## ノードが削除されたことを確認する

```bash
[cloud-user@ip-xx-xx-xx-xx ~]$ oc get nodes
NAME                                             STATUS    ROLES     AGE       VERSION
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1h        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     master    2h        v1.9.1+a0ce1bc657
```

## 削除したノードでサブスクリプションを解除する

踏み台で以下のコマンドを実行し、削除したノードのシステム登録を解除します。

```bash
ssh `terraform output bastion_ssh` -i ./.platform_private_key

ansible compute1.ocp.internal -i ./inventory.yml -a "subscription-manager unregister"
```

## ノードのVMを削除する

AWSのマネージメントコンソールから削除したノードのVMをシャットダウンできます。
