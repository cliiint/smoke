class CreateReading < ApplicationJob
  def perform(user)
    PURPLE.get_reading(user)
  end
end