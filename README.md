## Sample Application like twitter

* this web app is for Rails Tutorial

* a simple twitter-like web application

## Library versions

* Ruby version: 2.5.3

* Rails version: 5.2.1

* mysql version: 5.7

## Usage

### local dev environment

```
$ bundle install
# or set vendor path with `--path=vendor/bundle`

$ bundle exec rails db:create

$ bundle exec rails db:migrate

# (optional)
$ bundle exec rails db:seed
```

and

```
$ bundle exec rails s
```

### docker environment

Please be sure to install docker for your local environment.

```
$ docker-compose up
```
