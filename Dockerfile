FROM python:3.12-slim

# Install system dependencies required for OpenCV and dlib (face-recognition)
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create needed directories that might be ignored
RUN mkdir -p uploads processed models dataset temp_uploads static/processed static/temp

# Expose port (Render sets PORT environment variable, defaults to 5000 if not set)
EXPOSE 5000

# Start gunicorn server
CMD ["gunicorn", "snapclass:app", "--bind", "0.0.0.0:5000", "--workers", "1", "--threads", "2", "--timeout", "120"]
