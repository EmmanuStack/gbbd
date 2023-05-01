# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, :provider, :uid, :token, presence: true
end
