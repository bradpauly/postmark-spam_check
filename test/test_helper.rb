$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'postmark/spam_check'

require 'minitest/autorun'

def test_spamassassin_report
  text = <<END
 pts rule name               description
---- ---------------------- --------------------------------------------------
 0.0 FREEMAIL_FROM          Sender email is commonly abused enduser mail provider
                            (hello[at]example.com)
 0.0 DKIM_ADSP_CUSTOM_MED   No valid author signature, adsp_override is
                            CUSTOM_MED
-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
-0.0 NO_RECEIVED            Informational: message has no Received headers
 1.2 NML_ADSP_CUSTOM_MED    ADSP custom_med hit, and not from a mailing list
END
  text
end

def testing_spamassassin_report
  text = <<END
 pts rule name               description
---- ---------------------- --------------------------------------------------
-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
 1.2 MISSING_HEADERS        Missing To: header
 0.1 MISSING_MID            Missing Message-Id: header
 1.8 MISSING_SUBJECT        Missing Subject: header
 2.3 EMPTY_MESSAGE          Message appears to have no textual parts and no
                            Subject: text
 1.0 MISSING_FROM           Missing From: header
 -0.0 NO_RECEIVED            Informational: message has no Received headers
 1.4 MISSING_DATE           Missing Date: header
 0.0 NO_HEADERS_MESSAGE     Message appears to be missing most RFC-822 headers
END
  text
end
