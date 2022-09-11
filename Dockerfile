ARG RUBY_VERSION="3.1.2-alpine"
FROM ruby:${RUBY_VERSION} AS builder

ARG BUNDLER_VERSION="2.3.13"
ARG RAILS_ENV="production"
ARG RAILS_LOG_TO_STDOUT=true

RUN apk -U upgrade && apk add --no-cache \
   postgresql-dev nodejs yarn build-base

WORKDIR /app

COPY Gemfile Gemfile.lock ./

ENV LANG=C.UTF-8 \
   BUNDLE_JOBS=4 \
   BUNDLE_RETRY=3 \
   BUNDLE_PATH='vendor/bundle'

RUN gem install bundler:${BUNDLER_VERSION} --no-document \
   && bundle config set --without 'development test' \
   && bundle install --quiet \
   && rm -rf $GEM_HOME/cache/*

COPY . ./

############################################################
FROM ruby:${RUBY_VERSION}

ARG RAILS_ENV="production"
ARG RAILS_LOG_TO_STDOUT=true

RUN apk -U upgrade && apk add --no-cache libpq netcat-openbsd tzdata\
   && rm -rf /var/cache/apk/* \
   && adduser --disabled-password app-user
# --disabled-password: don't assign a pwd, so cannot login
USER app-user

COPY --from=builder --chown=app-user /app /app

ENV RAILS_ENV=$RAILS_ENV \
   BUNDLE_PATH='vendor/bundle' \
   RAILS_LOG_TO_STDOUT=$RAILS_LOG_TO_STDOUT

WORKDIR /app
RUN rm -rf node_modules

EXPOSE 3000

ENTRYPOINT ["/app/bin/docker-entrypoint-web"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
