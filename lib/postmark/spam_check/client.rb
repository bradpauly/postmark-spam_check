require 'net/http'
require 'json'
require 'uri'

# The Client is responsible for making requests to the remote API. It doesn't
# know about the format of the results, only that it is JSON and passes
# the parsed result to the Report, which will handle the rest.
module Postmark
  module SpamCheck
    class Client
      SPAM_CHECK_URI = "http://spamcheck.postmarkapp.com/filter"

      def initialize(timeout = 60)
        @timeout = timeout
      end

      def check(raw_email, report_format = :long)
        report = SpamCheck::Report.new(raw_email)
        result = fetch_report(raw_email, report_format)
        report.load_results(result)
      rescue StandardError => error
        report.error = error.message || error.inspect
        report
      end

    private
      def fetch_report(raw_email, report_format)
        response = http_request({email: raw_email, options: report_format})
        JSON.parse(response.body)
      end

      def http_request(params)
        uri = URI.parse(SPAM_CHECK_URI)
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = @timeout
        request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json'})
        request.body = params.to_json
        http.request(request)
      end
    end
  end
end
