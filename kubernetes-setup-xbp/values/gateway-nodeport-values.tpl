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
  type: "NodePort"

podAnnotations:
  "proxy.istio.io/config" : "{\"gatewayTopology\" : { \"numTrustedProxies\": 1 } }"