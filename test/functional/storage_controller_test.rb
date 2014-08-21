class StorageControllerTest < MiniTest::Test
  def random_string
    (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end

  def setup
    StorageController.db.execute('delete from games');
    StorageController.db.execute('delete from sessions');
    StorageController.db.execute('delete from users');
  end

  def test_user_creation
    username = random_string
    password = random_string
    player_name = random_string
    StorageController.create_user!(username, password, player_name)
    expected_user_info = { :username => username, :player_name => player_name }
    user_info = StorageController.get_user(username)
    assert_equal(expected_user_info, user_info, 'Incorrect user information')

    usernames = StorageController.list_users
    assert_includes(usernames, username, 'New user not listed')

    assert_equal(true, StorageController.correct_password?(username, password), 'Correct password not verified')
    assert_equal(false, StorageController.correct_password?(username, random_string), 'Incorrect password verified')
  end

  def test_nil_user
    e = assert_raises(RuntimeError) { StorageController.get_user(random_string) }
    assert_match(/^No user with username: /, e.message)
  end

  def test_correct_password_invalid_username
    e = assert_raises(RuntimeError) { StorageController.correct_password?(random_string, random_string) }
    assert_match(/^No user with username: /, e.message)
  end

  def test_duplicate_username
    username = random_string
    StorageController.create_user!(username, random_string, random_string)
    e = assert_raises(RuntimeError) { StorageController.create_user!(username, random_string, random_string) }
    assert_match(/^Username is taken: /, e.message)
  end

  def test_get_game_invalid_game_id
    e = assert_raises(RuntimeError) { StorageController.get_game(random_string) }
    assert_match(/^No game with id: /, e.message)
  end

  def test_game_create_get
    usernames = [random_string, random_string, random_string, nil, nil, nil]
    usernames.map { |username| username.nil? ? nil : StorageController.create_user!(username, 'password', username) }
    original_game = Game.create_new([HouseStark, HouseLannister, HouseBaratheon])
    game_id = StorageController.create_game(original_game, *usernames)
    games = StorageController.list_games(usernames[0])
    assert_includes(games, { :game_id => game_id, :house => HouseStark }, 'New game not listed')
    restored_game = StorageController.get_game(game_id)
    assert_equal(original_game, restored_game, 'Restored game incorrect')
  end

  def teardown
    StorageController.db.execute('delete from games');
    StorageController.db.execute('delete from sessions');
    StorageController.db.execute('delete from users');
  end
end
