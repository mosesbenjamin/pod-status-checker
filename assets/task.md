You are to build a Python/Java based Kubernetes Service that looks for pods that are in a designated status state. Status should be a parameter to this program, passed in via environment variable POD_STATUS and can be one of: Terminating, Error, Completed, Running or CreateContainerConfigError. The program should produce a table listing of all pods in the specified state.

Step 1 - Program Development
Build and debug the program using an IDE (Visual Studio Code or something else). To test your program you can use Kind, K3s or any other Kubernetes that you are currently connected to.

Step 2 - Containerize
Build a Dockerfile for your program.

Step 3 - Deploy your Container
Deploy your container (preferably using Helm) into your cluster. This can be either a K8s Job, Deployment or Pod.
