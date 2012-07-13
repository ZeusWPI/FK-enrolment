class Frontend::CasController < Frontend::FrontendController
  before_filter :load_club, :only => :auth
  def auth
    save_redirect :post_cas_redirect
    session[:fk_books] = request.referer =~ /fkgent.be\/fkbooks/

    redirect_to cas_verify_path
  end

  skip_before_filter :verify_authenticity_token, :only => :verify
  before_filter RubyCAS::Filter, :only => :verify
  def verify
    # After redirection the session will contain information like this
    # {
    #    "cas_sent_to_gateway"=>false,
    #    "cas_validation_retry_count"=>0,
    #    "previous_redirect_to_cas"=>2011-07-30 11:08:02 +0200,
    #    "cas_user"=>"pdbaets",
    #    "cas_extra_attributes"=>{
    #      "uid"=>"pdbaets", "mail"=>"FirstName.LastName@UGent.be", "givenname"=>"Pieter",
    #      "surname"=>"De Baets", "objectClass"=>"ugentDictUser",
    #      "lastenrolled"=>"2010 - 2011", "ugentStudentID"=>"00801234"
    #    },
    #    "casfilteruser"=>"pdbaets", "cas_last_valid_ticket"=>nil
    # }

    # Don't save the ticket, it contains a singleton somewhere that can't be marshalled
    session[:cas_last_valid_ticket] = nil

    redirect_to session.delete(:post_cas_redirect) || root_url
  end

  def logout
    RubyCAS::Filter.logout(self, root_url)
  end
end
