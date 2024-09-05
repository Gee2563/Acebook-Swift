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

// Uncomment and amend to generate a post on reload of the db

// const dateTimeString = new Date().toLocaleString("en-GB");
// new Post({
//   content: `This is a sample post after viewPost updates, I should be able to edit. createdAt: created at ${dateTimeString}`,
//   createdAt: dateTimeString,
//   userId: "ReplaceMeWithYourUser",
//   imgUrl: "assets/sample-post-image.png",
//   likes: ["ReplaceMeWithAnotherUserObject", "ReplaceMeWithAnotherUserObject"],
// }).save();
module.exports = Post;
