# User.create(email: "orders@airtailor.com", password: "12345", business_name: "Air Tailor", user_name: "Brian", phone: "616-780-4457", street: "510 West 21st Street", unit: "65DM8A", city: "New York", state: "NY", zip: "10011", country: "US", timezone: "eastern")
# User.create(email: "joe@joestailor.com", password: "12345", business_name: "Joe's Tailoring", user_name: "Joe", phone: "616-780-4457", street: "510 West 21st Street", unit: "65DM8A", city: "New York", state: "NY", zip: "10011", country: "US", timezone: "eastern")
#
# Customer.create(first_name: "Jared", last_name: "Murphy", phone: 9045668701, email: "jaredcmurphy@gmail.com", address1: "123 A St", address2: "Aptc 5D", city: "New York", state: "NY", zip: 10031)
# Customer.create(first_name: "Brian", last_name: "Flynn", phone: 1231231234, email: "brian@airtailor.com", address1: "123 A St", address2: "Aptc 5D", city: "New York", state: "NY", zip: 10031)
#
# Measurement.create(sleeve_length: 1, shoulder_to_waist: 2, chest_bust: 5, upper_torso: 6, waist: 2, pant_length: 22, hips: 2, thigh: 2, knee: 2, calf: 2, ankle: 2, back_width: 2, bicep: 2, elbow: 2, forearm: 2, inseam: 2, customer_name: "hi", customer_id: Customer.first.id)
# Measurement.create(sleeve_length: 1, shoulder_to_waist: 2, chest_bust: 5, upper_torso: 6, waist: 2, pant_length: 22, hips: 2, thigh: 2, knee: 2, calf: 2, ankle: 2, back_width: 2, bicep: 2, elbow: 2, forearm: 2, inseam: 5, customer_name: "hi", customer_id: Customer.second.id)
#
# Order.create(name: "customer 1",
#              customer_id: Customer.first.id,
#              shopify_id: 1234,
#              unique_id: 909090,
#              total: "50.00",
#              alterations: ["Shirt #1 Add Collar Buttons", "Shirt #1 Add Snaps Under Collar", "Pants #1 Add Button", "Pants #1 Add Clasp"])
#
# Order.create(name: "customer 2",
#              customer_id: Customer.second.id,
#              shopify_id: 4444,
#              unique_id: 199993,
#              total: "20.00",
#              alterations: ["Dress #1 Add Belt Buttons"])
#
# Conversation.create(sender_id: 2, recipient_id: 1)
#
# Message.create(user_id: 2, conversation_id: 1, text: "Testing message system", read: true, user_read: false)
# Message.create(user_id: 1, conversation_id: 1, text: "Hey! It works.", read: false, user_read: true)
# Message.create(user_id: 2, conversation_id: 1, text: "Oh that's great to hear!", read: true, user_read: false)
# Message.create(user_id: 1, conversation_id: 1, text: "Yeah, you're really awesome at this. Don't give up!", read: false, user_read:true)
#
# Order.create(name: "Daffy Duck",
#              shopify_id: 3456234,
#              unique_id: 52634,
#              total: "50.00",
#              alterations: ["Shirt #1 Add Collar Buttons", "Shirt #1 Add Snaps Under Collar", "Pants #1 Add Button", "Pants #1 Add Clasp", "Shirt #2 Add Collar Buttons", "Shirt #2 Add Snaps Under Collar", "Pants #2 Add Button", "Pants #2 Add Clasp"])
#
# Order.create(name: "Bob Marley",
#              shopify_id: 525625,
#              unique_id: 257452725,
#              total: "20.00",
#              alterations: ["Dress #1 Add Belt Buttons", "Dress #2 Add Belt Buttons", "Shirt #1 Add Collar Buttons", "Shirt #1 Add Snaps Under Collar", "Pants #1 Add Button", "Pants #1 Add Clasp"])
