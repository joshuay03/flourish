namespace :services do
  desc 'orchestrates a distribution'
  task distribution: :environment do
    members = Member.active
    DistributionService.new(
      run_today: DistributionDateService.today?,
      members:,
      dividend_amount_in_base_units: DividendAmountService.new(
        total_pool_in_base_units: TotalPoolService.balance_in_base_units,
        member_count: members.count
      ).amount_in_base_units
    ).call
  end

  desc 'recontributes unclaimed dividends'
  task recontribution: :environment do
    mailgun_send_limit = 10
    RecontributionService.new(
      issued_dividends: Dividend.issued.take(mailgun_send_limit)
    ).call
  end
end
