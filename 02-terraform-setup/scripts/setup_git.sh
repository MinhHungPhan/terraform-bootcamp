#!/bin/bash

# Set Git credential helper cache
git config --global credential.helper cache

# Set Git credential helper cache timeout to 1 hour
git config --global credential.helper 'cache --timeout=3600'

# Set Git user name
git config --global user.name "Minh Hung Phan"

# Set Git user email
git config --global user.email "minhhung.phan2701@gmail.com"
