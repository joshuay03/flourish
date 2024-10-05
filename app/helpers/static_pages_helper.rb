module StaticPagesHelper
  def created_at_formatted(record)
    record.created_at.strftime("%a, #{record.created_at.day.ordinalize} %b %Y")
  end
end
