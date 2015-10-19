require 'test_helper'

class Postmark::SpamCheck::ClientTest < Minitest::Test
  def test_check_returns_a_report
    client = Postmark::SpamCheck::Client.new
    client.stub :fetch_report, {} do
      report = client.check('foo')
      assert_instance_of Postmark::SpamCheck::Report, report
    end
  end

  def test_handles_short_report_format
    client = Postmark::SpamCheck::Client.new
    client.stub :fetch_report, {'success' => true, 'score' => '1.2'} do
      report = client.check('foo', :short)
      assert_equal report.score, '1.2'
      assert_empty report.details
    end
  end

  def test_traps_exceptions_and_returns_report
    funky_exception = ->(a, b) { raise StandardError, 'funky error' }
    client = Postmark::SpamCheck::Client.new
    client.stub :fetch_report, funky_exception do
      report = client.check('foo')
      assert_instance_of Postmark::SpamCheck::Report, report
    end
  end

  def test_sets_error_on_report
    funky_exception = ->(a, b) { raise StandardError, 'funky error' }
    client = Postmark::SpamCheck::Client.new
    client.stub :fetch_report, funky_exception do
      report = client.check('foo')
      assert_equal 'funky error', report.error
    end
  end

  def test_handles_non_json_response
    Struct.new("UnexpectedResponse", :body)
    broken_response = Struct::UnexpectedResponse.new("_<NOT_'JSON>:''_")

    client = Postmark::SpamCheck::Client.new
    client.stub :http_request, broken_response do
      report = client.check('foo')
      refute_nil report.error
    end
  end

  def test_handles_connection_timeout
    timeout_exception = ->(a) { raise Net::ReadTimeout }
    client = Postmark::SpamCheck::Client.new(0.1)
    client.stub :http_request, timeout_exception do
      report = client.check('foo')
      assert_equal "Net::ReadTimeout", report.error
    end
  end
end
