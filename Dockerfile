# i think this file doesn't get run from anywhere other than being pasted in at azure
# https://tailscale.com/kb/1126/azure-app-services/

#FROM alpine:latest as builder
#WORKDIR /app
#COPY . ./
# This is where one could build the application code as well.


FROM alpine:latest as tailscale
WORKDIR /app
COPY . ./
ENV TSFILE=tailscale_1.28.0_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1
COPY . ./
COPY /app/start.sh /app/


FROM alpine:latest
RUN apk update && apk add ca-certificates bash sudo && rm -rf /var/cache/apk/*

# Azure allows SSH access to the container. This isn't needed for Tailscale to
# operate, but is really useful for debugging the application.
RUN apk add openssh openssh-keygen openssl && echo "root:Docker!" | chpasswd
RUN apk add netcat-openbsd
RUN mkdir -p /etc/ssh
COPY /app/sshd_config /etc/ssh/
#RUN adduser -h /home/sshuser -s /bin/sh -D sshuser && adduser sshuser wheel && echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
#RUN echo sshuser:$(openssl rand -base64 32) | chpasswd
#COPY /app/id_rsa.pub /home/sshuser/.ssh/authorized_keys
COPY /app/root_rsa.pub /home/root/.ssh/authorized_keys
#RUN chown -R sshuser:sshuser /home/sshuser/.ssh
#RUN chmod 644 /home/sshuser/.ssh/authorized_keys
RUN chmod 644 /home/root/.ssh/authorized_keys
EXPOSE 2222

# Copy binary to production image
COPY --from=tailscale /app/start.sh /app/start.sh
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Run on container startup.
CMD ["/app/start.sh"]
#az container create --name cheapappcontainer --resource-group rg-prod --image sophware01/tsbastion:0.0.7 --vnet vnet-prod --subnet snet-aci --subnet-address-prefix 10.0.220.0/24  --environment-variables "TAILSCALE_AUTHKEY=deadbeef" "UP_FLAGS=--login-server=https://headscale.com --advertise-routes=172.16.0.0/24 --hostname tsbastion" --restart-policy Never --ports 2222 --cpu 1 --memory 1