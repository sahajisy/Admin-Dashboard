# app/models/concerns/current.rb
module Current
  thread_mattr_accessor :user
end