class RemoveDoubleExtraAttributes < ActiveRecord::Migration
  def up
    # Remove any double entries
    Member.all.each do |m|
      attributes = m.extra_attributes.order(:created_at)
      m.extra_attributes = Hash[attributes.map { |a| [a.spec_id, a] }].values
    end
  end

  def down
  end
end
