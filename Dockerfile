FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /posts
WORKDIR /posts
COPY Gemfile /posts/Gemfile
COPY Gemfile.lock /posts/Gemfile.lock
RUN gem install bundler
RUN bundle install

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]