# Use the official Ruby image
FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libpq-dev

# Set the working directory
WORKDIR /myapp

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Precompile assets
#RUN rails assets:precompile

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
