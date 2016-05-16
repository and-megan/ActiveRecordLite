namespace :db do
  desc 'create and seed bike database'
  task :create do
    output = `sqlite3 db/bikes.sqlite3 < db/seeds.sql`
  end

  namespace :test do
    desc 'create and seed test database'
    task :prepare do
      output = `sqlite3 db/test.sqlite3 < db/seeds.sql`
    end
  end
end
