#!/bin/sh

CONTAINER_NAME="adventure-works"
IMAGE_NAME="chriseaton/adventureworks:latest"
PORT="1433"
PASSWORD="My_password1"

# Start the existing container when available so its database state is preserved.
if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    if [ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME")" = true ]; then
        echo "Using existing container '$CONTAINER_NAME'."
    else
        echo "Starting existing container '$CONTAINER_NAME'."
        docker start "$CONTAINER_NAME" >/dev/null
    fi
else
    docker run \
        --name "$CONTAINER_NAME" \
        -p "${PORT}:1433" \
        -e 'ACCEPT_EULA=Y' \
        -e "MSSQL_SA_PASSWORD=${PASSWORD}" \
        -d "$IMAGE_NAME"
    echo "'$CONTAINER_NAME' started successfully."
fi

# healthy and ready
MAX_ATTEMPTS=30
ATTEMPT=1

while [ "$ATTEMPT" -le "$MAX_ATTEMPTS" ]; do
    # Check if SQL Server is responding to queries
    # Updated path to mssql-tools18 and added -C to trust the server certificate
    if docker exec "$CONTAINER_NAME" /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P "$PASSWORD" \
        -C \
        -Q "SELECT 1" &>/dev/null; then
        echo "=== SQL Server is up and ready! ==="
        break
    fi

    echo "Attempt $ATTEMPT/$MAX_ATTEMPTS: SQL Server failed in expected time."
    sleep 2
    ATTEMPT=$((ATTEMPT + 1))
done

# If the loop finishes without breaking (failed), exit with an error
if [ "$ATTEMPT" -gt "$MAX_ATTEMPTS" ]; then
    echo "SQL Server failed to initialize..."
    exit 1
fi

sqlit connections add mssql --name "ad-works" --server "localhost" --username "sa" --password "$PASSWORD"
