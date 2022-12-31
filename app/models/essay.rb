class Essay < ApplicationRecord
  belongs_to :author
  belongs_to :writer, polymorphic: true
end
