FROM alpine:3
RUN apk add git

COPY run.sh ./
CMD ["./run.sh"]
