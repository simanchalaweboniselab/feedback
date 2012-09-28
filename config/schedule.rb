set :output, File.join(Whenever.path, "log", "cron.log")
every :day, :at => '6:00 pm' do
  runner "UserFeedback.alert_mail", :environment => "development"
end