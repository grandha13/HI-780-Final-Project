# Use official Python 3.12 slim image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Google Cloud SDK for Application Default Credentials
RUN curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir=/usr/local
ENV PATH="/usr/local/google-cloud-sdk/bin:${PATH}"

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Jupyter if not already in requirements.txt
RUN pip install --no-cache-dir notebook

# Copy the notebook and any supporting files
COPY . .

# Expose Jupyter port
EXPOSE 8888

# Set environment variable for ADC (mount your credentials at runtime)
ENV GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/service-account.json"

# Run Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
