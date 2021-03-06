require 'omniauth-oauth2'
require 'omniauth-google-oauth2'
require 'omniauth-github'
require 'omniauth-facebook'
require 'omniauth-twitter'

use OmniAuth::Builder do
  config = YAML.load_file 'config/config.yml'
  provider :google_oauth2, config['identifier_gg'], config['secret_gg']
  provider :facebook, config['identifier_fb'], config['secret_fb']
  provider :twitter, config['identifier_tw'], config['secret_tw']
  provider :github, config['identifier_gh'], config['secret_gh']
end

get '/auth/:name/callback' do
  session[:auth] = @auth = request.env['omniauth.auth']
  session[:name] = @auth['info'].name
  session[:image] = @auth['info']['image']
  session[:email] = @auth['info']['email']
  session[:url] = @auth['extra']['raw_info']['link']
  puts "params = #{params}"
  puts "@auth.class = #{@auth.class}"
  puts "@auth info = #{@auth['info']}"
  puts "@auth info class = #{@auth['info'].class}"
  puts "@auth info name = #{@auth['info'].name}"
  puts "@auth info email = #{@auth['info'].email}"
  flash[:notice] = %Q{<div class="welcome">Welcome, #{@auth['info'].name}</div>}
  redirect '/'
end

get '/auth/failure' do
  flash[:notice] = params[:message] 
  redirect '/'
end

