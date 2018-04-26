# grafana-oauth-openshift

Inspired by https://github.com/mrsiano/openshift-grafana

Grafana is not provided as an official Red Hat OpenShift Docker Image. This repository is providing a Docker Image built on the basis of Grafana 5.x and can be used in OpenShift to be deployed as a Dashboard for Prometheus.

The OpenShift Prometheus data source requires a Token for the access. In the official Prometheus Plugin for Grafana there is no Token access implemented. The Token can be added to the Plugin and enables Grafana to connect to Prometheus in an OpenShift Cluster.

# Build

Clone this repository:
`https://github.com/kilimandjango/grafana-oauth-openshift.git`

Switch to the folder and build the appropriate Dockerfile. There is one for CentOS and one for RHEL (For RHEL your system needs to be registered at the RHSM).
`docker build . openshift/grafana:latest`

Login to the Docker Registry and push the Docker Image:
`docker push openshift/grafana:latest`

In OpenShift there is automatically an ImageStream created which can be used in the Deployment.

# Deployment

There is a setup shell script provided to setup Grafana in OpenShift. The arguments are the datasource name, the namespace where Prometheus is deployed and if OAuth shall be used:
`./setup-grafana.sh prometheus-ds openshift-metrics true`

# Configuration of the Prometheus data source

- Open the Grafana GUI in OpenShift Web Console and add a new Prometheus data source.

- Check `server` as the access option.

- Check out the TLS checkbox.

- In the shell grab the management token:
`oc sa get-token management-admin -n management-infra`

- Paste the token into the Token field.

- Save and Test -> There should be a message that the datasource was successfully connected!

You can now create or import a Dashboard!
