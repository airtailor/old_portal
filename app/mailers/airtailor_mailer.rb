class AirtailorMailer < ApplicationMailer
  default from: "orders@airtailor.com"

  def label_email(customer, order)
    @customer = customer
    @order = order
    mail(to: "brian@airtailor.com", subject: 'Sample Portal Email')
  end
end
