FROM bitwalker/alpine-elixir:1.7.4 as build

COPY . .

#Install dependencies and build Release
RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix deps.get && \
    mix release

#Extract Release archive to /rel for copying in next stage
RUN APP_NAME="firehose" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

#================
#Deployment Stage
#================
FROM pentacent/alpine-erlang-base:latest

#Set environment variables and expose port
EXPOSE 8080
ENV REPLACE_OS_VARS=true \
    PORT=8080

#Copy and extract .tar.gz Release file from the previous stage
COPY --from=build /export/ .

USER default

ENTRYPOINT ["/opt/app/bin/firehose"]
CMD ["foreground"]
