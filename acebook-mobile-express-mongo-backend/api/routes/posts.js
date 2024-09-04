const express = require("express");
const router = express.Router();

const PostsController = require("../controllers/posts");

router.get("/", PostsController.getAllPosts);
router.post("/", PostsController.createPost);
router.put("/", PostsController.updateLikes);
router.delete("/", PostsController.deletePostbyId);
router.put("/update", PostsController.updatePostById);

module.exports = router;
