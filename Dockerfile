FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
      git \
      keyboard-configuration \
      software-properties-common \
      sudo && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/dontmissthepoint/linux-setup

COPY . .

RUN ./install.sh --unattended --docker && \
    rm -rf /var/lib/apt/lists/*

CMD ["bash"]
