FROM ubuntu:20.04

ENV NOTVISIBLE "in users profile"

RUN apt-get -y update \
	&& apt-get install -y openssh-server \
	mysql-client \
	curl \
	&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
	&& apt-get install -y nodejs \
	&& npm install -g slack-cli \
	&& mkdir /var/run/sshd \
	&& sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& mkdir /root/.ssh/ \
	&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
	&& echo "export VISIBLE=now" >> /etc/profile \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY db_backup-env-new.sh /
COPY docker-entrypoint.sh /

EXPOSE 22
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
