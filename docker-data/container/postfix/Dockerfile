FROM debian:jessie

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postfix

COPY syslog-stdout.py /usr/local/bin/syslog-stdout.py
COPY start.sh /start.sh
RUN chmod 755 /start.sh

ENV USE_SYSLOG 1

# Use syslog-ng to get Postfix logs (rsyslog uses upstart which does not seem
# to run within Docker).
RUN apt-get install -y syslog-ng syslog-ng-core
# Replace the system() source because inside Docker we can't access /proc/kmsg.
# https://groups.google.com/forum/#!topic/docker-user/446yoB0Vx6w
RUN     sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf
# Uncomment 'SYSLOGNG_OPTS="--no-caps"' to avoid the following warning:
# syslog-ng: Error setting capabilities, capability management disabled; error='Operation not permitted'
# http://serverfault.com/questions/524518/error-setting-capabilities-capability-management-disabled
RUN     sed -i 's/^#\(SYSLOGNG_OPTS="--no-caps"\)/\1/g' /etc/default/syslog-ng

ENTRYPOINT ["/start.sh"]
EXPOSE 25/tcp
