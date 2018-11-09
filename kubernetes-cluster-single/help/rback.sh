#!/usr/bin/env bash
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.069617   34985 storage_rbac.go:131] Created clusterrole.rbac.authorization.k8s.io/admin
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.076862   34985 storage_rbac.go:131] Created clusterrole.rbac.authorization.k8s.io/edit
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.083000   34985 storage_rbac.go:131] Created clusterrole.rbac.authorization.k8s.io/view
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.089183   34985 storage_rbac.go:131] Created clusterrole.rbac.authorization.k8s.io/system:node
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.114054   34985 storage_rbac.go:131] Created clusterrole.rbac.authorization.k8s.io/system:node-proxier
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.118303   34985 storage_rbac.go:131] Created clusterrole.rbac.authorization.k8s.io/system:controller:replication-controller
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.145141   34985 storage_rbac.go:151] Created clusterrolebinding.rbac.authorization.k8s.io/cluster-admin
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.169733   34985 storage_rbac.go:151] Created clusterrolebinding.rbac.authorization.k8s.io/system:discovery
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.177027   34985 storage_rbac.go:151] Created clusterrolebinding.rbac.authorization.k8s.io/system:basic-user
Nov 09 13:21:07 ninja kube-apiserver[34985]: I1109 13:21:07.185922   34985 storage_rbac.go:151] Created clusterrolebinding.rbac.authorization.k8s.io/system:node
Created symlink from /etc/systemd/system/multi-user.target.wants/kube-controller-manager.service to /usr/lib/systemd/system/kube-controller-manager.service.