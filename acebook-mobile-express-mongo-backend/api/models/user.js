const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  email: { type: String, required: true },
  password: { type: String, required: true },
  username: { type: String, required: true },
  imgUrl: String
});

const User = mongoose.model("User", UserSchema);
// const dateTimeString = new Date().toLocaleString("en-GB");
// new User({ email: "Matt@test.com", password: "123456", username:"mattnotCar", imgUrl:"assets/blank-profile-picture-973460_640.png" }).save();

module.exports = User;
