ARG GO_VERSION=1.21.6
ARG TERRAFORM_VERSION=1.6
ARG COMMAND=build
ARG TERRAFORM_PROVIDER_PROXMOX_VERSION

FROM docker.io/golang:${GO_VERSION}

CMD mkdir /app
COPY .. /app
WORKDIR /app
CMD mkdir -p bin
RUN make $TERRAFORM_PROVIDER_PROXMOX_VERSION

FROM docker.io/hashicorp/terraform:${TERRAFORM_VERSION}


CMD mkdir -p /root/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/$TERRAFORM_PROVIDER_PROXMOX_VERSION/linux_amd64
COPY --from=0 /app/bin/terraform-provider-proxmox /root/.terraform.d/plugins/registry.terraform.io/telmate/proxmox/$TERRAFORM_PROVIDER_PROXMOX_VERSION/linux_amd64/terraform-provider-proxmox

ENTRYPOINT ["terraform"]