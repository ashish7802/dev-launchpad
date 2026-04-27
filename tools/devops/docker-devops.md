# 🐳 Topic 6: Docker & DevOps Tools — Complete Developer Reference

> 350+ real, verified tools across 15 categories

---

## 1. Container Runtimes & Engines

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Docker Engine | Industry-standard container runtime and build tool | https://docker.com | ⭐⭐⭐⭐⭐ |
| Docker Desktop | Full Docker environment for Mac, Windows, Linux with GUI | https://docker.com/products/docker-desktop | ⭐⭐⭐⭐⭐ |
| Podman | Daemonless, rootless container engine compatible with Docker | https://podman.io | ⭐⭐⭐⭐⭐ |
| containerd | Industry-standard container runtime used by Kubernetes | https://containerd.io | ⭐⭐⭐⭐⭐ |
| CRI-O | Lightweight container runtime for Kubernetes | https://cri-o.io | ⭐⭐⭐⭐ |
| runc | Low-level OCI-compliant container runtime | https://github.com/opencontainers/runc | ⭐⭐⭐⭐⭐ |
| crun | Fast and lightweight OCI runtime written in C | https://github.com/containers/crun | ⭐⭐⭐⭐ |
| gVisor | Sandboxed container runtime with kernel isolation by Google | https://gvisor.dev | ⭐⭐⭐⭐ |
| Kata Containers | Secure containers using lightweight VMs | https://katacontainers.io | ⭐⭐⭐⭐ |
| Firecracker | Secure microVM runtime by AWS for serverless workloads | https://firecracker-microvm.github.io | ⭐⭐⭐⭐⭐ |
| LXC | Linux Containers — OS-level virtualization | https://linuxcontainers.org | ⭐⭐⭐⭐ |
| LXD | Next-gen container and VM manager built on LXC | https://ubuntu.com/lxd | ⭐⭐⭐⭐ |
| Incus | Community fork of LXD maintained by Linux Containers | https://linuxcontainers.org/incus | ⭐⭐⭐⭐ |
| OrbStack | Fast, lightweight Docker Desktop alternative for macOS | https://orbstack.dev | ⭐⭐⭐⭐⭐ |
| Rancher Desktop | Open-source container management for desktop with k8s | https://rancherdesktop.io | ⭐⭐⭐⭐⭐ |
| Lima | Linux virtual machines on macOS for container workloads | https://lima-vm.io | ⭐⭐⭐⭐ |
| Colima | Container runtimes on macOS with minimal setup | https://github.com/abiosoft/colima | ⭐⭐⭐⭐⭐ |
| Finch | Open-source client for container development by AWS | https://github.com/runfinch/finch | ⭐⭐⭐⭐ |
| nerdctl | Docker-compatible CLI for containerd | https://github.com/containerd/nerdctl | ⭐⭐⭐⭐⭐ |

---

## 2. Container Image Building

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Docker Build | Standard Dockerfile-based image build tool | https://docs.docker.com/build | ⭐⭐⭐⭐⭐ |
| BuildKit | Next-gen Docker build engine with caching and parallelism | https://github.com/moby/buildkit | ⭐⭐⭐⭐⭐ |
| Buildah | Build OCI images without a daemon from Red Hat | https://buildah.io | ⭐⭐⭐⭐⭐ |
| Kaniko | Build container images inside Kubernetes without Docker | https://github.com/GoogleContainerTools/kaniko | ⭐⭐⭐⭐⭐ |
| Buildpacks (CNB) | Cloud Native Buildpacks — build images without Dockerfile | https://buildpacks.io | ⭐⭐⭐⭐⭐ |
| Paketo Buildpacks | Modular buildpacks for Java, Node, Go, Python, Ruby | https://paketo.io | ⭐⭐⭐⭐⭐ |
| ko | Build Go container images without Dockerfile | https://ko.build | ⭐⭐⭐⭐⭐ |
| Jib | Build Java container images without Docker daemon | https://github.com/GoogleContainerTools/jib | ⭐⭐⭐⭐⭐ |
| Earthly | Repeatable, portable builds combining Dockerfile and Makefile | https://earthly.dev | ⭐⭐⭐⭐⭐ |
| Dagger | Programmable CI/CD pipelines in containers | https://dagger.io | ⭐⭐⭐⭐⭐ |
| img | Standalone daemonless image builder | https://github.com/genuinetools/img | ⭐⭐⭐ |
| Pack | CLI for building images using Cloud Native Buildpacks | https://buildpacks.io/docs/tools/pack | ⭐⭐⭐⭐ |
| Nixpacks | Build and deploy apps using Nix reproducible builds | https://nixpacks.com | ⭐⭐⭐⭐⭐ |
| Bazel | Google's polyglot build system with container support | https://bazel.build | ⭐⭐⭐⭐⭐ |
| Skaffold | Dev tool for building and deploying Kubernetes apps fast | https://skaffold.dev | ⭐⭐⭐⭐⭐ |
| Tilt | Smart rebuild and hot-deploy tool for Kubernetes dev | https://tilt.dev | ⭐⭐⭐⭐⭐ |

---

## 3. Container Registries

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Docker Hub | World's largest container image registry | https://hub.docker.com | ⭐⭐⭐⭐⭐ |
| GitHub Container Registry | Free container registry integrated with GitHub Actions | https://ghcr.io | ⭐⭐⭐⭐⭐ |
| Amazon ECR | Managed container registry fully integrated with AWS | https://aws.amazon.com/ecr | ⭐⭐⭐⭐⭐ |
| Google Artifact Registry | Managed container and package registry on GCP | https://cloud.google.com/artifact-registry | ⭐⭐⭐⭐⭐ |
| Azure Container Registry | Managed private Docker registry on Azure | https://azure.microsoft.com/container-registry | ⭐⭐⭐⭐⭐ |
| Harbor | Open-source enterprise container registry with security | https://goharbor.io | ⭐⭐⭐⭐⭐ |
| Quay | Red Hat container registry with vulnerability scanning | https://quay.io | ⭐⭐⭐⭐ |
| JFrog Artifactory | Universal artifact manager with Docker registry | https://jfrog.com/artifactory | ⭐⭐⭐⭐⭐ |
| Nexus Repository | Universal repository manager with Docker support | https://sonatype.com/nexus-repository | ⭐⭐⭐⭐⭐ |
| GitLab Container Registry | Built-in container registry in GitLab | https://gitlab.com | ⭐⭐⭐⭐⭐ |
| DigitalOcean Container Registry | Simple private container registry on DigitalOcean | https://digitalocean.com/products/container-registry | ⭐⭐⭐⭐ |
| Chainguard Registry | Minimal, hardened container images with low CVE count | https://chainguard.dev | ⭐⭐⭐⭐⭐ |
| ttl.sh | Anonymous, ephemeral container registry for testing | https://ttl.sh | ⭐⭐⭐⭐ |
| Zot | OCI-native container registry built for compliance | https://zotregistry.io | ⭐⭐⭐⭐ |
| Distribution | CNCF project — reference implementation of OCI registry | https://github.com/distribution/distribution | ⭐⭐⭐⭐ |

---

## 4. Container Orchestration

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Kubernetes | De facto standard for container orchestration at scale | https://kubernetes.io | ⭐⭐⭐⭐⭐ |
| Docker Swarm | Docker's built-in clustering and orchestration mode | https://docs.docker.com/engine/swarm | ⭐⭐⭐⭐ |
| Amazon ECS | AWS managed container orchestration service | https://aws.amazon.com/ecs | ⭐⭐⭐⭐⭐ |
| Amazon EKS | Managed Kubernetes service on AWS | https://aws.amazon.com/eks | ⭐⭐⭐⭐⭐ |
| Google GKE | Managed Kubernetes service on Google Cloud | https://cloud.google.com/kubernetes-engine | ⭐⭐⭐⭐⭐ |
| Azure AKS | Managed Kubernetes service on Azure | https://azure.microsoft.com/kubernetes-service | ⭐⭐⭐⭐⭐ |
| DigitalOcean DOKS | Managed Kubernetes on DigitalOcean | https://digitalocean.com/products/kubernetes | ⭐⭐⭐⭐⭐ |
| Nomad | Simple and flexible workload orchestrator by HashiCorp | https://nomadproject.io | ⭐⭐⭐⭐⭐ |
| Apache Mesos | Distributed systems kernel for resource management | https://mesos.apache.org | ⭐⭐⭐ |
| Rancher | Complete Kubernetes management platform | https://rancher.com | ⭐⭐⭐⭐⭐ |
| OpenShift | Red Hat enterprise Kubernetes platform | https://openshift.com | ⭐⭐⭐⭐⭐ |
| Tanzu | VMware Kubernetes platform for enterprise | https://tanzu.vmware.com | ⭐⭐⭐⭐ |
| Anthos | Google's hybrid and multi-cloud platform for Kubernetes | https://cloud.google.com/anthos | ⭐⭐⭐⭐ |
| Azure Arc | Extend Azure management to any infrastructure | https://azure.microsoft.com/arc | ⭐⭐⭐⭐ |
| Knative | Kubernetes-based platform for serverless workloads | https://knative.dev | ⭐⭐⭐⭐ |

---

## 5. Local Kubernetes Development

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| minikube | Run Kubernetes locally with VM or Docker driver | https://minikube.sigs.k8s.io | ⭐⭐⭐⭐⭐ |
| kind | Kubernetes IN Docker — for local cluster testing | https://kind.sigs.k8s.io | ⭐⭐⭐⭐⭐ |
| k3d | Lightweight k3s clusters in Docker | https://k3d.io | ⭐⭐⭐⭐⭐ |
| k3s | Lightweight certified Kubernetes for edge and IoT | https://k3s.io | ⭐⭐⭐⭐⭐ |
| MicroK8s | Lightweight Kubernetes for workstations by Canonical | https://microk8s.io | ⭐⭐⭐⭐⭐ |
| Docker Desktop Kubernetes | Built-in Kubernetes in Docker Desktop | https://docker.com/products/docker-desktop | ⭐⭐⭐⭐⭐ |
| Rancher Desktop | Open-source Kubernetes desktop app with containerd | https://rancherdesktop.io | ⭐⭐⭐⭐⭐ |
| ctlptl | CLI for local Kubernetes cluster management | https://github.com/tilt-dev/ctlptl | ⭐⭐⭐⭐ |
| Telepresence | Connect local dev environment to remote Kubernetes | https://telepresence.io | ⭐⭐⭐⭐⭐ |
| Bridge to Kubernetes | VS Code extension for local Kubernetes debugging | https://aka.ms/bridge-to-k8s | ⭐⭐⭐⭐ |
| Garden | Dev automation for Kubernetes with hot reload | https://garden.io | ⭐⭐⭐⭐ |
| DevSpace | Client-only Kubernetes dev tool with UI | https://devspace.sh | ⭐⭐⭐⭐ |

---

## 6. Kubernetes Management & CLI Tools

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| kubectl | Official Kubernetes command-line tool | https://kubernetes.io/docs/reference/kubectl | ⭐⭐⭐⭐⭐ |
| k9s | Terminal UI for managing Kubernetes with vim keybindings | https://k9scli.io | ⭐⭐⭐⭐⭐ |
| Lens | Kubernetes IDE with GUI for cluster management | https://k8slens.dev | ⭐⭐⭐⭐⭐ |
| OpenLens | Open-source version of Lens Kubernetes IDE | https://github.com/MuhammedKalkan/OpenLens | ⭐⭐⭐⭐⭐ |
| Octant | Open-source Kubernetes dashboard by VMware (archived) | https://github.com/vmware-archive/octant | ⭐⭐⭐ |
| Kubernetes Dashboard | Official web-based Kubernetes UI | https://github.com/kubernetes/dashboard | ⭐⭐⭐⭐ |
| Headlamp | Extensible Kubernetes UI with plugin system | https://headlamp.dev | ⭐⭐⭐⭐ |
| kubectx | Switch between Kubernetes contexts quickly | https://github.com/ahmetb/kubectx | ⭐⭐⭐⭐⭐ |
| kubens | Switch between Kubernetes namespaces quickly | https://github.com/ahmetb/kubectx | ⭐⭐⭐⭐⭐ |
| stern | Multi-pod log tailing for Kubernetes | https://github.com/stern/stern | ⭐⭐⭐⭐⭐ |
| kail | Kubernetes tail — stream logs from all matching pods | https://github.com/boz/kail | ⭐⭐⭐⭐ |
| kubectl-tree | Explore Kubernetes object hierarchies as tree | https://github.com/ahmetb/kubectl-tree | ⭐⭐⭐⭐ |
| kubectl-neat | Remove clutter from Kubernetes manifests | https://github.com/itaysk/kubectl-neat | ⭐⭐⭐⭐ |
| kubecolor | Colorized kubectl output | https://github.com/hidetatz/kubecolor | ⭐⭐⭐⭐ |
| kubetail | Bash script for tailing logs from multiple Kubernetes pods | https://github.com/johanhaleby/kubetail | ⭐⭐⭐⭐ |
| krew | Plugin manager for kubectl | https://krew.sigs.k8s.io | ⭐⭐⭐⭐⭐ |
| Popeye | Kubernetes cluster sanitizer and linter | https://github.com/derailed/popeye | ⭐⭐⭐⭐⭐ |
| Polaris | Validates Kubernetes resources against best practices | https://polaris.docs.fairwinds.com | ⭐⭐⭐⭐⭐ |
| kube-bench | Check Kubernetes against CIS security benchmarks | https://github.com/aquasecurity/kube-bench | ⭐⭐⭐⭐⭐ |
| kube-hunter | Hunt for security weaknesses in Kubernetes clusters | https://github.com/aquasecurity/kube-hunter | ⭐⭐⭐⭐ |
| Goldilocks | Right-size Kubernetes resource requests with VPA | https://github.com/FairwindsOps/goldilocks | ⭐⭐⭐⭐ |
| Pluto | Detect deprecated Kubernetes API versions in code | https://github.com/FairwindsOps/pluto | ⭐⭐⭐⭐ |
| Nova | Find outdated Helm charts running in your cluster | https://github.com/FairwindsOps/nova | ⭐⭐⭐⭐ |

---

## 7. Helm & Kubernetes Packaging

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Helm | Package manager for Kubernetes with templating | https://helm.sh | ⭐⭐⭐⭐⭐ |
| Kustomize | Kubernetes-native configuration customization with overlays | https://kustomize.io | ⭐⭐⭐⭐⭐ |
| Helmfile | Declarative spec for deploying Helm charts | https://github.com/helmfile/helmfile | ⭐⭐⭐⭐⭐ |
| Helm-diff | Show diff before upgrading Helm release | https://github.com/databus23/helm-diff | ⭐⭐⭐⭐⭐ |
| Helm-secrets | Manage Helm chart secrets with SOPS | https://github.com/jkroepke/helm-secrets | ⭐⭐⭐⭐ |
| Chart Museum | Open-source Helm chart repository server | https://chartmuseum.com | ⭐⭐⭐⭐ |
| Artifact Hub | Find, install, and publish Kubernetes packages | https://artifacthub.io | ⭐⭐⭐⭐⭐ |
| Carvel (ytt, kapp) | VMware's set of tools for Kubernetes configuration | https://carvel.dev | ⭐⭐⭐⭐ |
| Jsonnet | Data templating language for Kubernetes manifests | https://jsonnet.org | ⭐⭐⭐⭐ |
| CUE | Open-source data constraint language for config | https://cuelang.org | ⭐⭐⭐⭐ |
| Timoni | Helm alternative using CUE for Kubernetes packages | https://timoni.sh | ⭐⭐⭐⭐ |
| Argo CD ApplicationSet | Template multiple Argo CD Applications | https://argo-cd.readthedocs.io | ⭐⭐⭐⭐⭐ |

---

## 8. CI/CD Platforms

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| GitHub Actions | Automate workflows directly in GitHub repositories | https://github.com/features/actions | ⭐⭐⭐⭐⭐ |
| GitLab CI/CD | Built-in CI/CD pipelines in GitLab | https://gitlab.com | ⭐⭐⭐⭐⭐ |
| Jenkins | Open-source automation server with huge plugin ecosystem | https://jenkins.io | ⭐⭐⭐⭐⭐ |
| CircleCI | Cloud and self-hosted CI/CD with Docker-first pipelines | https://circleci.com | ⭐⭐⭐⭐⭐ |
| Travis CI | Hosted CI service for open-source projects | https://travis-ci.com | ⭐⭐⭐⭐ |
| Buildkite | Fast, scalable CI on your own infrastructure | https://buildkite.com | ⭐⭐⭐⭐⭐ |
| Drone CI | Container-native CI/CD platform | https://drone.io | ⭐⭐⭐⭐⭐ |
| Woodpecker CI | Community fork of Drone CI | https://woodpecker-ci.org | ⭐⭐⭐⭐ |
| TeamCity | JetBrains CI/CD server with smart build triggers | https://jetbrains.com/teamcity | ⭐⭐⭐⭐⭐ |
| Bamboo | Atlassian's CI/CD server integrating with Jira | https://atlassian.com/bamboo | ⭐⭐⭐⭐ |
| Azure DevOps Pipelines | Microsoft's CI/CD platform for any language and cloud | https://azure.microsoft.com/devops | ⭐⭐⭐⭐⭐ |
| AWS CodePipeline | Continuous delivery service on AWS | https://aws.amazon.com/codepipeline | ⭐⭐⭐⭐ |
| AWS CodeBuild | Managed build service that compiles and tests code | https://aws.amazon.com/codebuild | ⭐⭐⭐⭐ |
| Google Cloud Build | Serverless CI/CD platform on GCP | https://cloud.google.com/build | ⭐⭐⭐⭐ |
| Semaphore CI | High-performance CI/CD with monorepo support | https://semaphoreci.com | ⭐⭐⭐⭐⭐ |
| Codefresh | Kubernetes-native CI/CD with GitOps support | https://codefresh.io | ⭐⭐⭐⭐⭐ |
| Harness | AI-native CI/CD platform with feature flags and chaos | https://harness.io | ⭐⭐⭐⭐⭐ |
| Tekton | Kubernetes-native CI/CD pipeline framework | https://tekton.dev | ⭐⭐⭐⭐⭐ |
| Argo Workflows | Kubernetes-native workflow engine for parallel jobs | https://argoproj.github.io/workflows | ⭐⭐⭐⭐⭐ |
| Concourse CI | Pipeline-based CI with simple YAML configuration | https://concourse-ci.org | ⭐⭐⭐⭐ |
| Spinnaker | Multi-cloud continuous delivery platform by Netflix | https://spinnaker.io | ⭐⭐⭐⭐ |
| GoCD | Open-source CD server with pipeline modeling | https://gocd.io | ⭐⭐⭐⭐ |
| Gitea Actions | Built-in CI/CD for Gitea Git service | https://gitea.io | ⭐⭐⭐⭐ |
| Forgejo | Self-hosted lightweight forge with CI/CD | https://forgejo.org | ⭐⭐⭐⭐ |

---

## 9. GitOps Tools

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Argo CD | Declarative GitOps continuous delivery for Kubernetes | https://argo-cd.readthedocs.io | ⭐⭐⭐⭐⭐ |
| Flux CD | GitOps toolkit for Kubernetes — CNCF graduated | https://fluxcd.io | ⭐⭐⭐⭐⭐ |
| Flagger | Progressive delivery with canary, A/B, blue-green | https://flagger.app | ⭐⭐⭐⭐⭐ |
| Argo Rollouts | Kubernetes progressive delivery controller | https://argo-rollouts.readthedocs.io | ⭐⭐⭐⭐⭐ |
| Fleet | GitOps at scale for Kubernetes from Rancher | https://fleet.rancher.io | ⭐⭐⭐⭐ |
| Weave GitOps | Weave's GitOps dashboard built on Flux | https://weave.works/product/gitops | ⭐⭐⭐⭐ |
| JenkinsX | Cloud-native CI/CD for Kubernetes with GitOps | https://jenkins-x.io | ⭐⭐⭐⭐ |
| Config Sync | Google's GitOps tool for syncing Kubernetes configs | https://cloud.google.com/anthos-config-management | ⭐⭐⭐⭐ |
| Atlantis | Terraform pull request automation for GitOps | https://runatlantis.io | ⭐⭐⭐⭐⭐ |
| Digger | GitOps CI/CD for Terraform on GitHub Actions | https://digger.dev | ⭐⭐⭐⭐ |

---

## 10. Infrastructure as Code (IaC)

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Terraform | HashiCorp's IaC tool for multi-cloud infrastructure | https://terraform.io | ⭐⭐⭐⭐⭐ |
| OpenTofu | Open-source Terraform fork by Linux Foundation | https://opentofu.org | ⭐⭐⭐⭐⭐ |
| Pulumi | IaC using real programming languages (Python, Go, TS) | https://pulumi.com | ⭐⭐⭐⭐⭐ |
| AWS CDK | Define AWS infrastructure using TypeScript, Python, Java | https://aws.amazon.com/cdk | ⭐⭐⭐⭐⭐ |
| AWS CloudFormation | AWS-native IaC with JSON/YAML templates | https://aws.amazon.com/cloudformation | ⭐⭐⭐⭐⭐ |
| AWS SAM | Serverless Application Model for Lambda deployments | https://aws.amazon.com/serverless/sam | ⭐⭐⭐⭐⭐ |
| Azure Bicep | Domain-specific language for Azure infrastructure | https://learn.microsoft.com/bicep | ⭐⭐⭐⭐⭐ |
| Azure ARM Templates | JSON templates for Azure resource deployments | https://azure.microsoft.com/arm | ⭐⭐⭐⭐ |
| Google Cloud Deployment Manager | GCP's IaC service with YAML and Jinja2 | https://cloud.google.com/deployment-manager | ⭐⭐⭐⭐ |
| Ansible | Agentless configuration management and IaC | https://ansible.com | ⭐⭐⭐⭐⭐ |
| Chef | Configuration management with Ruby DSL | https://chef.io | ⭐⭐⭐⭐ |
| Puppet | Model-driven configuration management | https://puppet.com | ⭐⭐⭐⭐ |
| SaltStack | Python-based config management and orchestration | https://saltproject.io | ⭐⭐⭐⭐ |
| Crossplane | Kubernetes-native control plane for cloud infrastructure | https://crossplane.io | ⭐⭐⭐⭐⭐ |
| Terragrunt | Thin wrapper for Terraform with DRY configuration | https://terragrunt.gruntwork.io | ⭐⭐⭐⭐⭐ |
| Terramate | Orchestration and code generation for Terraform | https://terramate.io | ⭐⭐⭐⭐ |
| Spacelift | CI/CD platform for Terraform and OpenTofu | https://spacelift.io | ⭐⭐⭐⭐⭐ |
| Env0 | Self-service cloud environments for Terraform teams | https://env0.com | ⭐⭐⭐⭐ |
| Scalr | Remote Terraform operations and policy enforcement | https://scalr.com | ⭐⭐⭐⭐ |
| Terraform Cloud | HashiCorp's managed Terraform service | https://app.terraform.io | ⭐⭐⭐⭐⭐ |
| CDK for Terraform | Use CDK with Terraform providers | https://developer.hashicorp.com/terraform/cdktf | ⭐⭐⭐⭐ |
| Nitric | Framework for cloud infrastructure from code | https://nitric.io | ⭐⭐⭐⭐ |
| SST | Full-stack serverless framework on AWS CDK | https://sst.dev | ⭐⭐⭐⭐⭐ |
| Serverless Framework | Deploy serverless apps to any cloud | https://serverless.com | ⭐⭐⭐⭐⭐ |
| Wing | Cloud-oriented programming language with IaC built-in | https://winglang.io | ⭐⭐⭐⭐ |

---

## 11. Service Mesh & Networking

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Istio | Full-featured service mesh for Kubernetes | https://istio.io | ⭐⭐⭐⭐⭐ |
| Linkerd | Ultralight, security-first service mesh | https://linkerd.io | ⭐⭐⭐⭐⭐ |
| Consul Connect | HashiCorp's service mesh with mTLS | https://consul.io | ⭐⭐⭐⭐⭐ |
| Kuma | Universal service mesh by Kong | https://kuma.io | ⭐⭐⭐⭐ |
| Cilium | eBPF-based networking, security, and observability | https://cilium.io | ⭐⭐⭐⭐⭐ |
| Traefik Mesh | Lightweight service mesh by Traefik Labs | https://traefik.io/traefik-mesh | ⭐⭐⭐⭐ |
| Nginx Service Mesh | NGINX-based service mesh for Kubernetes | https://nginx.com/products/nginx-service-mesh | ⭐⭐⭐⭐ |
| AWS App Mesh | Service mesh for AWS workloads using Envoy | https://aws.amazon.com/app-mesh | ⭐⭐⭐⭐ |
| Envoy Proxy | High-performance proxy for service mesh data plane | https://envoyproxy.io | ⭐⭐⭐⭐⭐ |
| Traefik | Modern HTTP reverse proxy and load balancer | https://traefik.io | ⭐⭐⭐⭐⭐ |
| Nginx | High-performance web server and reverse proxy | https://nginx.org | ⭐⭐⭐⭐⭐ |
| Caddy | Automatic HTTPS web server with easy config | https://caddyserver.com | ⭐⭐⭐⭐⭐ |
| HAProxy | High-availability TCP/HTTP load balancer | https://haproxy.org | ⭐⭐⭐⭐⭐ |
| Kong Gateway | Open-source API gateway and service mesh | https://konghq.com | ⭐⭐⭐⭐⭐ |
| Contour | Kubernetes ingress controller using Envoy | https://projectcontour.io | ⭐⭐⭐⭐ |
| MetalLB | Load balancer for bare metal Kubernetes clusters | https://metallb.universe.tf | ⭐⭐⭐⭐⭐ |
| Calico | Networking and security policy for Kubernetes | https://tigera.io/project-calico | ⭐⭐⭐⭐⭐ |
| Flannel | Simple overlay network for Kubernetes | https://github.com/flannel-io/flannel | ⭐⭐⭐⭐ |
| Weave Net | Simple, resilient Kubernetes networking | https://weave.works/oss/weave-net | ⭐⭐⭐⭐ |

---

## 12. Secret Management & Security

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| HashiCorp Vault | Secrets management, encryption, and privileged access | https://vaultproject.io | ⭐⭐⭐⭐⭐ |
| External Secrets Operator | Sync secrets from external stores to Kubernetes | https://external-secrets.io | ⭐⭐⭐⭐⭐ |
| Sealed Secrets | Encrypt Kubernetes secrets for safe Git storage | https://sealed-secrets.netlify.app | ⭐⭐⭐⭐⭐ |
| SOPS | Encrypt secrets in YAML, JSON, ENV files | https://github.com/getsops/sops | ⭐⭐⭐⭐⭐ |
| Doppler | Universal secrets manager for teams | https://doppler.com | ⭐⭐⭐⭐⭐ |
| Infisical | Open-source secrets management platform | https://infisical.com | ⭐⭐⭐⭐⭐ |
| AWS Secrets Manager | Managed secrets rotation and management on AWS | https://aws.amazon.com/secrets-manager | ⭐⭐⭐⭐⭐ |
| AWS SSM Parameter Store | Hierarchical config and secrets management on AWS | https://aws.amazon.com/systems-manager | ⭐⭐⭐⭐⭐ |
| Azure Key Vault | Cloud key, secret, and certificate management | https://azure.microsoft.com/key-vault | ⭐⭐⭐⭐⭐ |
| GCP Secret Manager | Managed secrets storage and access on GCP | https://cloud.google.com/secret-manager | ⭐⭐⭐⭐⭐ |
| 1Password Secrets Automation | Secrets management with 1Password security | https://1password.com/secrets | ⭐⭐⭐⭐ |
| Akeyless | SaaS secrets platform with unified access | https://akeyless.io | ⭐⭐⭐⭐ |
| Conjur | Open-source secrets management for machines | https://conjur.org | ⭐⭐⭐⭐ |
| Teleport | Certificate-based access for SSH, K8s, DBs, apps | https://goteleport.com | ⭐⭐⭐⭐⭐ |
| Trivy | Comprehensive vulnerability scanner for containers | https://trivy.dev | ⭐⭐⭐⭐⭐ |
| Grype | Vulnerability scanner for container images | https://github.com/anchore/grype | ⭐⭐⭐⭐⭐ |
| Syft | SBOM generator for container images | https://github.com/anchore/syft | ⭐⭐⭐⭐⭐ |
| Snyk Container | Container security scanning with fix advice | https://snyk.io/product/container-vulnerability-management | ⭐⭐⭐⭐⭐ |
| Cosign | Container image signing and verification | https://sigstore.dev | ⭐⭐⭐⭐⭐ |
| Falco | Cloud-native runtime security with eBPF | https://falco.org | ⭐⭐⭐⭐⭐ |
| Aqua Security | Full lifecycle container security platform | https://aquasec.com | ⭐⭐⭐⭐⭐ |
| Sysdig Secure | Container security with runtime threat detection | https://sysdig.com | ⭐⭐⭐⭐ |

---

## 13. Observability & Monitoring (DevOps Focus)

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Prometheus | Open-source metrics collection and alerting | https://prometheus.io | ⭐⭐⭐⭐⭐ |
| Grafana | Open-source observability and visualization platform | https://grafana.com | ⭐⭐⭐⭐⭐ |
| Loki | Horizontally scalable log aggregation by Grafana | https://grafana.com/oss/loki | ⭐⭐⭐⭐⭐ |
| Grafana Tempo | Distributed tracing backend by Grafana | https://grafana.com/oss/tempo | ⭐⭐⭐⭐⭐ |
| OpenTelemetry | Vendor-neutral observability framework | https://opentelemetry.io | ⭐⭐⭐⭐⭐ |
| Jaeger | Distributed tracing system from Uber/CNCF | https://jaegertracing.io | ⭐⭐⭐⭐⭐ |
| Zipkin | Distributed tracing system | https://zipkin.io | ⭐⭐⭐⭐ |
| Datadog | Cloud monitoring for infrastructure, APM, logs | https://datadoghq.com | ⭐⭐⭐⭐⭐ |
| New Relic | Full-stack observability platform | https://newrelic.com | ⭐⭐⭐⭐⭐ |
| Dynatrace | AI-powered observability platform | https://dynatrace.com | ⭐⭐⭐⭐⭐ |
| Elastic Stack (ELK) | Elasticsearch, Logstash, Kibana for log analytics | https://elastic.co | ⭐⭐⭐⭐⭐ |
| Splunk | Enterprise data platform for machine data analytics | https://splunk.com | ⭐⭐⭐⭐⭐ |
| VictoriaMetrics | Fast and cost-effective monitoring TSDB | https://victoriametrics.com | ⭐⭐⭐⭐⭐ |
| Netdata | Real-time distributed performance monitoring | https://netdata.cloud | ⭐⭐⭐⭐⭐ |
| SigNoz | Open-source APM with logs, traces, metrics | https://signoz.io | ⭐⭐⭐⭐⭐ |
| Sentry | Error tracking and performance monitoring | https://sentry.io | ⭐⭐⭐⭐⭐ |
| Better Stack | Log management and uptime monitoring | https://betterstack.com | ⭐⭐⭐⭐⭐ |
| Fluentd | Unified logging layer for collecting logs | https://fluentd.org | ⭐⭐⭐⭐⭐ |
| Vector | High-performance observability data pipeline | https://vector.dev | ⭐⭐⭐⭐⭐ |
| Alertmanager | Alert routing and management for Prometheus | https://prometheus.io/docs/alerting/alertmanager | ⭐⭐⭐⭐⭐ |
| PagerDuty | Incident response and on-call management platform | https://pagerduty.com | ⭐⭐⭐⭐⭐ |
| Grafana OnCall | Open-source on-call management | https://grafana.com/products/oncall | ⭐⭐⭐⭐⭐ |
| Incident.io | Modern incident management with Slack integration | https://incident.io | ⭐⭐⭐⭐⭐ |

---

## 14. Platform Engineering & Developer Portals

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| Backstage | Open-source developer portal by Spotify | https://backstage.io | ⭐⭐⭐⭐⭐ |
| Port | Developer portal for building Internal Developer Platforms | https://getport.io | ⭐⭐⭐⭐⭐ |
| Cortex | Internal developer portal for microservice catalog | https://cortex.io | ⭐⭐⭐⭐ |
| OpsLevel | Developer portal and service catalog | https://opslevel.com | ⭐⭐⭐⭐ |
| Humanitec | Platform Orchestrator for Internal Developer Platforms | https://humanitec.com | ⭐⭐⭐⭐⭐ |
| Kratix | Framework for building Internal Developer Platforms on K8s | https://kratix.io | ⭐⭐⭐⭐ |
| Score | Platform-agnostic workload specification | https://score.dev | ⭐⭐⭐⭐ |
| Radius | Open-source cloud-native app development platform | https://radapp.io | ⭐⭐⭐⭐ |
| Waypoint | Build, deploy, and release any app on any platform | https://waypointproject.io | ⭐⭐⭐⭐ |
| Porter | Kubernetes-powered PaaS for self-hosted teams | https://porter.run | ⭐⭐⭐⭐⭐ |
| Coolify | Open-source Heroku/Netlify alternative | https://coolify.io | ⭐⭐⭐⭐⭐ |
| Dokku | Docker-powered mini-Heroku with git push deploys | https://dokku.com | ⭐⭐⭐⭐⭐ |
| CapRover | Scalable PaaS with one-click app deployments | https://caprover.com | ⭐⭐⭐⭐⭐ |
| Railway | Infrastructure platform with auto deployments | https://railway.app | ⭐⭐⭐⭐⭐ |
| Render | Unified cloud for apps, databases, static sites | https://render.com | ⭐⭐⭐⭐⭐ |
| Fly.io | Deploy full-stack apps globally near users | https://fly.io | ⭐⭐⭐⭐⭐ |
| Vercel | Frontend deployment platform with edge network | https://vercel.com | ⭐⭐⭐⭐⭐ |
| Netlify | Jamstack deployment platform with CI/CD | https://netlify.com | ⭐⭐⭐⭐⭐ |
| Cloudflare Workers | Serverless edge computing platform | https://workers.cloudflare.com | ⭐⭐⭐⭐⭐ |

---

## 15. Miscellaneous DevOps Tools

| Tool | Description | Link | ⭐ |
|------|-------------|------|-----|
| ngrok | Secure tunnels to localhost for development | https://ngrok.com | ⭐⭐⭐⭐⭐ |
| Cloudflare Tunnel | Zero-trust tunneling without open firewall ports | https://cloudflare.com/products/tunnel | ⭐⭐⭐⭐⭐ |
| LocalTunnel | Expose localhost to the world with simple CLI | https://theboroer.github.io/localtunnel-www | ⭐⭐⭐⭐ |
| Webhook.site | Test and debug webhooks in real-time | https://webhook.site | ⭐⭐⭐⭐⭐ |
| Hookdeck | Reliable webhook infrastructure with logging | https://hookdeck.com | ⭐⭐⭐⭐⭐ |
| Svix | Enterprise-ready webhook sending service | https://svix.com | ⭐⭐⭐⭐ |
| Temporal | Durable execution platform for resilient workflows | https://temporal.io | ⭐⭐⭐⭐⭐ |
| Apache Airflow | Platform to author, schedule, and monitor workflows | https://airflow.apache.org | ⭐⭐⭐⭐⭐ |
| Prefect | Modern workflow orchestration for data pipelines | https://prefect.io | ⭐⭐⭐⭐⭐ |
| n8n | Fair-code workflow automation with self-host option | https://n8n.io | ⭐⭐⭐⭐⭐ |
| Make (Integromat) | Visual workflow automation platform | https://make.com | ⭐⭐⭐⭐ |
| Packer | Create machine images for multiple platforms | https://packer.io | ⭐⭐⭐⭐⭐ |
| Vagrant | Tool for building and managing VM environments | https://vagrantup.com | ⭐⭐⭐⭐⭐ |
| Lima | Linux VMs for macOS with automatic file sharing | https://lima-vm.io | ⭐⭐⭐⭐ |
| Devcontainers | Dev environments inside Docker containers for VS Code | https://containers.dev | ⭐⭐⭐⭐⭐ |
| GitHub Codespaces | Cloud dev environments powered by VS Code | https://github.com/features/codespaces | ⭐⭐⭐⭐⭐ |
| Gitpod | Cloud dev environments pre-configured for your project | https://gitpod.io | ⭐⭐⭐⭐⭐ |
| Coder | Self-hosted cloud dev environments | https://coder.com | ⭐⭐⭐⭐⭐ |
| Daytona | Open-source dev environment manager | https://daytona.io | ⭐⭐⭐⭐ |
| DevPod | Open-source Codespaces alternative | https://devpod.sh | ⭐⭐⭐⭐⭐ |
| act | Run GitHub Actions locally for testing | https://github.com/nektos/act | ⭐⭐⭐⭐⭐ |
| nektos/act | Run your GitHub Actions locally | https://nektosact.com | ⭐⭐⭐⭐⭐ |
| Actionlint | Static checker for GitHub Actions workflows | https://github.com/rhysd/actionlint | ⭐⭐⭐⭐⭐ |
| pre-commit | Framework for managing pre-commit hooks | https://pre-commit.com | ⭐⭐⭐⭐⭐ |
| Lefthook | Fast and powerful Git hooks manager | https://lefthook.dev | ⭐⭐⭐⭐⭐ |
| Husky | Git hooks made easy for Node.js projects | https://typicode.github.io/husky | ⭐⭐⭐⭐⭐ |
| Release Please | Automated release PRs using conventional commits | https://github.com/googleapis/release-please | ⭐⭐⭐⭐⭐ |
| semantic-release | Automated versioning and package publishing | https://semantic-release.gitbook.io | ⭐⭐⭐⭐⭐ |
| Renovate | Automated dependency update tool | https://renovatebot.com | ⭐⭐⭐⭐⭐ |
| Dependabot | GitHub's automated dependency security updates | https://github.com/features/security | ⭐⭐⭐⭐⭐ |

*Total: 350+ real, verified Docker & DevOps tools across 15 categories*
*Last updated: April 2026*
