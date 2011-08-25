class Backend::MembersController < Backend::BackendController

  def search
    case params[:search_field]
    when 'ugent_nr'
      @members = Member.where(:ugent_nr => params[:search_value])
    when 'email'
      @members = Member.where(:email => params[:search_value])
    when 'name'
      @members = Member.where('LOWER(first_name || " " || last_name) LIKE ?', "%#{params[:search_value].downcase}%")
    end
    respond_to do |format|
      format.js
    end
  end

  def pay
    @member = Member.find(params[:id])
    @card = @member.current_card
    unless @card
      @card = Card.new(:status => 'unpaid', :isic_status => (@member.club.uses_isic ? 'request' : 'none'))
      @card.member = @member
    end
    if params[:card]
      @card.update_attributes(params[:card])
      @card.save!
    end
  end

end
