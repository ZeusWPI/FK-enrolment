every 1.day, at: '4:30 am' do
  rake "rack_cas:sessions:prune:active_record"
end
