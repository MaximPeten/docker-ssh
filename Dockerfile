FROM ubuntu:latest

ENV NOTVISIBLE "in users profile"

RUN apt-get -y update \
	&& apt-get install -y openssh-server \
	mysql-client \
	&& mkdir /var/run/sshd \
	&& sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& mkdir /root/.ssh/ \
	&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
	&& echo "export VISIBLE=now" >> /etc/profile

COPY start.sh /

EXPOSE 22
ENTRYPOINT /start.sh
