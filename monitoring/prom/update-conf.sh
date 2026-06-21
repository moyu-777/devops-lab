#!/bin/bash
PROM_DIR="."   # 替换为你的实际路径
NS="prom"

kubectl create configmap prometheus-config \
  --from-file=prometheus.yml=$PROM_DIR/prometheus.yml \
  -n $NS --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap prometheus-rules \
  --from-file=$PROM_DIR/rules/ \
  -n $NS --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap alertmanager-config \
  --from-file=alertmanager.yml=$PROM_DIR/alertmanager.yml \
  -n $NS --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap blackbox-config \
  --from-file=config.yml=$PROM_DIR/blackbox.yml \
  -n $NS --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap dingtalk-config \
  --from-file=config.yml=$PROM_DIR/dingtalk/config.yml \
  -n $NS --dry-run=client -o yaml | kubectl apply -f -

kubectl delete -f prom.yml

kubectl apply -f prom.yml
echo "All ConfigMaps created."
