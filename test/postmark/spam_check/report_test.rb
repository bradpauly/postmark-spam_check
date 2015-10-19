require 'test_helper'

class Postmark::SpamCheck::ReportTest < Minitest::Test
  def test_takes_raw_email_input
    report = Postmark::SpamCheck::Report.new("raw email")
  end

  def test_no_details_for_short_format
    report = Postmark::SpamCheck::Report.new("raw email")
    report.load_results('success' => true, 'score' => '1.2')
    assert_empty report.details
  end

  def test_parses_spamassassin_report
    report = Postmark::SpamCheck::Report.new("raw email")
    report.load_results('success' => true, 'score' => '1.2', 'report' => test_spamassassin_report)
    refute_empty report.details
  end

  def test_parses_spamassassin_report_correctly
    report = Postmark::SpamCheck::Report.new("testing")
    report.load_results('success' => true, 'score' => '7.9', 'report' => testing_spamassassin_report)
    # TODO: Better way to check, this is fragile.
    assert_equal 'MISSING_FROM', report.details[5][:rule]
  end

  def test_handles_unexpected_report_format
    report = Postmark::SpamCheck::Report.new("raw email")
    report.load_results('success' => true, 'score' => '1.2', 'report' => "WAT\nWAT\nWAT\r\nWAT\nWAT\r\nWAT\r\n")
    assert_equal report.score, '1.2'
    assert_empty report.details
    refute_nil report.error
  end

  def test_error_message_on_failure
    error_message = 'report failure'
    report = Postmark::SpamCheck::Report.new("raw email")
    report.load_results('success' => false, 'message' => error_message)
    assert_equal error_message, report.error
  end

  def test_has_access_to_email
    error_message = 'report failure'
    report = Postmark::SpamCheck::Report.new("raw email")
    assert_equal "raw email", report.email
  end
end
