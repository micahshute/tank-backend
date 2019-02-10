class Health < ApplicationRecord
  belongs_to :game, polymorphic: true
  belongs_to :user


  def to_builder
    Jbuilder.new do |h|
      h.user user.to_builder
      h.game game.to_shallow_builder
      h.value value
    end
  end


  def json
    to_builder.target!
  end

end
