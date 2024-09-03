const mongoose = require("mongoose");


const PostSchema = new mongoose.Schema({
  message: String,
  createdAt: Date,
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  imgUrl: String,
  likes: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
});


const Post = mongoose.model("Post", PostSchema);

const dateTimeString = new Date().toLocaleString("en-GB");
new Post({ message: `Test message, created at ${dateTimeString}`, createdAt: dateTimeString, imgUrl: "someImage"}).save();

module.exports = Post;
