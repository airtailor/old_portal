class AirtailorMailer < ApplicationMailer
  require 'pdfkit'

  default from: "orders@airtailor.com"

  def label_email(customer, order)

    @customer = customer
    @order = order
    kit = PDFKit.new "<img src=" + @order.inbound_label.to_s + ">"
    kit.to_file("#{Rails.root}/public/kit.pdf")

    attachments["kit.pdf"] = File.read(Rails.root.join('public',"kit.pdf"))
    mail(to: "brian@airtailor.com", subject: 'Sample Portal Email')
  end
end
