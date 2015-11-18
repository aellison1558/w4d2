class Cat < ActiveRecord::Base
  has_many :cat_rental_requests, dependent: :destroy
  COLORS = ['turquoise', 'magenta', 'cyan']
  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: COLORS, message: "You must choose OUR colors"}
  validates :sex, inclusion: { in: %w(f m), message: "You must conform to our gender standards"}

  def self.color_options
    COLORS
  end
end
