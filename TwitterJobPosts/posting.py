#!/usr/bin/python3

from dotenv import load_dotenv
import os
import tweepy

# Load environment variables from .env
load_dotenv()

# Authenticate to Twitter
# Authenticate to Twitter
auth = tweepy.OAuthHandler(
    os.getenv("API_KEY"),
    os.getenv("API_SECRET_KEY")
)

auth.set_access_token(
    os.getenv("ACCESS_TOKEN"),
    os.getenv("ACCESS_TOKEN_SECRET")
)


# Create an API Object
api = tweepy.API(auth)

api.update_status("Just Testing if it works")

