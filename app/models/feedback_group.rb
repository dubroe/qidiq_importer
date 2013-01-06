require 'json'
require 'rest_client'

class FeedbackGroup < ActiveRecord::Base
  QIDIQ_API_URL = 'http://www.qidiq.com/api/query'
  
  attr_accessible :api_key, :explanation, :url
  belongs_to :user
  validates :url, :api_key, :explanation, presence: true
  
  def import_user(email)
    params = {
      import_members: 1, 
      feed_url_path: url,
      explanation_text: explanation,
      api_key: api_key, 
      email_addresses: [email]
    }
    params_json = params.to_json
    http_params = {params: params_json}
    RestClient.post(QIDIQ_API_URL, http_params)
  end
  
  def import_post_url
    root_url
  end
end
