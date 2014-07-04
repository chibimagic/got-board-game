require 'sqlite3'

class Storage
  def self.db
    db = SQLite3::Database.new('games.db')
    db.execute <<-EOT
      create table if not exists games (
        game_id integer primary key,
        data blob
      )
    EOT
    db
  end

  def self.list_games
    db.execute('select game_id from games').flatten
  end

  def self.get_game(game_id)
    data = db.execute('select data from games where game_id=?', game_id)
    Game.unserialize(data)
  end

  def self.save_game(game_id, game)
    data = game.serialize
    db.execute('insert or replace into games (game_id, data) values (?, ?)', [game_id, data])
    db.execute('select game_id from games where data=? limit 1', data).flatten[0]
  end
end
