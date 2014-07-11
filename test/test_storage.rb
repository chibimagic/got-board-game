class TestStorage < MiniTest::Test
  def random_string
    (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def test_user_creation
    username = random_string
    password = random_string
    player_name = random_string
    user_id = Storage.create_user(username, password, player_name)
    expected_user_info = { :id => user_id, :username => username, :player_name => player_name }
    user_info = Storage.get_user(username)
    assert_equal(expected_user_info, user_info, 'Incorrect user information')

    usernames = Storage.list_users
    assert_includes(usernames, username, 'New user not listed')

    assert_equal(true, Storage.correct_password?(username, password), 'Correct password not verified')
    assert_equal(false, Storage.correct_password?(username, random_string), 'Incorrect password verified')
  end

  def test_nil_user
    user = Storage.get_user(random_string)
    assert_equal(nil, user, 'Found a non-existent user')
  end

  def test_duplicate_username
    username = random_string
    Storage.create_user(username, random_string, random_string)
    assert_raises(RuntimeError) { Storage.create_user(username, random_string, random_string) }
  end

  def test_game_create_get
    usernames = [random_string, random_string, random_string, nil, nil, nil]
    user_ids = usernames.map { |username| username.nil? ? nil : Storage.create_user(username, 'password', username) }
    original_game = Game.create_new([HouseStark.create_new, HouseLannister.create_new, HouseBaratheon.create_new])
    game_id = Storage.create_game(original_game, *user_ids)
    game_ids = Storage.list_games
    assert_includes(game_ids, game_id, 'New game not listed')
    restored_game = Storage.get_game(game_id)
    assert_equal(original_game, restored_game, 'Restored game incorrect')
  end
end
