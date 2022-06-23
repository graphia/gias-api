require "toro"
require "pg"
require "./school"

class GIAS::API::Server < Toro::Router
  def routes
    on("schools") do
      on(:urn) do
        args = [] of DB::Any
        args << inbox[:urn]

        get do
          json(GIAS::API::SchoolQuery.new(GIAS_DB).find_one(args).to_json)
        rescue DB::NoResultsError
          status(404)
        end
      end

      get do
        json(GIAS::API::SchoolQuery.new(GIAS_DB).find_all.map(&.to_json))
      end
    end
  end
end

GIAS_DB = DB.open("postgres:///gias?host=/run/postgresql/.s.PGSQL.5432")

begin
  GIAS::API::Server.run(3001)
ensure
  GIAS_DB.close
end
