FROM jenkins/jenkins:lts
MAINTAINER 4oh4

# Derived from https://github.com/getintodevops/jenkins-withdocker (miiro@getintodevops.com)

USER root

# Install the latest Docker CE binaries and add user `jenkins` to the docker group
RUN apt-get update && \
	apt-get -y --no-install-recommends install shellcheck apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		software-properties-common \
		jq && \
	install -m 0755 -d /etc/apt/keyrings && \
	curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
	chmod a+r /etc/apt/keyrings/docker.asc && \
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list && \
	apt-get update && \
	apt-get -y --no-install-recommends install docker-ce docker-buildx-plugin docker-compose-plugin && \
	usermod -aG docker jenkins
   
# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    rm nodesource_setup.sh && \
    apt install -y nodejs

# Clean up
RUN apt-get clean

# drop back to the regular jenkins user - good practice
USER jenkins
