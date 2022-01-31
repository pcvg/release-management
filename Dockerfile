FROM alpine/git:v2.32.0
RUN apk add --no-cache curl jq bash
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
