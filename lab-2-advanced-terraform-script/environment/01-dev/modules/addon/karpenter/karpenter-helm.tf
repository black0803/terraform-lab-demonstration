# # Logout of helm registry to perform an unauthenticated pull against the public ECR
# helm registry logout public.ecr.aws

# helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter --version "${KARPENTER_VERSION}" --namespace "${KARPENTER_NAMESPACE}" --create-namespace \
#   --set "settings.clusterName=${CLUSTER_NAME}" \
#   --set "settings.interruptionQueue=${CLUSTER_NAME}" \
#   --set controller.resources.requests.cpu=1 \
#   --set controller.resources.requests.memory=1Gi \
#   --set controller.resources.limits.cpu=1 \
#   --set controller.resources.limits.memory=1Gi \
#   --wait

resource "helm_release" "karpenter_crd" {
  namespace           = "karpenter"
  name                = "karpenter-crd"
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter-crd"
  version             = var.karpenter_version
  wait                = false

  set =[
    {
        name  = "webhook.enabled"
        value = "true"
    },
    {
        name  = "webhook.serviceName"
        value = "karpenter"
    },
    {
        name  = "webhook.port"
        value = "8443"
    }
  ]
}
resource "helm_release" "karpenter" {
  namespace           = "karpenter"
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter"
  version             = var.karpenter_version
  wait                = false

  set = [
  {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::211125502617:role/loena-Prod-karpenter-controller-role"
  },
  {
    name  = "webhook.enabled"
    value = "true"
  },
  {
    name  = "webhook.port"
    value = "8443"
  },
  {
    name  = "nodeSelector.karpenter\\.sh/controller"
    value = "true"
  },
  {
    name  = "tolerations[0].key"
    value = "CriticalAddonsOnly"
  },
  {
    name  = "tolerations[0].operator"
    value = "Exists"
  },
  {
    name  = "tolerations[1].key"
    value = "karpenter.sh/controller"
  },
  {
    name  = "tolerations[1].operator"
    value = "Exists"
  },
  {
    name  = "tolerations[1].effect"
    value = "NoSchedule"
  },
  {
    name  = "settings.clusterName"
    value = data.aws_eks_cluster.cluster.id
  },
  {
    name  = "settings.clusterEndpoint"
    value = data.aws_eks_cluster.cluster.endpoint
  }
]
}