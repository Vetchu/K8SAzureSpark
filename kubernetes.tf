provider "kubernetes" {
  host = azurerm_kubernetes_cluster.polygraph.kube_config[0].host

  client_key             = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].client_key)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].client_certificate)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].cluster_ca_certificate)

  load_config_file = false
}


resource "kubernetes_namespace" "spark-operator" {
  metadata {
    name = "spark-operator"
  }
}

resource "kubernetes_namespace" "spark-jobs" {
  metadata {
    name = "spark-jobs"
  }
}

resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka"
  }
}

# provider "kubectl" {
#   host = azurerm_kubernetes_cluster.polygraph.kube_config[0].host

#   client_key             = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].client_key)
#   client_certificate     = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].client_certificate)
#   cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.polygraph.kube_config[0].cluster_ca_certificate)

#   load_config_file = false
# }


# resource "kubectl_manifest" "test_spark" {
#     depends_on=[
#          helm_release.spark
#     ]
#     yaml_body = file("spark-pi.yaml")
# }

# resource "kubectl_manifest" "apply_jobserver" {
#     depends_on=[
#          helm_release.spark
#     ]
#     yaml_body = file("spark-jobserver.yaml")
# }