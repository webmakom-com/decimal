FROM ubuntu

RUN apt-get update \
    && apt-get -y install curl

RUN curl -v https://get.starport.network/starport! | bash

# Run onomyd by default, omit entrypoint to ease using container with onomycli
CMD ["starport"]