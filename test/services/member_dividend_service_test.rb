require 'test_helper'

class MemberDividendServiceTest < ActiveSupport::TestCase
  test 'creates a dividend for each member' do
    members = [members(:one), members(:two)]
    amount = amounts(:one)

    assert_difference 'Dividend.count', members.count do
      MemberDividendService.new(members:, amount:).call
    end

    dividend_members = Member.joins(:dividends).where(dividends: { amount: })

    assert_includes dividend_members, members(:one)
    assert_includes dividend_members, members(:two)
  end

  test 'sends a notification to each member' do
    members = [members(:one), members(:two)]
    amount = amounts(:one)

    mailer_mock = mock('mailer')
    NotificationMailer.stubs(:with).returns(mailer_mock)
    mailer_mock.stubs(:dividend_received).returns(mailer_mock)
    mailer_mock.stubs(:deliver_now).returns(true).times(members.count)

    assert MemberDividendService.new(members:, amount:).call
  end

  test 'fails when no members' do
    amount = amounts(:one)

    assert_raises MemberDividendService::NoMembersError do
      MemberDividendService.new(members: [], amount:).call
    end
  end

  test 'all dependent services respond' do
    members = [members(:one)]
    amount = amounts(:one)

    assert MemberDividendService.new(members:, amount:).call
  end
end
