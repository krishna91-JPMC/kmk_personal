#!/bin/bash

# Define your S3 bucket name and directory containing the artifacts
S3_BUCKET="your-s3-bucket"
S3_DIRECTORY="path/to/artifacts"

# Define your local Docker registry address
LOCAL_REGISTRY="localhost:5000"

# Loop through the artifacts in the S3 bucket
aws s3 ls s3://$S3_BUCKET/$S3_DIRECTORY/ | while read -r line; do
    artifact=$(echo $line | awk '{print $4}')
    echo "Downloading artifact: $artifact"
    aws s3 cp s3://$S3_BUCKET/$S3_DIRECTORY/$artifact .

    # Assuming the artifact is a Docker image, tag and push it to the local registry
    docker load -i $artifact
    docker tag $artifact $LOCAL_REGISTRY/$artifact
    docker push $LOCAL_REGISTRY/$artifact

    # Clean up the downloaded image
    rm $artifact
done
===========================================================================================================================================================
Instructions:
1. Replace "your-s3-bucket" with the actual name of your S3 bucket and "path/to/artifacts" with the path to the directory containing your artifacts.
2. Make sure your local Docker registry is running. If it's running on a different port or host, adjust the "LOCAL_REGISTRY" variable accordingly.
3. Save this script in a file (e.g., download_and_push.sh) and make it executable using chmod +x download_and_push.sh.
4. Run the script using ./download_and_push.sh.
5. This script assumes that the artifacts in your S3 bucket are Docker images. If they are a different type of artifact, you might need to adjust the script accordingly. Additionally, it doesn't handle authentication to your AWS account or Docker registry, so make sure you have the necessary permissions and credentials set up.
