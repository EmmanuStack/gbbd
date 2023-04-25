class User < ApplicationRecord
	validates_presence_of :name, :provider, :uid, :token
end
