require "postmark/spam_check/client"
require "postmark/spam_check/report"
require "postmark/spam_check/version"

module Postmark
  module SpamCheck
    def self.check(raw_email, report_format = :long, timeout = 60)
      self.client(timeout).check(raw_email, report_format)
    end

    def self.client(timeout)
      Postmark::SpamCheck::Client.new(timeout)
    end
  end
end
