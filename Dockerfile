############################################################
# Dockerfile to build devbox 
############################################################

# Start with f5-cli
FROM f5devcentral/f5-cli:latest

LABEL maintainer "jarrod@f5.com"

# Add Required APKs
 RUN apk add curl
# Current f5-cli now has PIP installed

# Upgrade pip
RUN pip install --upgrade pip

# Add required pip packages
RUN pip install bigsuds f5-sdk paramiko netaddr deepdiff ansible-lint ansible-review openshift google-auth boto jmespath

# Setup various users and passwords
RUN adduser -h /home/tfdevbox -u 1000 -s /bin/bash tfdevbox -D
RUN echo 'tfdevbox:default' | chpasswd
RUN echo 'root:default' | chpasswd

# Expose SSH 
EXPOSE 22 

# Install google cloud sdk
RUN echo "----Installing Google Cloud SDK----" && \
     curl -sSL https://sdk.cloud.google.com | bash 
ENV PATH $PATH:/root/google-cloud-sdk/bin

# Install aws cloud sdk
RUN echo "----Installing AWS Cloud SDK----" && \
     curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
     && unzip awscli-bundle.zip \
     && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# Install azure sdk
RUN echo "----Installing Azure Cloud SDK----" && \
     pip install azure-cli

# Install ansible and required libraries
RUN echo "----Installing Ansible----"  && \
    pip install ansible

# Set the Terraform and Terragrunt image versions
ENV TERRAFORM_VERSION=0.12.25
ENV TERRAGRUNT_VERSION=v0.23.18

# Install Terraform
RUN echo "----Installing Terraform----"  && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip  && \
    rm -f terraform_${TERRAFORM_VERSION}_SHA256SUMS

# Install Terragrunt
RUN echo "----Installing Terragrunt----"  && \
    wget -O terragrunt_${TERRAGRUNT_VERSION}_linux_amd64 https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x terragrunt_${TERRAGRUNT_VERSION}_linux_amd64 && \
    cp terragrunt_${TERRAGRUNT_VERSION}_linux_amd64 /usr/bin/terragrunt && \
    rm -f terragrunt_${TERRAGRUNT_VERSION}_linux_amd64