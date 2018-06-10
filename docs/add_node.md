# ノードの追加

https://docs.openshift.com/container-platform/3.9/install_config/adding_hosts_to_existing_cluster.html

## 現状の確認

踏み台からmasterにsshログインし、現時点のノードの数を確認する

```bash
[ec2-user@ip-10-0-29-82 ~]$ ssh cloud-user@master.ocp.internal

[cloud-user@ip-xx-xx-xx-xx ~]$ oc get nodes
NAME                                             STATUS    ROLES     AGE       VERSION
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1h        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     master    1h        v1.9.1+a0ce1bc657
```

## 追加するノードのVMを追加

`infrastructures/variables.tf` を開き、 `compute_node_count` の値を2に変更する

```terraform
variable "compute_node_count" {
  default = 2
}
```

## inventoryファイルに新規ノードを追加する

踏み台ホストに入り、inventoryファイルに新規ノードを追加する

```yaml
OSEv3:
  children:
    masters:
      hosts:
        master.ocp.internal: ""
    etcd:
      hosts:
        master.ocp.internal: ""
    nodes:
      hosts:
        master.ocp.internal:
          openshift_node_labels:
            region: infra
        compute0.ocp.internal:
          openshift_node_labels:
            region: primary
    new_nodes: # new_nodesホストグループに新規ホストを追加する
      hosts:
        compute1.ocp.internal:
          openshift_node_labels:
            region: primary
```

## ノード追加用のAnsible playbookを実行する

ansible-playbook -i ~/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/openshift-node/scaleup.yml

## ノードが追加されたことを確認する

```bash
[cloud-user@ip-xx-xx-xx-xx ~]$ oc get nodes
NAME                                             STATUS    ROLES     AGE       VERSION
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1h        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     compute   1m        v1.9.1+a0ce1bc657
ip-xx-xx-xx-xx.ap-northeast-1.compute.internal   Ready     master    1h        v1.9.1+a0ce1bc657
```
