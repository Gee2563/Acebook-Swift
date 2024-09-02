const request = require("supertest");
const JWT = require("jsonwebtoken");

const app = require("../../app");
const Post = require("../../models/post");
const User = require("../../models/user");

require("../mongodb_helper");

const secret = process.env.JWT_SECRET;

const createToken = (userId) => {
  return JWT.sign(
    {
      user_id: userId,
      // Backdate this token of 5 minutes
      iat: Math.floor(Date.now() / 1000) - 5 * 60,
      // Set the JWT token to expire in 10 minutes
      exp: Math.floor(Date.now() / 1000) + 10 * 60,
    },
    secret
  );
};

let token;
let userId;

describe("/posts", () => {
  beforeEach(async () => {
    const user = new User({
      email: "post-test@test.com",
      password: "12345678",
      username: "test-user"
    });
    await user.save();
    await Post.deleteMany({});
    token = createToken(user.id);
    userId = user.id;
  });

  afterEach(async () => {
    await User.deleteMany({});
    await Post.deleteMany({});
  });

  describe("POST, when a valid token is present", () => {
    test("responds with a 201", async () => {
      const response = await request(app)
        .post("/posts")
        .set("Authorization", `Bearer ${token}`)
        .send({ message: "Hello World!" });
      expect(response.status).toEqual(201);
    });

    test("creates a new post", async () => {
      await request(app)
        .post("/posts")
        .set("Authorization", `Bearer ${token}`)
        .send({ message: "Hello World!!" });

      const posts = await Post.find();
      console.log(posts)
      expect(posts.length).toEqual(1);
      expect(posts[0].message).toEqual("Hello World!!");
    });

    test("returns a new token", async () => {
      const testApp = request(app);
      const response = await testApp
        .post("/posts")
        .set("Authorization", `Bearer ${token}`)
        .send({ message: "hello world" });

      const newToken = response.body.token;
      const newTokenDecoded = JWT.decode(newToken, process.env.JWT_SECRET);
      const oldTokenDecoded = JWT.decode(token, process.env.JWT_SECRET);

      // iat stands for issued at
      expect(newTokenDecoded.iat > oldTokenDecoded.iat).toEqual(true);
    });
  });

  describe("POST, when token is missing", () => {
    test("responds with a 401", async () => {
      const response = await request(app)
        .post("/posts")
        .send({ message: "hello again world" });

      expect(response.status).toEqual(401);
    });

    test("a post is not created", async () => {
      const response = await request(app)
        .post("/posts")
        .send({ message: "hello again world" });

      const posts = await Post.find();
      expect(posts.length).toEqual(0);
    });

    test("a token is not returned", async () => {
      const response = await request(app)
        .post("/posts")
        .send({ message: "hello again world" });

      expect(response.body.token).toEqual(undefined);
    });
  });

  describe("GET, when token is present", () => {
    test("the response code is 200", async () => {
      const post1 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
        likes: []
      });
      const post2 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
        likes: []
      });

      await post1.save();
      await post2.save();

      const response = await request(app)
        .get("/posts")
        .set("Authorization", `Bearer ${token}`);

      expect(response.status).toEqual(200);
    });

    test("returns every post in the collection", async () => {
      const date = Date.now();

      const post1 = new Post({
        message: "howdy!",
        createdAt: date,
        createdBy: userId,
        likes: [],
      });

      const post2 = new Post({
        message: "hola!",
        createdAt:date,
        createdBy: userId,
        likes: [],
      });
      
      await post1.save();
      await post2.save();

      const response = await request(app)
        .get("/posts")
        .set("Authorization", `Bearer ${token}`);

      const posts = response.body.posts;
      const firstPost = posts[0];
      const secondPost = posts[1];

      expect(firstPost.message).toEqual("howdy!");
      expect(new Date(firstPost.createdAt).toString()).toBe((new Date(date).toString()));
      expect(firstPost.createdBy.username).toEqual("test-user");

      expect(secondPost.message).toEqual("hola!");
      expect(new Date(firstPost.createdAt).toString()).toBe(new Date(date).toString());
      expect(secondPost.createdBy.username).toEqual("test-user");
    });

    test("returns a new token", async () => {
      const post1 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
      });
      
      const post2 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
      });
      
      await post1.save();
      await post2.save();
      
      const response = await request(app)
        .get("/posts")
        .set("Authorization", `Bearer ${token}`);

      const newToken = response.body.token;
      const newTokenDecoded = JWT.decode(newToken, process.env.JWT_SECRET);
      const oldTokenDecoded = JWT.decode(token, process.env.JWT_SECRET);

      // iat stands for issued at
      expect(newTokenDecoded.iat > oldTokenDecoded.iat).toEqual(true);
    });
  });

  describe("GET, when token is missing", () => {
    test("the response code is 401", async () => {
      const post1 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
      });

      const post2 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
      });

      await post1.save();
      await post2.save();
      
      const response = await request(app).get("/posts");

      expect(response.status).toEqual(401);
    });

    test("returns no posts", async () => {
      const post1 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
      });
      
      const post2 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
      });
      
      await post1.save();
      await post2.save();

      const response = await request(app).get("/posts");

      expect(response.body.posts).toEqual(undefined);
    });

    test("does not return a new token", async () => {
      const post1 = new Post({ message: "howdy!", createdAt: Date.now(), createdBy: userId });
      const post2 = new Post({
         message: "howdy!",
         createdAt: Date.now(),
         createdBy: userId,
      });
      
      await post1.save();
      await post2.save();

      const response = await request(app).get("/posts");

      expect(response.body.token).toEqual(undefined);
    });
  });

  describe("PUT, when token is present", () => { 
    test("Adds the user_id to the likes array when a user that hasn't liked the post yet has sent the request", async () => {
      const post1 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
        likes: []
      });

      await post1.save();

      const response = await request(app)
        .put("/posts")
        .set("Authorization", `Bearer ${token}`)
        .send({ postId: post1.id })
      
      expect(response.body.post.likes).toEqual([userId]);
      expect(response.body.post._id).toEqual(post1.id);
    });

    test("Removes the user_id from the likes array when a user that has already liked the post yet has sent the request", async () => {
      const post1 = new Post({
        message: "howdy!",
        createdAt: Date.now(),
        createdBy: userId,
        likes: [userId],
      });

      await post1.save();

      const response = await request(app)
        .put("/posts")
        .set("Authorization", `Bearer ${token}`)
        .send({ postId: post1.id });
      
      const updatedPost = await Post.find({ _id: post1.id });

      expect(response.body.post.likes).toEqual([]);
      expect(response.body.post._id).toEqual(post1.id);
      expect(updatedPost[0].likes).toEqual([])
    });

    test("Returns an error when the post the user is trying to like doesn't exist", async () => {
      const id = "this is a wrong id";

      const response = await request(app)
        .put("/posts")
        .set("Authorization", `Bearer ${token}`)
        .send({ postId: id });

      console.log(response.body);

      expect(response.status).toEqual(400);
      expect(response.body.message).toEqual('Something went wrong - try again');
    });


  })
});
