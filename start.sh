#!/bin/bash

adduser --disabled-password --gecos "" ${SSH_USER} \
	&& mkdir "/home/${SSH_USER}/.ssh/" \
	&& echo "${SSH_KEY}" >> "/home/${SSH_USER}/.ssh/authorized_keys"

/usr/sbin/sshd -D
