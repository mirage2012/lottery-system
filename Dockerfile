FROM golang:1.14.6 as builder

WORKDIR /go/src/github.com/mirage2012/lottery-system
COPY src/    src/
COPY Makefile Makefile

RUN make build

FROM alpine:3.14.2

ARG BUILD_DATE
ARG NAME
ARG VERSION
ARG ORGANIZATION
ARG VCS_REF
ARG MAINTAINER

LABEL build-date="${BUILD_DATE}"
LABEL name="${NAME}"
LABEL version="${VERSION}"
LABEL vendor="${ORGANIZATION}"
LABEL vcs-ref="${VCS_REF}"
LABEL maintainer="${MAINTAINER}"

RUN apk --no-cache add ca-certificates
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
COPY --from=builder /go/src/github.com/mirage2012/lottery-system/build/linux/lottery-system .
ENTRYPOINT ["/lottery-system"]