blah = User.create(email: "brian@faketailor.com", password: "12345", business_name: "Fake Tailor", user_name: "Brian", phone: "616-456-7890", street: "123 Fake St.", unit: "1", city: "Grand Rapids", state: "MI", country: "USA", timezone: "eastern")
User.create(email: "brian@airtailor.com", password: "12345", business_name: "Air Tailor", user_name: "Brian", phone: "616-780-4457", street: "123 Awesome St.", unit: "53", city: "Grand Rapids", state: "MI", country: "USA", timezone: "eastern")
User.create(email: "joshua@imaginarytailor.com", password: "12345", business_name: "Imaginary Tailor", user_name: "Joshua", phone: "347-456-7890", street: "123 Imaginary St.", unit: "2", city: "Los Angeles", state: "CA", country: "USA", timezone: "pacific")
User.create(email: "vlad@mythicaltailor.com", password: "12345", business_name: "Mythical Tailor", user_name: "Vlad", phone: "313-456-7890", street: "123 Myth Way", unit: "3", city: "Austin", state: "TX", country: "USA", timezone: "central")

Order.create(name: "customer 1",
  shopify_id: 1234,
  unique_id: 909090,
  total: "50.00",
  alterations: ["Shirt #1 Add Collar Buttons", "Shirt #1 Add Snaps Under Collar", "Pants #1 Add Button", "Pants #1 Add Clasp"])

Order.create(name: "customer 2",
  shopify_id: 4444,
  unique_id: 199993,
  total: "20.00",
  alterations: ["Dress #1 Add Belt Buttons"])

Conversation.create(sender_id: 2, recipient_id: 1)

Message.create(user_id: 2, conversation_id: 1, text: "Testing message system", read: true, user_read: false)
Message.create(user_id: 1, conversation_id: 1, text: "Hey! It works.", read: false, user_read: true)
Message.create(user_id: 2, conversation_id: 1, text: "Oh that's great to hear!", read: true, user_read: false)
Message.create(user_id: 1, conversation_id: 1, text: "Yeah, you're really awesome at this. Don't give up!", read: false, user_read:true)

Order.create(name: "Daffy Duck",
  shopify_id: 3456234,
  unique_id: 52634,
  total: "50.00",
  alterations: ["Shirt #1 Add Collar Buttons", "Shirt #1 Add Snaps Under Collar", "Pants #1 Add Button", "Pants #1 Add Clasp", "Shirt #2 Add Collar Buttons", "Shirt #2 Add Snaps Under Collar", "Pants #2 Add Button", "Pants #2 Add Clasp"])

Order.create(name: "Bob Marley",
  shopify_id: 525625,
  unique_id: 257452725,
  total: "20.00",
  alterations: ["Dress #1 Add Belt Buttons", "Dress #2 Add Belt Buttons, Shirt #1 Add Collar Buttons", "Shirt #1 Add Snaps Under Collar", "Pants #1 Add Button", "Pants #1 Add Clasp"])
