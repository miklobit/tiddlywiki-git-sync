FROM node:14.4.0-alpine3.12
RUN apk add git

COPY run.sh ./
CMD ["./run.sh"]
