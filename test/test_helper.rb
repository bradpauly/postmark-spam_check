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
