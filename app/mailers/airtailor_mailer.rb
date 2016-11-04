class AirtailorMailer < ApplicationMailer
  require 'pdfkit'

  default from: "orders@airtailor.com"

  def label_email(customer, order)

    @customer = customer
    @order = order
    # html=render_to_string(:partial=> "attachment")
    kit = PDFKit.new "<img src=" + @order.inbound_label.to_s + " style='display:block;text-align:center;width:60%; padding-bottom:20px; border-bottom:1px dashed black'><h2 style='text-align:center; padding-top:100px; font-size:48px'>" + @order.shopify_id.to_s + "</h2>"
    kit.to_file("#{Rails.root}/public/kit.pdf")

    attachments["kit.pdf"] = File.read(Rails.root.join('public',"kit.pdf"))
    mail(to: @customer.email.to_s, subject: 'Sample Portal Email')
  end
end
