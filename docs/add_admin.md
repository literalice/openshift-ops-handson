# OpenShiftクラスタに管理権限を持つユーザーを追加する

https://docs.openshift.com/container-platform/3.9/admin_guide/manage_rbac.html

## 踏み台からocコマンドでOpenShiftにログインする

まず、踏み台からocコマンドでOpenShiftにログインしてください。

```bash
# 踏み台に入る
ssh `terraform output bastion_ssh` -i ./.platform_private_key

# OpenShiftに踏み台からログイン
oc login -u admin -p admin https://master.ocp.example.com:8443

The server uses a certificate signed by an unknown authority.
You can bypass the certificate check, but any data you send to the server could be intercepted by others.
Use insecure connections? (y/n): y

Login successful.

You have one project on this server: "playground"

Using project "playground".
Welcome! See 'oc help' to get started.
```

### 現時点で見えるプロジェクトの確認

```bash
oc get projects

NAME         DISPLAY NAME   STATUS
playground                  Active
```

## masterサーバーでユーザーにクラスタ管理権限を付加する

ユーザーに管理権限を付加するには、管理権限が必要です。

masterサーバーでは、OpenShiftインストール時に、管理権限でOpenShiftにアクセスできるようocコマンドが設定されています。
masterサーバーにSSHログインすることで、管理権限で `oc` コマンドを実行できます。

masterサーバーで以下のように `oc adm policy` コマンドを実行してください。

```bash
# 踏み台にログインします
ssh `terraform output bastion_ssh` -i ./.platform_private_key

ansible -i inventory.yml master.ocp.internal -a "oc adm policy add-cluster-role-to-user cluster-admin admin" --become-user cloud-user
```

### 現時点で見えるプロジェクトの確認

権限が昇格され、管理用プロジェクトにアクセスできるようになったことを確認します。

```bash
oc get projects

NAME                                DISPLAY NAME   STATUS
default                                            Active
kube-public                                        Active
kube-service-catalog                               Active
kube-system                                        Active
logging                                            Active
management-infra                                   Active
openshift                                          Active
openshift-ansible-service-broker                   Active
openshift-infra                                    Active
openshift-node                                     Active
openshift-template-service-broker                  Active
openshift-web-console                              Active
playground                                         Active
```
