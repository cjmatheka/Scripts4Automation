#!/usr/bin/python3

from dotenv import load_dotenv
import os
import tweepy


# Load environment variables from .env
load_dotenv()

consumer_key = os.environ.get("API_KEY")
consumer_secret = os.environ.get("API_SECRET_KEY")
access_token = os.environ.get("ACCESS_TOKEN")
access_token_secret = os.environ.get("ACCESS_TOKEN_SECRET")

# def post_to_twitter(jobs):
#     auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
#     auth.set_access_token(access_token, access_token_secret)
#     api = tweepy.API(auth)
#
#     for job in jobs:
#         tweet = f"New Job: {job['title']} at {job['company']} - {job['link']}"
#         api.update_status(tweet)


# Authenticate to Twitter
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)

auth.set_access_token(access_token, access_token_secret)


# Create an API Object
api = tweepy.API(auth)

api.update_status("Just Testing if it works")

