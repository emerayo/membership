# Memberships

## CI Status

[![Ruby on Rails CI](https://github.com/emerayo/membership/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/emerayo/membership/actions/workflows/rubyonrails.yml)

## System dependencies

* PostgreSQL 14.0+
* Ruby 3.2.2
* Redis 7.2.4

## Setup with Docker

### Setting up the containers

Download and setup containers:

```shell
$ docker compose up -d
```

For the convenience, this app has a Makefile
to make it easier to run commands related to Docker
If you need with the Make commands, run:

```shell
$ make help
```

Using Make:

```shell
$ make containers.up
```

To stop the containers:

```shell
$ docker compose down -v
```

Using Make:

```shell
$ make containers.down
```

### Installing gems

When setting up the containers, the gems should be already installed. If you change the Gemfile, run:

```shell
$ docker compose up -d
```
Using Make:

```shell
$ make bundle
```

### Setting up the database

To setup the database and run migrations:

```shell
$ docker compose run web rails db:create db:setup
```
Using Make:

```shell
$ make db.setup
```

### Attaching to the container

To attach the console to the container:

```shell
$ docker compose run web bash
```

Using Make:

```shell
$ make console
```

To exit the container:

```shell
$ exit
```

### Checking CPU and Memory usage:

```shell
$ docker stats
```

Using Make:

```shell
$ make containers.stats
```

## Setup without Docker

Copy the `sample.env` file:

```shell
$ cp sample.env .env
```

Now open `.env` file and make sure database environment variables are correct for your environment (use your Postgres configuration).

Install all gems and create the development and test databases:

```shell
$ bundle install
$ bin/rails db:setup
```

## Running the server

To run the server locally, run the command:

```shell
$ rails s
```

You can stop the server by pressing:

```
CTRL + C
```

## Running the tests

With Docker:

```shell
$ docker compose run web bundle exec rspec
```

Using Make:

```shell
$ make tests
```

Without Docker:

```shell
$ bundle exec rspec
```

### Checking code coverage for the project

After running `rspec`, it will generate a file in `coverage/index.html` containing the test results,
simply open it on a browser to check the coverage.

## Linter

This project uses Rubocop as linter

To run it with Docker:


```shell
$ docker compose run web bundle exec rubocop
```

Using Make:

```shell
$ make rubocop
```

To fix the issues automatically:

```shell
$ docker compose run web bundle exec rubocop -A
```

Using Make:

```shell
$ make rubocop.fix
```

## Committing

This project uses [Overcommit](https://github.com/sds/overcommit), a gem that run some checks before allowing you to commit your changes.
Such as RuboCop, TrailingWhitespace and Brakeman.

Install Overcommit hooks:

```shell
$ overcommit --sign
$ overcommit --install
```

Now you can commit.

## Troubleshooting

This project is using Redis as caching, if you believe your caching is not working properly, follow this steps to ensure it's working:

```shell
$ rails c
```

Now, test if Rails is caching the values correctly:
```ruby
> Rails.cache.write("test-key", 123)
=> true
> Rails.cache.read("test-key")
=> 123
```

If the response from `Rails.cache.read("test-key")` is `nil`, it means that your cache is not working.

To fix it, run this command:

```shell
$ rails dev:cache
```

You should see the message:
```
Development mode is now being cached.
```
