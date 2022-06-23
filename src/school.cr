module GIAS::API
  class SchoolQuery
    getter :db

    def initialize(db : DB::Database)
      @db = db
    end

    def find_one(args)
      query = "select urn, name from schools where urn = $1;"

      result = db.using_connection do |c|
        c.query_one(query, args: args, as: ({Int32, String}))
      end

      GIAS::API::School.new(result)
    end

    def find_all
      query = "select urn, name from schools;"

      results = [] of {Int32, String}

      db.using_connection do |c|
        c.query(query) do |rs|
          rs.each { results << {rs.read(Int32), rs.read(String)} }
        end
      end

      results.map { |r| GIAS::API::School.new(r) }
    end
  end

  class School
    getter urn : Int32
    getter name : String

    def initialize(result = Tuple({Int32, String}))
      @urn = result[0]
      @name = result[1]
    end

    def to_json
      { urn: @urn, name: @name }
    end
  end
end
