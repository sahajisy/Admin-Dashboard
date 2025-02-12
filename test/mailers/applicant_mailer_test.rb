require "test_helper"

class ApplicantMailerTest < ActionMailer::TestCase
  test "payment_updated" do
    mail = ApplicantMailer.payment_updated
    assert_equal "Payment updated", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
