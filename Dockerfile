FROM ubuntu:latest
LABEL authors="jackson"

ENTRYPOINT ["top", "-b"]