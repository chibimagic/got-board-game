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
      create table if not exists games (
        game_id integer primary key,
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
      raise 'The username "' + username + '" is taken'
    end
    passhash = BCrypt::Password.create(password)
    db.execute('insert into users (username, passhash, player_name) values (?, ?, ?)', [username, passhash, player_name])
    db.execute('select id from users where username=?', username)[0][0]
  end

  def self.get_user(username)
    row = db.execute('select id, username, player_name from users where username=?', username)[0]
    row.nil? ? nil : { :id => row[0], :username => row[1], :player_name => row[2] }
  end

  def self.correct_password?(username, password)
    passhash = db.execute('select passhash from users where username=?', username)[0][0]
    BCrypt::Password.new(passhash) == password
  end

  def self.list_games(user_id)
    db.execute('select game_id from games
      where house_stark=? or house_lannister=? or house_baratheon=? or house_greyjoy =? or house_tyrell=? or house_martell =?',
      user_id, user_id, user_id, user_id, user_id, user_id).flatten
  end

  def self.create_game(
    game,
    house_stark_id,
    house_lannister_id,
    house_baratheon_id,
    house_greyjoy_id,
    house_tyrell_id,
    house_martell_id
  )
    data = Base64.encode64(Marshal.dump(game))
    db.execute('insert into games
      (house_stark, house_lannister, house_baratheon, house_greyjoy, house_tyrell, house_martell, data)
      values (?, ?, ?, ?, ?, ?, ?)',
      [house_stark_id, house_lannister_id, house_baratheon_id, house_greyjoy_id, house_tyrell_id, house_martell_id, data]
    )
    db.execute('select game_id from games where data=? limit 1', data)[0][0]
  end

  def self.get_game(game_id)
    data = db.execute('select data from games where game_id=? limit 1', game_id)[0][0]
    Marshal.load(Base64.decode64(data))
  end

  def self.save_game(game_id, game)
    data = Base64.encode64(Marshal.dump(game))
    db.execute('replace into games (game_id, data) values (?, ?)', [game_id, data])
  end
end
