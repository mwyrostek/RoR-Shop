namespace :db do
  desc "Add an admin"
  task :admin => :environment do
    admin = User.create!(:login => "admin",
	                     :email => "admin@ror.com",
                         :password => "admin",
                         :password_confirmation => "admin")
    admin.toggle!(:admin)
  end
end
