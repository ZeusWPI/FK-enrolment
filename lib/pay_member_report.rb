require 'basic_member_report'

class PayMemberReport < BasicMemberReport
  column(:pay, :header => "") do |member|
    link_to "Betalen", pay_backend_member_path(member)
  end
end
