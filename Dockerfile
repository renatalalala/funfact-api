FROM ruby

COPY Gemfile* .
RUN bundle install
COPY *.rb .
COPY config.ru .

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:80"]
