class AirtailorMailer < ApplicationMailer
  require 'pdfkit'

  default from: "orders@airtailor.com"

  def label_email(customer, order)

    @customer = customer
    @order = order
    # html=render_to_string(:partial=> "attachment")
    label = PDFKit.new "<img src=" + @order.inbound_label.to_s + " style='display:block;text-align:center;width:60%; padding-bottom:20px; border-bottom:1px dashed black'><h2 style='text-align:center; padding-top:100px; font-size:48px'>" + @order.shopify_id.to_s + "</h2>"
    label.to_file("#{Rails.root}/public/label.pdf")

    attachments["label.pdf"] = File.read(Rails.root.join('public',"label.pdf"))
    mail(to: "bdflynny@gmail.com", subject: 'Air Tailor Shipping Label')
  end
end
