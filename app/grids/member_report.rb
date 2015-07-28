class MemberReport < BasicMemberReport
  # Icons
  column(:details, :header => "") do |member|
    icon(:details, '', backend_member_path(member), :title => "Details")
  end
  column(:delete, :header => "") do |member|
    icon(:delete, '', disable_backend_member_path(member),
            :title => "Verwijderen", :method => :post,
            :confirm => "Bent u zeker dat u dit lid wil verwijderen?")
  end
end
