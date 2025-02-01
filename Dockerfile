FROM amd64/ubuntu:22.04
RUN apt-get update && apt-get install -y sudo git unzip openssh-client curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

ADD https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz runner.tar.gz

RUN newuser=runner && \
    adduser --disabled-password --gecos "" $newuser && \
    usermod -aG sudo $newuser && \
    echo "$newuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER runner
WORKDIR /home/

RUN sudo mv /runner.tar.gz ./runner.tar.gz && \
    sudo chown runner:runner ./runner.tar.gz && \
    tar xzf runner.tar.gz -C runner && \
    sudo rm runner.tar.gz
WORKDIR /home/runner

RUN sudo /home/runner/bin/installdependencies.sh

COPY self-hosted-runner-start.sh ./self-hosted-runner-start.sh

RUN sudo chmod +x self-hosted-runner-start.sh

ENTRYPOINT ["/home/runner/self-hosted-runner-start.sh"]