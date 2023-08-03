.PHONY: install_kind install_kubectl \
	create_kind_cluster create_docker_registry connect_registry_to_kind_network \
	connect_registry_to_kind create_kind_cluster_with_registry delete_kind_cluster \
	delete_docker_registry install_app uninstall_app build_docker_image \
	install_nginx_ingress clean run_end_to_end

install_kind:
	if ./kind --version | grep -q 'kind version'; \
	then echo "---> kind already installed; skipping"; \
	else curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-darwin-arm64 && \
      chmod +x ./kind && \
	    ./kind --version; \
	fi 

install_kubectl: 
	if kubectl version --output=yaml | grep -q 'clientVersion'; \
	then echo "---> kubectl already installed; skipping"; \
	else brew install kubectl; \
	fi

install_helm: 
	if helm version | grep -q 'version'; \
	then echo "---> helm already installed; skipping"; \
	else brew install helm; \
	fi

create_docker_registry:
	if docker ps | grep -q 'local-registry'; \
	then echo "---> local-registry already created; skipping"; \
	else docker run --name local-registry -d --restart=always -e REGISTRY_HTTP_ADDR=0.0.0.0:5001 -p 5001:5001 registry:2; \
	fi

create_kind_cluster: install_kind install_kubectl create_docker_registry
	kind create cluster --name check-pod-status --config kind_config.yml || true && \
	  kubectl get nodes

connect_registry_to_kind_network:
	docker network connect kind local-registry || true

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f kind_configmap.yml

create_kind_cluster_with_registry:
	$(MAKE) create_kind_cluster && $(MAKE) connect_registry_to_kind

build_docker_image:
	docker build -t check-pod-status . && \
	  docker tag check-pod-status 127.0.0.1:5001/check-pod-status && \
	    docker push 127.0.0.1:5001/check-pod-status 

install_app: install_helm build_docker_image install_nginx_ingress
	helm upgrade --atomic --install check-pod-status ./chart

# Run end-to-end
run_end_to_end:
	$(MAKE) create_kind_cluster_with_registry && $(MAKE) install_app

# Clean up
delete_docker_registry: 
	docker stop local-registry && docker rm local-registry

delete_kind_cluster: delete_docker_registry
	kind delete cluster --name check-pod-status

uninstall_app:
	helm uninstall check-pod-status

clean:
	$(MAKE) uninstall_app || true && $(MAKE) delete_kind_cluster