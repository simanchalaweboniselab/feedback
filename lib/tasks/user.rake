namespace :users do

  desc "Create user via rakes"
  task :create_user => :environment do
    admin = User.new
    admin.name = "user2"
    admin.email = "user2@webonise.com"
    admin.password = "admin6186"
    admin.password_confirmation = "admin6186"
    admin.save
  end

end