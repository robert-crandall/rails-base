FROM ruby:3.1.2

RUN gem update --system

# use a global path instead of vendor
ENV GEM_HOME="/usr/local/bundle"
ENV BUNDLE_PATH="$GEM_HOME"
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH="$GEM_HOME/bin:$BUNDLE_PATH/gems/bin:${PATH}"

# make 'docker logs' work
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /app

COPY Gemfile* ./

RUN bundle install

ARG RAILS_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}"

COPY . .

CMD ["/app/bin/start"]
