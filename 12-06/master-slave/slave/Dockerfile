FROM postgres:17

COPY setup-replica.sh /usr/local/bin
RUN chmod +x /usr/local/bin/setup-replica.sh

ENTRYPOINT [ "/usr/local/bin/setup-replica.sh" ]
CMD [ "postgres" ]