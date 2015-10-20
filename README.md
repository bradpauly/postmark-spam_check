# Postmark::SpamCheck

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/postmark/spam_check`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'postmark-spam_check'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install postmark-spam_check

## Usage

Give it a raw email and an optional format and timeout.

```ruby
Postmark::SpamCheck.check(raw_email, report_format = :long, timeout = 60)
```

You can get a raw email by calling #to_s on a Mail object.

```ruby
mail = Mail.new do
  from     "bill.lumbergh@example.net"
  to       "peter.gibbons@example.com"
  subject  "TPS reports"
  body     "Peter, What's happening? Yeah, about those TPS reports. Did you get the memo?"
end

Postmark::SpamCheck.check(mail.to_s)

=> #<Postmark::SpamCheck::Report:0x007fd61e189970
 @details=
  [{:points=>-0.0, :rule=>"NO_RELAYS", :description=>"Informational: message was not relayed via SMTP"},
   {:points=>-0.0, :rule=>"NO_RECEIVED", :description=>"Informational: message has no Received headers"}],
 @email=
  "Date: Mon, 19 Oct 2015 16:50:00 -0700\r\nFrom: bill.lumbergh@example.net\r\nTo: peter.gibbons@example.com\r\nMessage-ID: <562581a848336_c663feb09065bec23540@venus.local.mail>\r\nSubject: TPS reports\r\nMime-Version: 1.0\r\nContent-Type: text/plain;\r\n charset=UTF-8\r\nContent-Transfer-Encoding: 7bit\r\n\r\nPeter, What's happening? Yeah, about those TPS reports. Did you get the memo?",
 @error=nil,
 @score="-0.0">
 ```

If you don't want the details, call with :short format instead. This will only fetch the score.

```ruby
Postmark::SpamCheck.check(mail.to_s, :short)

=> #<Postmark::SpamCheck::Report:0x007fd61e080088
 @details=[],
 @email=
  "Date: Mon, 19 Oct 2015 16:50:00 -0700\r\nFrom: bill.lumbergh@example.net\r\nTo: peter.gibbons@example.com\r\nMessage-ID: <562581a848336_c663feb09065bec23540@venus.local.mail>\r\nSubject: TPS reports\r\nMime-Version: 1.0\r\nContent-Type: text/plain;\r\n charset=UTF-8\r\nContent-Transfer-Encoding: 7bit\r\n\r\nPeter, What's happening? Yeah, about those TPS reports. Did you get the memo?",
 @error=nil,
 @score="0.0">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bradpauly/postmark-spam_check. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
