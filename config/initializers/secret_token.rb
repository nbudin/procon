# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
Rails.application.config.secret_token = ENV['SECRET_TOKEN'] || '984690e0128edaaeb303cc1631de3a91b06f898253a5bf5cc61721f801a35ea69c47b238074377f9b31e5ca9496654b739a5041a008283d4e33e07f99317b8d2'
