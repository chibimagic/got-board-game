require 'sqlite3'
require 'bcrypt'
require 'base64'

class Storage
  def self.db
    db = SQLite3::Database.new('games.db')
    db.execute <<-EOT
      create table if not exists users (
        id integer primary key,
        username string unique not null,
        passhash string not null,
        player_name string not null
      )
    EOT

    db.execute <<-EOT
      create table if not exists sessions (
        id integer primary key,
        user_id integer,
        session_id unique,
        foreign key(user_id) references users(id)
      )
    EOT

    db.execute <<-EOT
      create table if not exists games (
        id integer primary key,
        house_stark not null,
        house_lannister not null,
        house_baratheon not null,
        house_greyjoy,
        house_tyrell,
        house_martell,
        data blob not null,
        foreign key(house_stark) references users(id),
        foreign key(house_lannister) references users(id),
        foreign key(house_baratheon) references users(id),
        foreign key(house_greyjoy) references users(id),
        foreign key(house_tyrell) references users(id),
        foreign key(house_martell) references users(id)
      )
    EOT
    db
  end

  def self.list_users
    db.execute('select username from users').flatten
  end

  def self.create_user(username, password, player_name)
    unless db.execute('select id from users where username=?', username)[0].nil?
      raise 'Username is taken: ' + username.to_s
    end
    passhash = BCrypt::Password.create(password)
    db.execute('insert into users (username, passhash, player_name) values (?, ?, ?)', [username, passhash, player_name])
  end

  def self.get_user_id(username)
    row = db.execute('select id from users where username=?', username)[0]
    if row.nil?
      raise 'No user with username: ' + username.to_s
    end
    row[0]
  end

  def self.get_user(username)
    user_id = get_user_id(username)
    row = db.execute('select username, player_name from users where id=?', user_id)[0]
    { :username => row[0], :player_name => row[1] }
  end

  def self.correct_password?(username, password)
    user_id = get_user_id(username)
    passhash = db.execute('select passhash from users where id=?', user_id)[0][0]
    BCrypt::Password.new(passhash) == password
  end

  def self.create_session(username, session_id)
    user_id = get_user_id(username)
    db.execute('insert into sessions (user_id, session_id) values (?, ?)', [user_id, session_id])
  end

  def self.get_user_for_session(session_id)
    row = db.execute('select username from sessions left join users on sessions.user_id=users.id where session_id=?', session_id)[0]
    if row.nil?
      raise 'No user with session id: ' + session_id.to_s
    end
    row[0]
  end

  def self.list_games(username)
    user_id = get_user_id(username)
    db.execute('select id from games
      where house_stark=? or house_lannister=? or house_baratheon=? or house_greyjoy=? or house_tyrell=? or house_martell=?',
      user_id, user_id, user_id, user_id, user_id, user_id).flatten
  end

  def self.create_game(
    game,
    house_stark_username,
    house_lannister_username,
    house_baratheon_username,
    house_greyjoy_username = nil,
    house_tyrell_username = nil,
    house_martell_username = nil
  )
    usernames = [
      house_stark_username,
      house_lannister_username,
      house_baratheon_username,
      house_greyjoy_username,
      house_tyrell_username,
      house_martell_username
    ]
    user_ids = usernames.map { |username| username.nil? ? nil : get_user_id(username) }

    data = Base64.encode64(Marshal.dump(game))
    db.execute('insert into games
      (house_stark, house_lannister, house_baratheon, house_greyjoy, house_tyrell, house_martell, data)
      values (?, ?, ?, ?, ?, ?, ?)',
      [user_ids, data]
    )
    db.execute('select id from games where data=? limit 1', data)[0][0]
  end

  def self.get_game(game_id)
    row = db.execute('select data from games where id=?', game_id)[0]
    if row.nil?
      raise 'No game with id: ' + game_id.to_s
    end
    Marshal.load(Base64.decode64(row[0]))
  end

  def self.save_game(game_id, game)
    data = Base64.encode64(Marshal.dump(game))
    db.execute('replace into games (id, data) values (?, ?)', [game_id, data])
  end
end
