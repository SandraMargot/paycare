# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install the Python dependencies
RUN pip install -r requirements.txt

# Make port 8090 available to the world outside this container
EXPOSE 8090

# Make a volume mount point for the input/output CSV files
VOLUME ["/app/input_data.csv", "/app/output_data.csv"]

# Commande par défaut : lance l’ETL
CMD ["python", "app/etl.py"]