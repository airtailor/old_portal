blah = User.create(email: "brian@faketailor.com", password: "12345", business_name: "Fake Tailor", user_name: "Brian", phone: "616-456-7890", street: "123 Fake St.", unit: "1", city: "Grand Rapids", state: "MI", country: "USA", timezone: "eastern")
User.create(email: "brian@airtailor.com", password: "12345", business_name: "Air Tailor", user_name: "Brian", phone: "616-780-4457", street: "123 Awesome St.", unit: "53", city: "Grand Rapids", state: "MI", country: "USA", timezone: "eastern")
User.create(email: "joshua@imaginarytailor.com", password: "12345", business_name: "Imaginary Tailor", user_name: "Joshua", phone: "347-456-7890", street: "123 Imaginary St.", unit: "2", city: "Los Angeles", state: "CA", country: "USA", timezone: "pacific")
User.create(email: "vlad@mythicaltailor.com", password: "12345", business_name: "Mythical Tailor", user_name: "Vlad", phone: "313-456-7890", street: "123 Myth Way", unit: "3", city: "Austin", state: "TX", country: "USA", timezone: "central")

Order.create(name: "customer 1", 
  shopify_id: 1234, 
  unique_id: 909090, 
  total: "50.00", 
  alterations: ["Shirt #1 Add Collar Buttons", "Shirt #1 Add Snaps Under Collar", "Pants #1 Add Button", "Pants #1 Add Clasp"], 
  user_id: blah.id)

Order.create(name: "customer 2", 
  shopify_id: 4444, 
  unique_id: 199993, 
  total: "20.00", 
  alterations: ["Dress #1 Add Belt Buttons"], 
  user_id: blah.id)

Conversation.create(sender_id: 4, recipient_id: 1)

Message.create(user_id: 4, conversation_id: 1, text: "Testing message system", read: false)
Message.create(user_id: 1, conversation_id: 1, text: "Hey! It works.", read: false)
Message.create(user_id: 4, conversation_id: 1, text: "Oh that's great to hear!", read: false)
Message.create(user_id: 1, conversation_id: 1, text: "Yeah, you're really awesome at this. Don't give up!", read: false)