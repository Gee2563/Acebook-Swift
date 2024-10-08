const Post = require("../models/post");
const { generateToken } = require("../lib/token");

const getAllPosts = async (req, res) => {
  try {
    //Get all posts and populate the userId field with user data
    const posts = await Post.find().populate("userId");

    const updatedPosts = [];

    /* creating an updatedPosts object with the relevant data for both the post and the user - 
    excluding any sensitive data, i.e password for instance. */
    posts.forEach((post) => {
      let newPost = {
        _id: post._id,
        content: post.content,
        createdAt: post.createdAt,
        imgUrl: post.imgUrl,
        likes: post.likes,
        userId: {
          _id: post.userId._id.toString(),
          username: post.userId.username,
          profilePicture: post.userId.imgUrl,
        },
      };

      updatedPosts.push(newPost);
    });

    const token = generateToken(req.user_id);
    res.status(200).json({ posts: updatedPosts, token: token });
  } catch (error) { 
    // console.log(error);
    res.status(400).json({ message: "Something went wrong - try again" });
  }
};

const createPost = async (req, res) => {
  console.log("Received a request...")
  try {
    const postContent = {
      content: req.body.content,
      createdAt: Date.now(),
      userId: req.user_id,
      imgUrl: req.body.imgUrl
        ? req.body.imgUrl
        : null,
    };
    console.log(postContent);
    const post = new Post(postContent);
    console.log(post);

    post.save();

    const newToken = generateToken(req.user_id);
    res.status(201).json({ message: "Post created", token: newToken });

  } catch (error) { 
    console.log(error)
    res.status(400).json({ message: "Something went wrong - try again" });
  }
};

const updateLikes = async (req, res) => {
  try {
    const userId = req.user_id;
    const postId = req.body.postId;

    /*Find the post the user wants to like*/
    const post = await Post.find({ _id: postId });

    let alreadyLiked = false;

    /*Figure out whether the post has already been liked*/
    post[0].likes.forEach((likeId) => {
      if (likeId.toString() === userId) {
        // console.log("Already liked")
        // console.log(userId)
        // console.log(likeId.toString())
        alreadyLiked = true;
      }
    });

    /*If the post is already liked, delete the userId from the likes array*/
    if (alreadyLiked) {
      post[0].likes = post[0].likes.filter((likeId) => {
        return likeId.toString() != userId;
      })

      await Post.findOneAndUpdate({ _id: postId }, post[0]);
      const updatedPost = await Post.find({ _id: postId });
      console.log(updatedPost);

      const token = generateToken(userId);

      res.status(201).json({
        post: updatedPost[0],
        token: token,
        message: "Succesfully unliked post",
      });
    } else { /*If the post hasn't yet been liked, add the userId to the array*/
      post[0].likes.push(userId);

      await Post.findOneAndUpdate({ _id: postId }, post[0]);
      const updatedPost = await Post.find({ _id: postId });
      console.log(updatedPost);

      const token = generateToken(userId);

      res
        .status(201)
        .json({
          post: updatedPost[0],
          token: token,
          message: "Succesfully liked post",
        });
    }
  } catch (error) { 
    // console.log(error);
    res.status(400).json({ message: "Something went wrong - try again" });
  }
};

const deletePostbyId = async (req, res) => {
  try {
    const postId = req.body.postId;
    const userId = req.user_id;

    if (!postId) {
      return res.status(400).json({ message: "Post ID is required" });
    }

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    if (post.userId.toString() !== userId) {
      return res.status(403).json({ message: "Unauthorized action" });
    }

    await post.deleteOne();

    const token = generateToken(userId);
    
    res.status(200).json({ message: "Post deleted successfully", token: token });
  } catch (error) {
    console.error("Error deleting post:", error);
    res.status(500).json({ message: "Something went wrong - try again" });
  }
};

const updatePostById = async (req, res) => {

  try {

    const postId = req.body.postId;
    const userId = req.user_id;

    if (!postId) {
      return res.status(400).json({ message: "Post ID is required" });
    }

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    if (post.userId.toString() !== userId) {
      return res.status(403).json({ message: "Unauthorized action" });
    }

    post.content = req.body.content;
    await post.save();

    const token = generateToken(userId);

    res.status(200).json({ message: "Post updated successfully", token: token });

  } catch (error) {

    console.error("Error updating post:", error);
    res.status(500).json({ message: "Something went wrong - try again" });

  }

  }


const PostsController = {
  getAllPosts: getAllPosts,
  createPost: createPost,
  updateLikes: updateLikes,
  deletePostbyId: deletePostbyId,
  updatePostById: updatePostById
};

module.exports = PostsController;
