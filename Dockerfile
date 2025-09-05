# Use official Ruby image
FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  git \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install gems first (better caching)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy rest of the app
COPY . .

# Set Rails environment
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV PORT=8080

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose Railway's port
EXPOSE 8080

# Start Puma (bind to 0.0.0.0 so Railway can reach it)
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "tcp://0.0.0.0:${PORT}"]
