FROM ruby:3.2.2
WORKDIR /app
COPY . .
RUN bundle install
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
