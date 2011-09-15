namespace :db do
  namespace :sessions do
    desc "Clean up expired Active Record sessions (last updated more than a week ago)."
    task :expire => :environment do
      Rails.logger.info "Cleaning up expired sessions..."
      session = ActiveRecord::SessionStore::Session
      rows = session.where("updated_at < ?", 1.week.ago).delete_all
      Rails.logger.info "Deleted #{rows} session row(s) - there are #{session.count} session row(s) left"
    end
  end
end
