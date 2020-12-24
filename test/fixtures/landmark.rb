# frozen_string_literal: true

class Landmark < ApplicationRecord
  acts_as_versioned if_changed: %i[name longitude latitude]
end
