FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y wireguard iproute2 iptables && \
    apt-get clean

COPY ./wireguard/server.conf /etc/wireguard/server.conf

RUN echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]

