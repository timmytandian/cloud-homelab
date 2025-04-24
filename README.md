# Cloud Homelab DevOps Project

This project creates a cloud-based homelab environment using AWS, OpenTofu, Ansible, Kubernetes, and Flux GitOps.

## Architecture

- 1 Admin/Control Node: Manages the infrastructure and deployment
- 1 Kubernetes Control Plane Node: Runs the Kubernetes control plane components
- 2 Kubernetes Worker Nodes: Run the actual workloads

## Prerequisites

- AWS account with appropriate permissions
- OpenTofu or Terraform installed
- Ansible installed
- kubectl installed
- Git installed
- GitHub account for Flux GitOps

## Setup Instructions

### 1. Infrastructure Provisioning

1. Navigate to the terraform directory:
   ```
   cd terraform
   ```

2. Copy the example variables file and edit it:
   ```
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Initialize and apply the Terraform configuration:
   ```
   tofu init
   tofu apply
   ```

### 2. Kubernetes Cluster Setup

1. Navigate to the ansible directory:
   ```
   cd ../ansible
   ```

2. Update the variables in `group_vars`:
   ```
   vi group_vars/all.yml
   ```

3. Run the Ansible playbook:
   ```
   ansible-playbook -i inventory/hosts.ini playbooks/bootstrap-kubernetes.yml
   ```

### 3. Configure Flux GitOps

1. Create a GitHub personal access token with repo permissions

2. Set the required variables in `group_vars/all.yml`:
   ```yaml
   flux_github_owner: "your-github-username"
   flux_github_repo: "your-flux-gitops-repo"
   flux_github_token: "your-github-token"
   ```

3. Run the Flux setup playbook:
   ```
   ansible-playbook -i inventory/hosts.ini playbooks/setup-flux.yml
   ```

## Managing Applications

After the setup is complete, you can manage your applications by:

1. Cloning the Flux GitOps repository
2. Adding your application manifests to the `kubernetes/apps/` directory
3. Committing and pushing changes to the repository

Flux will automatically detect and apply the changes to your cluster.

## Accessing the Cluster

To access your Kubernetes cluster from your local machine, you can copy the kubeconfig file from the control node:

```
scp ubuntu@<control-node-ip>:/etc/kubernetes/admin.conf ~/.kube/config
```

Remember to replace `<control-node-ip>` with the actual IP address of your control node.

## Troubleshooting

If you encounter issues, check:

1. AWS Console to verify all instances are running
2. SSH into the nodes to check logs:
   ```
   journalctl -u kubelet
   ```
3. On the control node, check if all nodes are ready:
   ```
   kubectl get nodes
   ```

## Clean Up

To destroy the infrastructure when you're done:

```
cd terraform
tofu destroy
```
