# Create bucket
aws s3api create-bucket \
  --bucket girish-bucket \
  --region us-east-1 \
  --acl private

# List bucket
aws s3api list-buckets \
  --region us-east-1

# Upload a file into S3
aws s3api put-object \
  --bucket girish-bucket \
  --key aws-text.txt \
  --body ./text.txt

# Get the list of object in bucket
aws s3api list-objects \
  --bucket girish-bucket \
  --query 'Contents[].{Key: Key, Size: Size}'

# Delete all file in bucket
aws s3 rm s3://girish-bucket \
  --recursive \
  --include '*'

# Delete bucket
aws s3 rb s3://girish-bucket
