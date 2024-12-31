#!/bin/bash

echo "Starting OpenHands Web Service..."

# Check if Python and pip are installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is not installed"
    exit 1
fi

if ! command -v pip &> /dev/null; then
    echo "Error: pip is not installed"
    exit 1
fi

# Install requirements if they're not already installed
echo "Checking and installing requirements..."
pip install -r requirements.txt

# Initialize database and run migrations
echo "Initializing database..."
if [ ! -d "migrations" ]; then
    echo "Setting up initial database migration..."
    flask db init
fi

# Run database migrations
echo "Running database migrations..."
flask db migrate -m "Auto-migration" || echo "No new migrations needed"
flask db upgrade

# Kill any existing Flask processes
echo "Checking for existing Flask processes..."
pkill -f "python app.py" || true

# Start the Flask application
echo "Starting Flask application..."
python app.py > server.log 2>&1 &

# Wait a moment for the server to start
sleep 2

# Check if the server is running
if pgrep -f "python app.py" > /dev/null; then
    echo "Server started successfully!"
    echo "You can view the application at http://localhost:5000"
    echo "Server logs are being written to server.log"
    echo "To stop the server, run: pkill -f 'python app.py'"
else
    echo "Error: Server failed to start. Check server.log for details"
    exit 1
fi