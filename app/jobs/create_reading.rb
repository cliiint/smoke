class CreateReading < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    PURPLE.get_reading(user)
  end
end