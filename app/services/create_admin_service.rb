class CreateAdminService
  def call
    User.find_or_create_by!(email: 'arjun@aceteksolutions.com',
                            name: 'arjun_verma') do |user|
      user.password = 'admin_root'
      user.password_confirmation = 'admin_root'
      user.admin!
    end
  end
end
