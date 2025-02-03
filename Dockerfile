# Base image: using Python 3.9 slim
FROM python:3.9-slim

# Set environment variables for Python and Cloud Run
ENV PYTHONUNBUFFERED=1 \
    PORT=8080

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gnupg \
    wget \
    curl \
    unzip \
    jq \
 && rm -rf /var/lib/apt/lists/*

# Add the Google signing key and Chrome repository, then install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Install the matching ChromeDriver version using the Chrome major version
RUN set -ex; \
    # Get the major version of Google Chrome (example: "132")
    CHROME_MAJOR_VERSION=$(google-chrome --product-version | cut -d '.' -f1); \
    echo "Detected Chrome major version: $CHROME_MAJOR_VERSION"; \
    \
    # Try to fetch the matching ChromeDriver version from the primary source
    DRIVERVER=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR_VERSION}"); \
    if echo "$DRIVERVER" | grep -q "NoSuchKey"; then \
      echo "No matching ChromeDriver found at primary source for Chrome major version $CHROME_MAJOR_VERSION."; \
      \
      # Query alternative endpoint for the full driver version using Chrome for Testing
      DRIVERVER=$(curl -s "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_${CHROME_MAJOR_VERSION}"); \
      echo "Using Chrome for Testing ChromeDriver version: $DRIVERVER"; \
      wget -q --continue -O /tmp/chromedriver_linux64.zip "https://edgedl.me.gvt1.com/chrome/chrome-for-testing/${DRIVERVER}/linux64/chromedriver-linux64.zip"; \
    else \
      echo "Found matching ChromeDriver version: $DRIVERVER"; \
      wget -q --continue -O /tmp/chromedriver_linux64.zip "https://chromedriver.storage.googleapis.com/${DRIVERVER}/chromedriver_linux64.zip"; \
    fi; \
    unzip -o /tmp/chromedriver_linux64.zip -d /usr/local/bin/; \
    if [ -f /usr/local/bin/chromedriver ]; then \
         echo "ChromeDriver installed directly in /usr/local/bin"; \
    elif [ -d /usr/local/bin/chromedriver-linux64 ]; then \
         mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver; \
         rm -rf /usr/local/bin/chromedriver-linux64; \
    else \
         echo "Could not locate ChromeDriver binary"; \
         exit 1; \
    fi; \
    chmod +x /usr/local/bin/chromedriver; \
    rm /tmp/chromedriver_linux64.zip

# Set the working directory to /app
WORKDIR /app

# Copy requirements.txt first to leverage Docker cache and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code to the image
COPY . .

# Expose the port that Cloud Run will use
EXPOSE 8080

# Run the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--threads", "4", "--timeout", "0", "app:app"] 