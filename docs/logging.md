# OpenShiftのログ集約機能を有効化する

## inventoryファイルを修正する

踏み台に入り、以下のように `inventory.yml` を変更してください。

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
# ...
    openshift_logging_install_logging: true
    openshift_logging_install_eventrouter: true
    openshift_logging_es_pvc_dynamic: true
    openshift_logging_es_memory_limit: 512M
```

## ログ機能を有効にするPlaybookを実行する

踏み台で以下コマンドを実行し、メトリクスを有効化します。

```bash
ansible-playbook -i inventory.yml /usr/share/ansible/openshift-ansible/playbooks/openshift-logging/config.yml
```

## kibanaのURLをhostsに登録する

kibanaにブラウザからアクセス出来るよう、以下のようにhostsファイルを修正します。

```
54.249.87.141 kibana.app.ocp.example.com
```

## アプリケーションのログが見られることを確認する

Webコンソールを開き、以下を確認します。

* Podのログ出力画面で `Archive` が表示されていること
* `Archive` からKibanaのログ画面に遷移できること