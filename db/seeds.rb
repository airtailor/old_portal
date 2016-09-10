# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


blah = User.create(email: "brian@faketailor.com", password: "12345", business_name: "Fake Tailor", user_name: "Brian", phone: "616-456-7890", street: "123 Fake St.", unit: "1", city: "Grand Rapids", state: "MI", country: "USA", timezone: "eastern")

User.create(email: "brian@airtailor.com", password: "12345", business_name: "Air Tailor", user_name: "Brian", phone: "616-780-4457", street: "123 Awesome St.", unit: "53", city: "Grand Rapids", state: "MI", country: "USA", timezone: "eastern")

User.create(email: "joshua@imaginarytailor.com", password: "12345", business_name: "Imaginary Tailor", user_name: "Joshua", phone: "347-456-7890", street: "123 Imaginary St.", unit: "2", city: "Los Angeles", state: "CA", country: "USA", timezone: "pacific")

User.create(email: "vlad@mythicaltailor.com", password: "12345", business_name: "Mythical Tailor", user_name: "Vlad", phone: "313-456-7890", street: "123 Myth Way", unit: "3", city: "Austin", state: "TX", country: "USA", timezone: "central")

# t.string :name
#       t.integer :shopify_id
#       t.integer :unique_id
#       t.string :total
#       t.string :alterations
#       t.references :user, index: true, foreign_key: true
Order.create(name: "customer 1", 
  shopify_id: 1234, 
  unique_id: 909090, 
  total: "50.00", 
  alterations: '{\"Shirt #1\"=>\"Add Collar Buttons, Add Snaps Under Collar\", \"Pants #1\"=>\"Add Button, Add Clasp\"}', 
  user_id: blah.id)

# Order.create(user_id: 1, status: "2 days to go", customer: "Bugs Bunny")
# Order.create(user_id: 1, status: "3 days to go", customer: "Elmer Fudd")
# Order.create(user_id: 2, status: "2 days to go", customer: "Taz Devil")
# Order.create(user_id: 2, status: "1 day to go", customer: "Tweety Bird")
# Order.create(user_id: 3, status: "3 days to go", customer: "Sylvester Cat")
# Order.create(user_id: 3, status: "4 days to go", customer: "Daffy Duck")

# Item.create(order_id: 1, item_name: "shirt", notes: "See customer measurements")
# Item.create(order_id: 1, item_name: "jacket", notes: "Customer supplied button")
# Item.create(order_id: 2, item_name: "pants", notes: "See customer measurements")
# Item.create(order_id: 2, item_name: "skirt", notes: "Customer supplied button")
# Item.create(order_id: 3, item_name: "shorts", notes: "See customer measurements")
# Item.create(order_id: 3, item_name: "pants", notes: "Customer supplied button")

# Alteration.create(order_id: 1, item_id: 1, alteration: "hem sleeves")
# Alteration.create(order_id: 1, item_id: 1, alteration: "shorten length")
# Alteration.create(order_id: 1, item_id: 2, alteration: "hem sleeves")
# Alteration.create(order_id: 1, item_id: 2, alteration: "add button")
# Alteration.create(order_id: 2, item_id: 3, alteration: "hem pants legs")
# Alteration.create(order_id: 2, item_id: 3, alteration: "taper legs")
# Alteration.create(order_id: 2, item_id: 4, alteration: "hem waist")
# Alteration.create(order_id: 2, item_id: 4, alteration: "add button")
# Alteration.create(order_id: 3, item_id: 5, alteration: "hem waist")
# Alteration.create(order_id: 3, item_id: 5, alteration: "shorten length")
# Alteration.create(order_id: 3, item_id: 6, alteration: "hem pants legs")
# Alteration.create(order_id: 3, item_id: 6, alteration: "add button")

Conversation.create(sender_id: 4, recipient_id: 1)
Message.create(user_id: 4, conversation_id: 1, text: "Testing message system", read: false)

Message.create(user_id: 1, conversation_id: 1, text: "Hey! It works.", read: false)

Message.create(user_id: 4, conversation_id: 1, text: "Oh that's great to hear!", read: false)

Message.create(user_id: 1, conversation_id: 1, text: "Yeah, you're really awesome at this. Don't give up!", read: false)







