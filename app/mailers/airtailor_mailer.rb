class AirtailorMailer < ApplicationMailer
  require 'pdfkit'

  default from: "orders@airtailor.com"

  def label_email(customer, order)

    @customer = customer
    @order = order
    # html=render_to_string(:partial=> "attachment")
    label = PDFKit.new "<img src=" + @order.inbound_label.to_s + " style='display:block; ms-transform: rotate(90deg); -webkit-transform: rotate(90deg);  transform: rotate(90deg); margin:0; margin-left:150px; width:70%;'>
      <img src='http://i.imgur.com/yJwSRrn.png'><p style='text-align:center;'>PUT THIS HALF IN WITH YOUR ORDER<br>PLEASE SHIP US YOUR ORDER WITHIN 10 DAYS</p><h2 style='text-align:center; padding-top:70px; font-size:72px'>" + @order.shopify_id.to_s + "</h2>"
    label.to_file("#{Rails.root}/public/label.pdf")

    attachments["label.pdf"] = File.read(Rails.root.join('public',"label.pdf"))
    mail(to: "brian@airtailor.com", subject: "Ship Your Clothes To Air Tailor! (" + @order.shopify_id + ")")
  end
end
# @customer.email.to_s
