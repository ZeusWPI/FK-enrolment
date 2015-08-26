class MemberReport < BasicMemberReport
  # Icons
  column(:details, :header => "") do |member|
    link_to(icon('info'), backend_member_path(member), title: "Details")
  end
  column(:delete, :header => "") do |member|
    link_to(icon('remove'), disable_backend_member_path(member),
            :title => "Verwijderen", :method => :post,
            data: { confirm: "Bent u zeker dat u dit lid wil verwijderen?" } )
  end
end
