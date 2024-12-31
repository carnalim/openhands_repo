#!/bin/bash

echo "Stopping OpenHands Web Service..."

if pgrep -f "python app.py" > /dev/null; then
    pkill -f "python app.py"
    echo "Server stopped successfully!"
else
    echo "No running server found."
fi