FROM quay.io/ansible/awx:18.0.0

WORKDIR /tmp

USER root

#RUN curl -sSL https://sdk.cloud.google.com | bash
#ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
#
#RUN dnf -y update && \
#  dnf -y install gcc && \
#  dnf -y clean all

# Install kubectl
#RUN curl -L -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
#  chmod a+x /usr/bin/kubectl

# Install helm
#RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
#  chmod 700 get_helm.sh && \
#  ./get_helm.sh

# Install Azure-Cli
#RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
#COPY azure-cli.repo /etc/yum.repos.d/azure-cli.repo
#RUN yum -y update \
#  && yum -y install azure-cli

RUN dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

RUN dnf -y install terraform

#RUN yes | pip3 uninstall ansible

#RUN pip3 install ansible

RUN pip3 install botocore boto3 kubernetes openshift

USER 1000

RUN ansible-galaxy collection install community.kubernetes community.aws community.aws

#CMD ["/bin/sh" "-c" "/usr/bin/launch_awx_task.sh"]
