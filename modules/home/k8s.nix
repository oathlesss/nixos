{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Kubernetes
    kubectl
    k9s
    kubectx # includes kubens
    helm
    kustomize
    kind # local clusters in Docker
    stern # multi-pod log tailing
    kubecolor # colorized kubectl output

    # Containers / DevOps
    dive # explore Docker image layers
    lazydocker
    podman
    podman-compose
    trivy # vulnerability scanner for containers
  ];
}
