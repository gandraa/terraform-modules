pilot:
  autoscaleMin: ${pilot_minReplicas}
  replicaCount: ${pilot_minReplicas}

global:
  tracer:
    zipkin:
      address: "jaegertracing-collector.${namespace}:9411"