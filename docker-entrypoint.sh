#!/bin/bash

set -e

adduser --disabled-password --gecos "" "${SSH_USER}" \
	&& mkdir "/home/${SSH_USER}/.ssh/" \
	&& echo "${SSH_KEY}" >> "/home/${SSH_USER}/.ssh/authorized_keys" \
	&& cp "/run/secrets/$DOCKER_HOST_KEY" "/home/${SSH_USER}/.ssh/" \
	&& mv "/db_backup-env-new.sh" "/home/${SSH_USER}/" \
	&& env | grep _ >> /etc/environment \
	&& chown -R "${SSH_USER}":"${SSH_USER}" "/home/${SSH_USER}" "/opt/"

exec "$@"
