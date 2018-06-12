# OpenShiftクラスタに管理権限を持つユーザーを追加する

https://docs.openshift.com/container-platform/3.9/admin_guide/manage_rbac.html

## masterサーバーでユーザーにクラスタ管理権限を付加する

踏み台にログインします。

```bash
ssh `terraform output bastion_ssh` -i ./.platform_private_key
```

masterサーバーで以下のコマンドを実行します。

*xxxの部分をログインユーザー名に置き換えてください*

```bash
ansible -a "oc adm policy add-cluster-role-to-user cluster-admin xxxx" -i inventory.yml --become-user cloud-user master.ocp.internal
```