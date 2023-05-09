FROM ubuntu

EXPOSE 22

RUN apt update -y --no-install-recommends && \
 apt install -y openssh-server libpam-google-authenticator && \
 apt remove python3.10 -yqq && \
 apt-get autoremove -yqq --purge  && \
 apt-get clean && \
 rm -rf /var/lib/apt/lists/* && \
 rm -rf /var/cache/apt/archives/*


RUN adduser user && \
 mkdir /home/user/.ssh && \
 touch /home/user/.ssh/authorized_keys && \
 chown -R user:user /home/user/.ssh && \
 chmod 555 /etc/ssh/ssh_host* && \
 echo "welcome to bastion-host" > /etc/motd && \
 usermod user -s /sbin/nologin




RUN mkdir -p /etc/pam.d
COPY ./sshd_config /etc/ssh/sshd_config
COPY ./sshd_pam /etc/pam.d/sshd


COPY --chown=user:user ./id_ed25519.pub /home/user/.ssh/authorized_keys

# Setting up entrypoint.
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod o+x /entrypoint.sh

USER user

CMD ["/entrypoint.sh"]
