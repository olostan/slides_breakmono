$ kubectl run --image=nginx nginx-app --port=80
deployment "nginx-app" created

$ kubectl expose deployment nginx-app --port=80 --name=nginx-http --type=LoadBalancer
service "nginx-http" exposed

$ kubectl get svc
  NAME         CLUSTER-IP     EXTERNAL-IP      PORT(S)     AGE
  nginx-http   10.3.255.118   130.211.59.140   80/TCP      1m