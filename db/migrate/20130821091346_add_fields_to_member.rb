class AddFieldsToMember < ActiveRecord::Migration
  def up
    add_column :members, :home_street, :string
    add_column :members, :home_postal_code, :string
    add_column :members, :home_city, :string

    add_column :members, :studenthome_street, :string
    add_column :members, :studenthome_postal_code, :string
    add_column :members, :studenthome_city, :string

    Member.all.each do |member|
      parse_address(member, 'home')
      parse_address(member, 'studenthome')
      member.save(:validate => false)
    end
  end

  def parse_address(member, prop)
    re = /^(((?!,).)*)[\s,]+[B\-]*([0-9]+)[\s,]+([^0-9]+)$/
    value = member.send(prop + '_address')
    return if value.blank?

    match = re.match(value)
    if match
      member.send(prop + '_street=', match[1].strip)
      member.send(prop + '_postal_code=', match[3].strip)
      member.send(prop + '_city=', match[4].strip)
    end
  end

  def down
    remove_column :members, :home_street
    remove_column :members, :home_postal_code
    remove_column :members, :home_city

    remove_column :members, :studenthome_street
    remove_column :members, :studenthome_postal_code
    remove_column :members, :studenthome_city
  end
end
