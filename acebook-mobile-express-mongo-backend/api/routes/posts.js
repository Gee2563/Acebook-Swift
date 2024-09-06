const express = require("express");
const router = express.Router();

const PostsController = require("../controllers/posts");

router.get("/", PostsController.getAllPosts);
router.post("/", PostsController.createPost);
router.patch("/like", PostsController.updateLikes);
router.delete("/", PostsController.deletePostbyId);
router.patch("/update", PostsController.updatePostById);

module.exports = router;
