const mongoose = require("mongoose");

const CommentSchema = new mongoose.Schema({
  message: String,
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  underPost: { type: mongoose.Schema.Types.ObjectId, ref: "Post" },
  createdAt: Date
});

const Comment = mongoose.model("Comment", CommentSchema);

module.exports = Comment;
