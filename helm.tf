provider "helm" {
  version = "1.2.2"
  kubernetes {
    host = azurerm_kubernetes_cluster.polygraph.kube_config[0].host

    client_key             = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].cluster_ca_certificate)
    load_config_file       = false
  }
}

resource "helm_release" "ingress" {
  name       = "ingress"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nginx-ingress"
  timeout    = 1200

  set {
    name  = "rbac.create"
    value = "true"
  }
}


resource "helm_release" "spark" {
  depends_on = [
    kubernetes_namespace.spark-operator,
    kubernetes_namespace.spark-jobs
  ]

  name       = "spark"
  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart      = "sparkoperator"
  namespace  = "spark-operator"

  set {
    name  = "sparkJobNamespace"
    value = "spark-jobs"
  }
  set {
    name  = "serviceAccounts.spark.name"
    value = "spark"
  }
}


resource "helm_release" "kafka" {
  depends_on = [
    kubernetes_namespace.kafka
  ]
  name       = "kafka"
  repository = "https://strimzi.io/charts"
  chart      = "strimzi-kafka-operator"
  namespace  = "kafka"
  timeout    = 1200
}


resource "helm_release" "neo4j" {
  name       = "neo4j"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "neo4j"
  timeout    = 1200
  set {
    name  = "acceptLicenseAgreement"
    value = "yes"
  }

  set {
    name  = "neo4jPassword"
    value = "mySecretPassword"
  }
}
