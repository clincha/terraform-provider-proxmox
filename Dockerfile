FROM docker.io/golang:1.21.6

CMD mkdir /app
COPY . /app
WORKDIR /app
CMD mkdir -p bin
RUN make build

FROM docker.io/hashicorp/terraform:1.6

CMD mkdir -p /root/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/linux_amd64
COPY --from=0 /app/bin/terraform-provider-proxmox /root/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/linux_amd64/terraform-provider-proxmox

COPY entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]