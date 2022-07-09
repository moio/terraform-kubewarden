# terraform-kubewarden

Quickly creates local ([k3d](https://k3d.io)-based) test beds for Kubewarden.

Light on hardware, ready in minutes, and all you need is `terraform` and `docker`!

## Requirements
 - `docker` ([Rancher Desktop](https://rancherdesktop.io/) recommended on non-Linux)
 - [terraform](https://www.terraform.io/downloads)

## Quick start

```
cd terraform-kubewarden
terraform init
terraform apply -auto-approve
```

That will create one container wrapping a Kubernetes cluster. Here Kubewarden is installed, together with the sample [kubewarden-palindrome-policy](https://github.com/moio/kubewarden-palindrome-policy) policy.

Feel free to use [k9s](https://k9scli.io/) to inspect results.

As soon as the `ClusterAdmissionPolicy` is `active`, you can see it will deny creation of pods with palindrome label keys:

```shell
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: palindrome-label-key-pod
  labels:
    hannah: eve
spec:
  containers:
    - name: nginx
      image: nginx:latest
EOF

Error from server: error when creating "STDIN": admission webhook "clusterwide-palindrome-label-key-pods.kubewarden.admission" denied the request: The 'palindrome-label-key-pod' pod has a palindrome label key: hannah
```

### Quick operations

- Destroy everything: `terraform destroy -auto-approve`
- Hard destroy everything (if Terraform fails): `rm terraform.tfstate ; k3d cluster delete --all`
- Hard recreate everything from scratch:

```sh
rm terraform.tfstate ; k3d cluster delete --all; terraform init; terraform apply -auto-approve
```
