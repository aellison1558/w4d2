class CatRentalRequest < ActiveRecord::Base
  belongs_to :cat
  STATUS_OPTIONS = ["PENDING", "APPROVED", "DENIED"]
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: STATUS_OPTIONS, message: "Invalid Status"}
  validate :no_overlapping_rentals

  def self.status_options
    STATUS_OPTIONS
  end

  def overlapping_requests
    if id
      rentals_on_my_cat = CatRentalRequest.where("cat_id = ? AND id != ?", cat_id, id)
    else
      rentals_on_my_cat = CatRentalRequest.where(cat_id: cat_id)
    end
    not_overlapping = rentals_on_my_cat.where("(start_date < ? AND end_date < ?) OR (start_date > ? AND end_date > ?)", start_date, end_date, start_date, end_date)
    rentals_on_my_cat.where('id NOT IN (?)', not_overlapping.select(id) )
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def no_overlapping_rentals
    unless overlapping_approved_requests.empty? || status != "APPROVED"
      errors[:start_date] << "Rentals can't overlap!"
    end
  end

  def approve!
    CatRentalRequest.transaction do
      if overlapping_approved_requests.empty?
        self.update(status: "APPROVED")
        overlapping_requests.update_all(status: "DENIED")
      end
    end
  end

  def deny!
    self.update(status: "DENIED")
  end

end
