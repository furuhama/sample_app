require 'test_helper'
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'hogefuga', password_confirmation: 'hogefuga')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@hoge.fuga.org first.last@hoge.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[hoge@fuga..piyo user@example,com user_at_hoge.org user.name@example. hoge@fuga_piyo.com hoge@fuga+piyo.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup # duplicate_user に上でsetupしたインスタンス変数を複製して代入する
    duplicate_user.email = @user.email.upcase # @user.email は全て小文字、 duplicate_user は全て大文字の状態に
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Hoge@fugapiYO.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6 # 多重代入を利用
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '') # remember_tokenの値はなんでも構わない(remember_digestを持たない@userをauthenticated?にかけることが重要)
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    furuhama = users(:furuhama)
    tomiyama = users(:tomiyama)
    assert_not furuhama.following?(tomiyama)
    furuhama.follow(tomiyama)
    assert furuhama.following?(tomiyama)
    furuhama.unfollow(tomiyama)
    assert_not furuhama.following?(tomiyama)
  end

  test "feed should have the right posts" do
    furuhama = users(:furuhama)
    tomiyama = users(:tomiyama)
    ito = users(:ito)
    # 自分自身の投稿を確認
    furuhama.microposts.each do |post_self|
      assert furuhama.feed.include?(post_self)
    end
    # フォローしているユーザーの投稿を確認
    ito.microposts.each do |post_following|
      assert furuhama.feed.include?(post_following)
    end
    # フォローしていないユーザーの投稿が表示されないことを確認
    tomiyama.microposts.each do |post_unfollow|
      assert_not furuhama.feed.include?(post_unfollow)
    end
  end
end
