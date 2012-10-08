#set :output, File.join(Whenever.path, "log", "cron.log")
#every :day, :at => '6:35 pm' do
#  runner "UserFeedback.alert_mail", :environment => "development"
#end
every 2.minutes do
  runner "UserFeedback.alert_mail", :environment => "development"
end