---
layout: default
title:  "SORM"
date:   2013-06-19 19:09:11
---

[![Build Status](https://travis-ci.org/iliabylich/sorm.png?branch=master)](https://travis-ci.org/iliabylich/sorm)
[![Code Climate](https://codeclimate.com/github/iliabylich/sorm.png)](https://codeclimate.com/github/iliabylich/sorm)
[![Coverage Status](https://coveralls.io/repos/iliabylich/sorm/badge.png)](https://coveralls.io/r/iliabylich/sorm)
[![Dependency Status](https://gemnasium.com/iliabylich/sorm.png)](https://gemnasium.com/iliabylich/sorm)
[![Gem Version](https://badge.fury.io/rb/sorm.png)](https://rubygems.org/gems/sorm)

# SORM

Ruby ORM with [sdbm](http://www.ruby-doc.org/stdlib-2.0/libdoc/sdbm/rdoc/SDBM.html) as a data storage

## Installation

Add this line to your application's Gemfile:

    gem 'sorm'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sorm

## Configuration

First of all, require it in your source code (if you are not using Rails)

{% highlight ruby %}

require 'sorm'

{% endhighlight %}

{% highlight ruby %}

SORM.configure do |config|
  config.storage_config = {
    database: "/tmp/path_to_your_db"
  }
end

{% endhighlight %}

## Definition

{% highlight ruby %}

class Person < SORM::Model
  attribute :first_name
  attribute :last_name
end

{% endhighlight %}

## Base usage

{% highlight ruby %}

p = Person.new(first_name: "Krokodil", last_name: "Gena")
=> #<Person:instance @first_name="Krokodil", @last_name="Gena", @sorm_id=nil>

p.save
=> true

Person.create(first_name: "Krokodil")
=> #<Person:instance @first_name="Krokodil", @last_name=nil, @sorm_id="some-long-generated-id">

{% endhighlight %}

## Validatation

+ Presence

{% highlight ruby %}

class Person < SORM::Model
  attribute :name

  validate :name, presence: true
end

Person.new.valid?
=> false

Person.new.errors
=> { name: "Can't be blank" }

{% endhighlight %}

+ Uniquiness

{% highlight ruby %}

class Person < SORM::Model
  attribute :name

  validate :name, uniq: true
end

Person.create(name: "Gena")
=> true
Person.create(name: "Gena")
=> false
Person.new(name: "Gena").valid?
=> false
Person.new(name: "Gena").errors
=> { name: "Should be uniq" }

{% endhighlight %}

+ Custom validation

{% highlight ruby %}

class Person < SORM::Model
  attribute :name

  validate :name do |record|
    record.name =~ "Gena"
  end
end

Person.create(name: "Gena")
=> true
Person.create(name: "Vasya")
=> false
Person.new(name: "Vasya").valid?
=> false
Person.new(name: "Vasya").errors
=> { name: "Validation block returns false-value" }

{% endhighlight %}

## Associations

+ One-to-one

{% highlight ruby %}

class User < SORM::Model
  has_one :profile, class: "Profile"
end

class Profile < SORM::Model
  belongs_to :user, class: "User"
end

u = User.create
=> #<User:instance @sorm_id="some-user-id">
Profile.create(user_id: u.sorm_id)
=> #<Profile:instance @sorm_id="some-profile-id", @user_id="some-user-id">
u.profile
=> #<Profile:instance @sorm_id="some-profile-id", @user_id="some-user-id">

{% endhighlight %}

+ One-to-many

{% highlight ruby %}

class Profile < SORM::Model
  has_many :companies, class: "Company"
end

class Company < SORM::Model
  belongs_to :profile, class: "Profile"
end

p = Profile.create
=> #<Profile:instance @sorm_id="some-profile-id">
Company.create(profile_id: p.sorm_id)
=> #<Company:instance @sorm_id="some-company-id", @profile_id="some-profile-id">
Company.create(profile_id: p.sorm_id)
=> #<Company:instance @sorm_id="some-company-id2", @profile_id="some-profile-id">
p.companies
=> [
  #<Company:instance @sorm_id="some-company-id", @profile_id="some-profile-id">,
  #<Company:instance @sorm_id="some-company-id2", @profile_id="some-profile-id">
]

{% endhighlight %}

## API

{% highlight ruby %}
# class-methods
Profile.first
=> #<Profile:instance ... >
Profile.last
=> #<Profile:instance ... >
Profile.find("some-sorm-id")
=> #<Profile:instance @sorm_id="some-sorm-id" ... >
Profile.where(name: "Gena")
=> [#<Profile:instance @name="Gena" ...>, #<Profile:instance @name="Gena" ... >]
Profile.count
=> 10

# instance-methods
p = Profile.create(name: "Gena")
=> #<Profile:instance @name="Gena", @sorm_id="some-generated-id">

p.update(name: "Vasya")
=> #<Profile:instance @name="Vasya", @sorm_id="some-generated-id">
{% endhighlight %}

## Documentation

Your can also check documentation for [SORM](http://rubydoc.info/gems/sorm/1.0.0/frames).

## Testing

SORM has [100% coverage](https://coveralls.io/r/iliabylich/sorm) for 1.9.2, 1.9.3, 2.0.0 and rbx (you can check [Travis](https://travis-ci.org/iliabylich/sorm))
It doesn't work on jruby (because jruby don't have sdbm)

## Dependencies

SORM has [no](https://gemnasium.com/iliabylich/sorm) dependencies. It was written on pure Ruby.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request