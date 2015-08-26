class PayMemberReport < BasicMemberReport
  column(:pay, :header => "") do |member|
    link_to(icon('eur', 'Betalen'), pay_backend_member_path(member))
  end
end
