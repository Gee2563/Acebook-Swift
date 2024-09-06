const mongoose = require("mongoose");

const PostSchema = new mongoose.Schema({
  content: String,
  createdAt: Date,
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  imgUrl: String,
  likes: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
});

const Post = mongoose.model("Post", PostSchema);
// const user1 = new User({ email: "Matt@test.com", password: "123456", username:"mattnotCar", imgUrl:"assets/blank-profile-picture-973460_640.png" })

const dateTimeString = new Date().toLocaleString("en-GB");
new Post({
  content: `This is a sample post content. createdAt: created at ${dateTimeString}`,
  createdAt: dateTimeString,
  userId: "66d987ec766b2ea9c2da26a7",
  imgUrl: "assets/sample-post-image.png",
  likes: ["66d987ec766b2ea9c2da26a7"],
}).save();
module.exports = Post;
