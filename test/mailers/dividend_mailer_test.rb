require 'test_helper'

class DividendMailerTest < ActionMailer::TestCase
  test 'new_contribution_notification' do
    email = DividendMailer.with(contribution: contributions(:one)).new_contribution_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Contribution has been Received', email.subject
    assert_equal read_fixture('contribution_received.txt').join, email.body.to_s
  end

  test 'pay_out_notification' do
    email = DividendMailer.with(dividend: dividends(:one)).pay_out_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['admin@email.com'], email.to
    assert_equal 'Pay Out Requested', email.subject
    assert_equal read_fixture('pay_out.txt').join, email.body.to_s
  end

  test 'new_dividend_notification' do
    email = DividendMailer.with(dividend: dividends(:one)).new_dividend_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'New Dividend Distributed', email.subject
    expected_content = read_fixture('new_dividend.txt').join.gsub('{{id}}', dividends(:one).id.to_s)
    assert_equal expected_content, email.body.to_s
  end

  test 'paid_out_notification' do
    email = DividendMailer.with(dividend: dividends(:paid_out)).paid_out_notification

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['notifications@example.com'], email.from
    assert_equal ['user@email.com'], email.to
    assert_equal 'Your Dividend has been Paid Out', email.subject
    assert_equal read_fixture('paid_out.txt').join, email.body.to_s
  end
end
