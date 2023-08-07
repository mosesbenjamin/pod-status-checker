import os
from kubernetes import client, config
from tabulate import tabulate
from typing import List, Tuple

VALID_STATUSES = ["Terminating", "Error", "Completed", "Running", "CreateContainerConfigError"]

def get_pods_in_status(pod_status: str) -> List[Tuple[str, str, str]]:
     # Check if the script is running inside a Kubernetes Pod
    in_cluster = os.environ.get("KUBERNETES_SERVICE_HOST") is not None

    if in_cluster:
        config.load_incluster_config()  # Load Kubernetes in-cluster config
    else:
        config.load_kube_config()  # Load Kubernetes config from kubeconfig file

    v1 = client.CoreV1Api()

    field_selector = f"status.phase={pod_status}"
    pods_list = []

    try:
        pods = v1.list_pod_for_all_namespaces(field_selector=field_selector)
        for idx, pod in enumerate(pods.items, 1):
            namespace = pod.metadata.namespace
            name = pod.metadata.name
            status = pod.status.phase
            pods_list.append((idx, namespace, name, status))
    except Exception as e:
        raise Exception(f"Error: {e}")

    return pods_list

if __name__ == "__main__":
    pod_status = os.environ.get("POD_STATUS")

    if pod_status not in VALID_STATUSES:
        print(f"""
                ########################################################
                Invalid POD_STATUS: {pod_status}. Using default: Running.
                ########################################################
        """)
        pod_status = "Running"

    pods = get_pods_in_status(pod_status)

    headers = ["No.", "Namespace", "Name", "Status"]
    print(tabulate(pods, headers=headers))
