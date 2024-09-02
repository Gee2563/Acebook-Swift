require("../mongodb_helper");

const Post = require("../../models/post");
const User = require("../../models/user");

describe("Post model", () => {
  let userId;

  beforeAll(async () => {
    const user = new User({
      email: "post-test@test.com",
      password: "12345678",
      username: "test-user",
    });

    await user.save();
    userId = user.id;
  });

  beforeEach(async () => {
    await Post.deleteMany({});
  });

  it("has a message, a createdBy, createdAt and likes properties", () => {
    const post = new Post({ message: "some message", createdBy: userId, createdAt: Date.now(), likes: [] });

    expect(post.message).toEqual("some message");
    expect(post.createdBy.toString()).toEqual(userId);
    expect(post.createdAt).toBeInstanceOf(Date);
    expect(post.likes).toEqual([]);
  });

  it("can list all posts", async () => {
    const posts = await Post.find();
    expect(posts).toEqual([]);
  });

  it("can save a post", async () => {
    const post = new Post({
      message: "some message",
      createdBy: userId,
      createdAt: Date.now(),
      likes: [],
    });

    await post.save();
    const posts = await Post.find();
    expect(posts[0].message).toEqual("some message");
  });
});
