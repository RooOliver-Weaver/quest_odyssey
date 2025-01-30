class Session < ApplicationRecord
 belongs_to :campaign
 has_many :characters, through: :campaign
 validates :approved, inclusion: { in: [true, false] }, allow_nil: true
 enum :status, { approved: 'approved', rejected: 'rejected', pending: 'pending' }
end
