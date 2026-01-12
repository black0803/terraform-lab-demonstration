data "http" "external_manifest" {
  # Replace with the actual URL of your Kubernetes manifest file
  url = "https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml"
}

resource "kubectl_manifest" "example" {
  # The raw YAML content is sourced from the http data source's response body
  yaml_body = data.http.external_manifest.body
}