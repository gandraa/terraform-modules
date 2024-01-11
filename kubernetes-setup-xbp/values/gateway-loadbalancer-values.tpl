autoscaling:
  enabled: true
  minReplicas: ${gatewayMinReplicas}
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - podAffinityTerm:
        labelSelector:
          matchLabels:
            istio: "ingressgateway"
        topologyKey: "failure-domain.beta.kubernetes.io/zone"
      weight: 1

service:
  type: "LoadBalancer"
  ports:
  - name: "status-port"
    port: 15021
    targetPort: 15021
  - name: "http2"
    port: 80
    targetPort: 8080
  - name: "https"
    port: 443
    targetPort: 8443
  - name: "unibox"
    protocol: "TCP"
    port: 8090
    targetPort: 8090
  annotations:
    external-dns.alpha.kubernetes.io/hostname: "${mtlsGatewayUrl}"
    service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "300"

podAnnotations:
  "proxy.istio.io/config" : "{\"gatewayTopology\" : { \"numTrustedProxies\": 1 } }"