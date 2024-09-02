const express = require("express");
const router = express.Router();

const CommentsController = require("../controllers/comments");

router.get("/:postId", CommentsController.getCommentsByPost);
router.post("/:postId", CommentsController.createNewComment);

module.exports = router;