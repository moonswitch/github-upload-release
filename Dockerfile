FROM golang:1.11

LABEL "com.github.actions.name"="Github Upload Release"
LABEL "com.github.actions.description"="Upload artifact(s) to a Github Release"
LABEL "com.github.actions.icon"="upload"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="http://github.com/moonswitch/github-upload-release"
LABEL "homepage"="http://github.com/moonswitch/github-upload-release"
LABEL "maintainer"="Moonswitch <hello@moonswitch.com>"

RUN \
  apt-get update && \
  apt-get install -y ca-certificates openssl zip && \
  update-ca-certificates && \
  rm -rf /var/lib/apt && \
  go get -u github.com/tcnksm/ghr

ENTRYPOINT [ "ghr" ]
CMD ["$(echo $GITHUB_REF | cut -d'/' -f3')","$GITHUB_WORKSPACE/.release"]