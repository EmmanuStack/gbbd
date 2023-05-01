# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "John Doe" }
    uid { "12345" }
    provider { "github" }
    token { "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" }
  end
end
