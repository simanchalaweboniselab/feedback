set :output, File.join(Whenever.path, "log", "cron.log")
every :day, :at => '5:35 pm' do
  runner "User.user_mail", :environment => "development"
end