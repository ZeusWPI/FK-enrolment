class Backend::MembersController < Backend::BackendController
  before_filter :load_member
  def load_member
    @member, status = Member.find_member_for_club(params['id'], @club)
    if params['id'] and not @member
      respond_with({:error => "Invalid member"}, :status => status, :location => '')
    end
  end

  def index
    @members = Member.includes(:current_card).where(:club_id => @club, :enabled => true)
  end

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
