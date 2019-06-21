FROM golang:1.12.6-alpine
LABEL io.prinsmike.maintainer "Michael Prinsloo <github.com/prinsmike>"

ARG UID
ARG GID
ARG USER
ARG GROUP

ENV GO111MODULE on

RUN apk update && \
	apk add sudo bash git mercurial openssh ca-certificates && \
	addgroup -Sg ${GID:-5000} ${GROUP:-golang} && \
	adduser -Su ${UID:-5000} ${USER:-golang} -G ${GROUP:-golang} && \
	sed -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' \
	-i /etc/sudoers

USER ${USER:-golang}
WORKDIR /go/src/app

CMD [ "./build.sh" ]


