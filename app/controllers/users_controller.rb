class UsersController < ApplicationController
  def gsuite_sync_users
    @client = GoogleServiceAccount.new(person: ENV['ADMIN_EMAIL'],
                                       scopes: ['https://www.googleapis.com/auth/admin.directory.user']).authorized_client
    begin
      cal = @client.discovered_api('admin', 'directory_v1')
      res = @client.execute(:api_method => cal.users.list,:parameters => {'customer' => 'my_customer'},:headers => {'Content-Type' => 'application/json'})
      users = []
      JSON.parse(res.body)['users'].each do |user|
        user['name']['email'] = user['primaryEmail']
        users << user['name']
      end
      render json: {users: users}
    rescue => e
      render json: {message: e.message}
    end
  end  
end
