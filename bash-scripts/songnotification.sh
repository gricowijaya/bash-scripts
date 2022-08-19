#!/bin/sh
song-S(playerctl metadata --format "Title: {{ title }}\nArtist: {{ artist }}\nAlbum: {{ album }}")
notify-send "Spotify" "$song"
