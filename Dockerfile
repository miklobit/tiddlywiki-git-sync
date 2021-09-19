FROM alpine:3
RUN apk add git

VOLUME /wiki
COPY run.sh ./
ENTRYPOINT ["./run.sh"]
CMD ["--single"]
