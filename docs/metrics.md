# OpenShiftクラスタのメトリクスを確認する

https://docs.openshift.com/container-platform/3.9/install_config/cluster_metrics.html

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
    openshift_metrics_install_metrics: true
    openshift_metrics_cassandra_storage_type: dynamic
```

## メトリクスを有効にするPlaybookを実行する

踏み台で以下コマンドを実行し、メトリクスを有効化します。

```bash
ansible-playbook -i ~/inventory.yml /usr/share/ansible/openshift-ansible/playbooks/openshift-metrics/config.yml
```

## メトリクスが有効になっていることを確認する

メトリクスの取得ソースURLである「hawkular-metrics.app.ocp.example.com」をhostsに追加します。

```
xxx.xxx.xxx.xxx hawkular-metrics.app.ocp.example.com
```

OpenShiftのコンソール画面で、 `hello` アプリケーションのメトリクスが取得できていることを確認してください。

「 Open Metrics URL」が表示されている場合は、クリックして証明書を許可します。

