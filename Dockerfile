FROM ruby

COPY Gemfile* .
RUN bundle install
COPY *.rb .
COPY config.ru .

ENTRYPOINT ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:4567"]
