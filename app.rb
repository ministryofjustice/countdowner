require 'sinatra/base'
require 'business_time'
require 'open-uri'
require 'json'

class Countdowner < Sinatra::Base

  get '/' do
    'Hello world!'
  end

  post '/' do
    msg = params[:msg]
    today = Date.today
    end_date = Date.parse(params[:date])
    item = { "value" => "#{today.business_days_until(end_date)}", "text" => "business days #{msg}" }
    result item
  end

  post '/pull-requests' do
    repo = params[:repo]
    github = 'https://api.github.com/repos/ministryofjustice'
    pull_requests = open("#{github}/#{repo}/pulls").read
    red_result JSON.parse(pull_requests).count
  end

  private

  def result item
    {"item" => [{}, item, {}] }.to_json
  end

  def red_result count
    item = { "value" => "#{count}", "text" => "open pull requests" }
    {"item" => [item, {}, {}] }.to_json
  end
end
