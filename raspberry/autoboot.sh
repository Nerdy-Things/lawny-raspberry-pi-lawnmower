#!/bin/bash

USER=$(whoami)
SERVICE_DIR="/etc/systemd/system"

sed "s/__USER__/$USER/g" lawny_websocket.service > "tmp.file"
sudo cp "tmp.file" "$SERVICE_DIR/lawny_websocket.service"

rm tmp.file

sed "s/__USER__/$USER/g" lawny_video.service > "tmp.file"
sudo cp "tmp.file" "$SERVICE_DIR/lawny_video.service"

rm tmp.file

sudo systemctl daemon-reload

sudo systemctl enable lawny_websocket.service
sudo systemctl start lawny_websocket.service

sudo systemctl enable lawny_video.service
sudo systemctl start lawny_video.service