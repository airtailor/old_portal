class AirtailorMailer < ApplicationMailer
  require 'pdfkit'

  default from: "orders@airtailor.com"

  def label_email(customer, order)

    @customer = customer
    @order = order
    # html=render_to_string(:partial=> "attachment")
    kit = PDFKit.new "<img src=" + @order.inbound_label.to_s + " style='transform:rotate(90deg); width:50%; padding-bottom:20px; border-bottom:1px dashed black'><h2 style='text-align:center; padding-top:100px;'>" + @order.shopify_id.to_s + "</h2>"
    kit.to_file("#{Rails.root}/public/kit.pdf")

    attachments["kit.pdf"] = File.read(Rails.root.join('public',"kit.pdf"))
    mail(to: "brian@airtailor.com", subject: 'Sample Portal Email')
  end
end
