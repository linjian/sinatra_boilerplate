class User < ApplicationRecord
  enum state: {
    init: 0,
    active: 1,
    rejected: 2,
    dimission: 3
  }

  scope :enabled, -> { unscope(where: :state).where(state: [:init, :active]) }
end
