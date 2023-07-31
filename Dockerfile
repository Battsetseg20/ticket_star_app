FROM ruby:2.7.5

ENV BUNDLER_VERSION=2.3.14

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn

RUN gem install bundler -v 2.3.14

WORKDIR /app

COPY Gemfile* ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY package.json yarn.lock ./

RUN yarn install --version 1.22.19

COPY . ./

EXPOSE 3000

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

