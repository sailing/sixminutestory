# Sixminutestory

## TODO
- [x] narrow prompt params
- [x] narrow prompt form
- [x] narrow prompt list
- [x] narrow story form
- [x] narrow story list

- [ ] add pagination to both lists
- [ ] new route /write
	- [ ] optional parent_story id
	- [ ] optional prompt id
- [ ] story to_param
- [ ] on new story, random prompt if no prompt_id (in controller)
- [ ] on new story, pass prompt_id in hidden field
- [ ] on new story, pass parent_story_id in hidden field
- [ ] migrate all "firstline" prompt :refcode to :firstline

__User and Auth__
- [ ] create users
- [ ] how to auth?
- [ ] cancan or other? admin in an entirely different app / ActiveAdmin?


## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [Heroku Local]:

    % heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
