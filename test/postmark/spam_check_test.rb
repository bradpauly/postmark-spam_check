require 'test_helper'

class Postmark::SpamCheckTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Postmark::SpamCheck::VERSION
  end

  def test_it_does_something_useful
    assert true # Right?
  end

  def test_check_returns_a_report
    # Don't make the request.
    client = Postmark::SpamCheck::Client.new
    def client.fetch_report(a, b) {}; end

    Postmark::SpamCheck.stub(:client, client) do
      report = Postmark::SpamCheck.check("testing")
      assert_instance_of Postmark::SpamCheck::Report, report
    end
  end
end
