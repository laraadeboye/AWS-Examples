# Require the necessary libraries
require 'aws-sdk-s3'  # AWS SDK for interacting with S3 services
require 'securerandom'  # For generating random UUIDs
require 'pry'  # For debugging (if needed)

# Fetch the bucket name from environment variables and set the region
bucket_name = ENV['BUCKET_NAME']  # Fetch the S3 bucket name from the environment variables
region = 'ca-central-1'  # Specify the AWS region where the bucket will be created

# Initialize the S3 client
client = Aws::S3::Client.new(region: region)  # Create a new S3 client with the specified region

# Create a new S3 bucket
resp = client.create_bucket({
  bucket: bucket_name,  # Specify the name of the bucket to be created
  create_bucket_configuration: {
    location_constraint: region,  # Set the region constraint for the bucket location
  }
})


# Generate a random number of files between 1 and 6
number_of_files = 1 + rand(6)  # Generate a random number between 1 and 6
puts "Number of files: #{number_of_files}"  # Print the number of files to be created

# Create and upload the files
number_of_files.times do |i|  # Iterate from 0 to number_of_files - 1
  puts "Creating file number: #{i + 1}"  # Print the current file number being created
  
  # Generate the filename and output path
  filename = "file_#{i}.txt"  # Construct the filename using the current index
  output_path = "/tmp/#{filename}"  # Construct the full path for the output file

  # Write a random UUID to the file
  File.open(output_path, "w") do |f|  # Open the file for writing
    f.write(SecureRandom.uuid)  # Write a randomly generated UUID to the file
  end

  # Read the file and upload it to S3
  File.open(output_path, 'rb') do |file|  # Open the file for reading in binary mode
    client.put_object(
      bucket: bucket_name,  # Specify the S3 bucket name
      key: filename,  # Specify the key (filename) for the object in S3
      body: file  # Provide the file content as the body of the object
    )
  end

  puts "Uploaded #{filename} to bucket #{bucket_name}"  # Print a confirmation message for the uploaded file

  # Optional: use Pry for debugging
  # Uncomment the next line to start a Pry session here
  # binding.pry  # Start a Pry session for debugging if needed

# To run in cmd enter: BUCKET_NAME='my-rub-sdk-bucket' bundle exec ruby s3.rb

end