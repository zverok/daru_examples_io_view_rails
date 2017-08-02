class ScirubyGithubController < ApplicationController

  layout :resolve_layout

  def repo
    # getting data from url : https://api.github.com/orgs/Sciruby/repos
    # An example: http://nbviewer.jupyter.org/github/athityakumar/daru-io/blob/iruby-examples/iruby/json_importer.ipynb
    @df_repos = Daru::DataFrame.from_json 'https://api.github.com/orgs/Sciruby/repos', Repo_name: '$..name', forks: '$..forks', open_issues: '$..open_issues_count'

    opts = {
      type: :column,
      adapter: :googlecharts,
      height: 500,
      width: 1000
    }
    table_opts = {
      adapter: :googlecharts, pageSize: 10,
      height: 300, width: 400
    }
    @df_repo_table = Daru::View::Table.new(@df_repos, table_opts)
    @df_repos_chart = Daru::View::Plot.new(@df_repo_table, opts)

  end


  private

  def resolve_layout
   case action_name
     when "repo"
      # setting the library is not needed, if you are parsing the
      # `adapter` option in plot or table.
      # Daru::View.plotting_library = :highcharts
      "googlecharts_layout"
     # when "googlecharts"
     #  Daru::View.plotting_library = :googlecharts
     #  "googlecharts_layout"
     # when "datatables"
     #  "datatables_layout"
     else
      Daru::View.plotting_library = :nyaplot
      "application"
     end
  end
end
