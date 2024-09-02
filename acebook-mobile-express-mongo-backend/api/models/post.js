const mongoose = require("mongoose");


const PostSchema = new mongoose.Schema({
  message: String,
  createdAt: Date,
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  imgUrl: String,
  likes: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
});


const Post = mongoose.model("Post", PostSchema);

module.exports = Post;
