class Backend::MembersController < Backend::BackendController
  before_filter :load_member, :except => [:index, :search]
  def load_member
    @member, status = Member.find_member_for_club(params['id'], @club)
    if not @member
      redirect_to backend_members_path, :error => "Ongeldig lid."
    end
  end

  def index
    attributes = {:club_id => @club, :enabled => true}

    @registered_members = Member.where(attributes).count
    @card_members = Member.where(attributes).joins(:current_card).count

    @members = Member.includes(:current_card).where(attributes).order("created_at DESC")
    @members = @members.paginate(:page => params[:page], :per_page => 30)
  end

  def disable
    @member.disable
    redirect_to backend_members_path, :success => "#{@member.name} werd verwijderd."
  end

  def show
    # Load extra attributes with specs
    @extra_attributes = @member.extra_attributes.includes(:spec).all
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
    @card = @member.current_card
    unless @card
      @card = Card.new(:status => 'unpaid', :isic_status => (@member.club.uses_isic ? 'request' : 'none'))
      @card.member = @member
    end
    if params[:card]
      @card.update_attributes(params[:card])
      unless @card.save
        @card.number = nil
      end
    end
  end
end
