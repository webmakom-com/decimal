# Simple usage with a mounted data directory:
# > docker build -t onomy .
# > docker run -it -p 46657:46657 -p 46656:46656 -v ~/.onomy:/onomy/.onomy onomy onomyd init
# > docker run -it -p 46657:46657 -p 46656:46656 -v ~/.onomy:/onomy/.onomy onomy onomyd start
FROM golang:1.16-alpine AS build-env

# Set up dependencies
ENV PACKAGES bash curl make git libc-dev bash gcc linux-headers eudev-dev python3

# Install minimum necessary dependencies, install Starport, remove packages
RUN apk add --no-cache $PACKAGES
RUN curl -v https://get.starport.network/starport | bash

RUN ls /usr/local/bin

# Final image
FROM alpine:edge

ENV onomy /onomy

# Install ca-certificates
RUN apk add --update ca-certificates apt-get

RUN RUN apt-get update && \
      apt-get -y install sudo

RUN useradd -m onomy && echo "onomy:onomy" | chpasswd && adduser onomy sudo

USER onomy

WORKDIR $onomy

# Copy over binaries from the build-env
COPY --from=build-env /go/starport /usr/bin/starport

RUN sudo chmod +x /usr/bin/starport

# Run onomyd by default, omit entrypoint to ease using container with onomycli
CMD ["starport"]