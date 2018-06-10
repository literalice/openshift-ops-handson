# ノードの削除

https://docs.openshift.com/container-platform/3.9/admin_guide/manage_nodes.html#deleting-nodes

## 現状の確認

踏み台からmasterにsshログインし、現時点のノードの数を確認する

```bash
[cloud-user@ip-xx-xx-xx-xx ~]$ oc get nodes
NAME                                             STATUS    ROLES     AGE       VERSION
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1h        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1m        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     master    1h        v1.9.1+a0ce1bc657
```

## 削除するノードからアプリケーションコンテナを追い出す

https://docs.openshift.com/container-platform/3.9/admin_guide/manage_nodes.html#evacuating-pods-on-nodes

踏み台ホストに入り、以下のコマンドを実行してノードからアプリケーションコンテナを追い出す

```bash
oc adm drain ip-xxx.xxx.xxx.xxx --delete-local-data
```

## 追い出されたアプリケーションが新しいノードに移動され、アクセスできることを確認する

http://nginx-example-playground.app.ocp.example.com

にアクセスし、問題なくアクセス出来ていることを確認する

## ノードを削除する

踏み台ホストで以下のコマンドを実行し、ノードをクラスタから削除する

```bash
[cloud-user@ip-xx-xx-xx-xx ~]$ oc delete node ip-xx-xx-xx-xx.ap-northeast-1.compute.internal
node "ip-xx-xx-xx-xx.ap-northeast-1.compute.internal" deleted
```

## ノードが削除されたことを確認する

```bash
[cloud-user@ip-xx-xx-xx-xx ~]$ oc get nodes
NAME                                             STATUS    ROLES     AGE       VERSION
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1h        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     master    2h        v1.9.1+a0ce1bc657
```

## ノードのVMを削除する

AWSのマネージメントコンソールからVMを削除する
