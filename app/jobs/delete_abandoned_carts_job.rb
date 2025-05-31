class DeleteAbandonedCartsJob
  include Sidekiq::Job

  def perform
    carts_to_delete = Cart.where('abandoned = ? AND abandoned_at <= ?', true, 7.days.ago)

    carts_to_delete.find_each(&:destroy!)
  end
end
