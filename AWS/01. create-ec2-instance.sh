# Sign up for AWS free tier
# https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc

# Create billing alerts
# Cloud Watch
# Budget

# Install aws cli
# https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
# AWS CLI version 1 (recommended)

aws configure

# Checks whether you have the required permissions for the action, without actually making the request,
# and provides an error response. If you have the required permissions, the error response is DryRunOperation .
# --dry-run

CIDR Block - Available Hosts per Subnet
/16        - 65531
/20        - 4096
/24        - 256
/28        - 11

# Total CIDR Ip address
# https://docs.netgate.com/pfsense/en/latest/book/network/understanding-cidr-subnet-mask-notation.html

# Aws reserves first 3 available host IP address
1. VPC Router
2. AWS DNS
3. Future Values

# Create a VPC
aws ec2 create-vpc --cidr-block 10.32.0.0/20  --region us-east-1 \
  --query 'Vpc.{VpcId: VpcId}'

{
  "VpcId": "vpc-09a48abc6d6cce1cf"
}

# Create a Subnet
aws ec2 create-subnet \
  --vpc-id vpc-09a48abc6d6cce1cf \
  --cidr-block 10.32.0.1/24 \
  --region us-east-1 \
  --query 'Subnet.{SubnetId: SubnetId}'

{
    "SubnetId": "subnet-00c8f6662b5bbf0d0"
}


# Create a Internet-gateway
aws ec2 create-internet-gateway \
  --region us-east-1 \
  --query 'InternetGateway.{InternetGatewayId: InternetGatewayId}'

{
    "InternetGatewayId": "igw-0f1a90ae375542231"
}


# Attach internet gateway
aws ec2 attach-internet-gateway \
  --vpc-id vpc-09a48abc6d6cce1cf \
  --region us-east-1 \
  --internet-gateway-id igw-0f1a90ae375542231

# Create Route Table
aws ec2 create-route-table \
  --vpc-id vpc-09a48abc6d6cce1cf \
  --region us-east-1 \
  --query 'RouteTable.{RouteTableId: RouteTableId}'

{
    "RouteTableId": "rtb-0d488e482c2f42666"
}


# Create Route
aws ec2 create-route \
  --route-table-id rtb-0d488e482c2f42666 \
  --destination-cidr-block 0.0.0.0/0 \
  --region us-east-1 \
  --gateway-id igw-0f1a90ae375542231

aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=vpc-2f09a348" \
  --region us-east-1 \
  --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}'

# Associate route table to subnet
aws ec2 associate-route-table \
  --subnet-id subnet-00c8f6662b5bbf0d0 \
  --region us-east-1 \
  --route-table-id rtb-0d488e482c2f42666

# Enable public ip for your Subnet
aws ec2 modify-subnet-attribute \
  --subnet-id subnet-00c8f6662b5bbf0d0 \
  --region us-east-1 \
  --map-public-ip-on-launch

# Create Key Pair
aws ec2 create-key-pair \
  --key-name GirishKeyPairNew \
  --query 'KeyMaterial' \
  --region us-east-1 \
  --output text > GirishKeyPairNew.pem

chmod 400 GirishKeyPair.pem

# Create Security Group
aws ec2 create-security-group \
  --group-name SSHAccess \
  --description "Security group for SSH access" \
  --region us-east-1 \
  --vpc-id vpc-09a48abc6d6cce1cf

{
    "GroupId": "sg-086fddbcbcf989c68"
}

# Create rules in Security Group
aws ec2 authorize-security-group-ingress \
  --group-id sg-086fddbcbcf989c68 \
  --protocol tcp \
  --port 22 \
  --cidr 68.2.246.213/32 \
  --region us-east-1

# Create ec2 instance
aws ec2 run-instances \
  --image-id ami-a4827dc9 \
  --count 1 \
  --instance-type t2.micro \
  --key-name GirishKeyPairNew \
  --security-group-ids sg-086fddbcbcf989c68 \
  --subnet-id subnet-00c8f6662b5bbf0d0 \
  --region us-east-1

{
    "Groups": [],
    "Instances": [
        {
            "AmiLaunchIndex": 0,
            "ImageId": "ami-a4827dc9",
            "InstanceId": "i-0fd46c948d9d6e0a6",
            "InstanceType": "t2.micro",
            "KeyName": "GirishKeyPair",
            "LaunchTime": "2020-06-07T19:27:15+00:00",
            "Monitoring": {
                "State": "disabled"
            },
            "Placement": {
                "AvailabilityZone": "us-east-1f",
                "GroupName": "",
                "Tenancy": "default"
            },
            "PrivateDnsName": "ip-10-32-0-117.ec2.internal",
            "PrivateIpAddress": "10.32.0.117",
            "ProductCodes": [],
            "PublicDnsName": "",
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "StateTransitionReason": "",
            "SubnetId": "subnet-00c8f6662b5bbf0d0",
            "VpcId": "vpc-09a48abc6d6cce1cf",
            "Architecture": "x86_64",
            "BlockDeviceMappings": [],
            "ClientToken": "",
            "EbsOptimized": false,
            "Hypervisor": "xen",
            "NetworkInterfaces": [
                {
                    "Attachment": {
                        "AttachTime": "2020-06-07T19:27:15+00:00",
                        "AttachmentId": "eni-attach-02d887d1514c67810",
                        "DeleteOnTermination": true,
                        "DeviceIndex": 0,
                        "Status": "attaching"
                    },
                    "Description": "",
                    "Groups": [
                        {
                            "GroupName": "SSHAccess",
                            "GroupId": "sg-086fddbcbcf989c68"
                        }
                    ],
                    "Ipv6Addresses": [],
                    "MacAddress": "16:d1:a6:8f:3f:df",
                    "NetworkInterfaceId": "eni-025ee48092a4b7623",
                    "OwnerId": "906459588991",
                    "PrivateIpAddress": "10.32.0.117",
                    "PrivateIpAddresses": [
                        {
                            "Primary": true,
                            "PrivateIpAddress": "10.32.0.117"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Status": "in-use",
                    "SubnetId": "subnet-00c8f6662b5bbf0d0",
                    "VpcId": "vpc-09a48abc6d6cce1cf",
                    "InterfaceType": "interface"
                }
            ],
            "RootDeviceName": "/dev/xvda",
            "RootDeviceType": "ebs",
            "SecurityGroups": [
                {
                    "GroupName": "SSHAccess",
                    "GroupId": "sg-086fddbcbcf989c68"
                }
            ],
            "SourceDestCheck": true,
            "StateReason": {
                "Code": "pending",
                "Message": "pending"
            },
            "VirtualizationType": "hvm",
            "CpuOptions": {
                "CoreCount": 1,
                "ThreadsPerCore": 1
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "open"
            },
            "MetadataOptions": {
                "State": "pending",
                "HttpTokens": "optional",
                "HttpPutResponseHopLimit": 1,
                "HttpEndpoint": "enabled"
            }
        }
    ],
    "OwnerId": "906459588991",
    "ReservationId": "r-0aab6b0d49a4f8ef4"
}


aws ec2 describe-instances --instance-ids i-0941482217ef0fb61

{
    "Reservations": [
        {
            "Groups": [],
            "Instances": [
                {
                    "AmiLaunchIndex": 0,
                    "ImageId": "ami-a4827dc9",
                    "InstanceId": "i-0fd46c948d9d6e0a6",
                    "InstanceType": "t2.micro",
                    "KeyName": "GirishKeyPair",
                    "LaunchTime": "2020-06-07T19:27:15+00:00",
                    "Monitoring": {
                        "State": "disabled"
                    },
                    "Placement": {
                        "AvailabilityZone": "us-east-1f",
                        "GroupName": "",
                        "Tenancy": "default"
                    },
                    "PrivateDnsName": "ip-10-32-0-117.ec2.internal",
                    "PrivateIpAddress": "10.32.0.117",
                    "ProductCodes": [],
                    "PublicDnsName": "",
                    "PublicIpAddress": "34.239.158.29",
                    "State": {
                        "Code": 16,
                        "Name": "running"
                    },
                    "StateTransitionReason": "",
                    "SubnetId": "subnet-00c8f6662b5bbf0d0",
                    "VpcId": "vpc-09a48abc6d6cce1cf",
                    "Architecture": "x86_64",
                    "BlockDeviceMappings": [
                        {
                            "DeviceName": "/dev/xvda",
                            "Ebs": {
                                "AttachTime": "2020-06-07T19:27:16+00:00",
                                "DeleteOnTermination": true,
                                "Status": "attached",
                                "VolumeId": "vol-0004a19b301f28c71"
                            }
                        }
                    ],
                    "ClientToken": "",
                    "EbsOptimized": false,
                    "Hypervisor": "xen",
                    "NetworkInterfaces": [
                        {
                            "Association": {
                                "IpOwnerId": "amazon",
                                "PublicDnsName": "",
                                "PublicIp": "34.239.158.29"
                            },
                            "Attachment": {
                                "AttachTime": "2020-06-07T19:27:15+00:00",
                                "AttachmentId": "eni-attach-02d887d1514c67810",
                                "DeleteOnTermination": true,
                                "DeviceIndex": 0,
                                "Status": "attached"
                            },
                            "Description": "",
                            "Groups": [
                                {
                                    "GroupName": "SSHAccess",
                                    "GroupId": "sg-086fddbcbcf989c68"
                                }
                            ],
                            "Ipv6Addresses": [],
                            "MacAddress": "16:d1:a6:8f:3f:df",
                            "NetworkInterfaceId": "eni-025ee48092a4b7623",
                            "OwnerId": "906459588991",
                            "PrivateIpAddress": "10.32.0.117",
                            "PrivateIpAddresses": [
                                {
                                    "Association": {
                                        "IpOwnerId": "amazon",
                                        "PublicDnsName": "",
                                        "PublicIp": "34.239.158.29"
                                    },
                                    "Primary": true,
                                    "PrivateIpAddress": "10.32.0.117"
                                }
                            ],
                            "SourceDestCheck": true,
                            "Status": "in-use",
                            "SubnetId": "subnet-00c8f6662b5bbf0d0",
                            "VpcId": "vpc-09a48abc6d6cce1cf",
                            "InterfaceType": "interface"
                        }
                    ],
                    "RootDeviceName": "/dev/xvda",
                    "RootDeviceType": "ebs",
                    "SecurityGroups": [
                        {
                            "GroupName": "SSHAccess",
                            "GroupId": "sg-086fddbcbcf989c68"
                        }
                    ],
                    "SourceDestCheck": true,
                    "VirtualizationType": "hvm",
                    "CpuOptions": {
                        "CoreCount": 1,
                        "ThreadsPerCore": 1
                    },
                    "CapacityReservationSpecification": {
                        "CapacityReservationPreference": "open"
                    },
                    "HibernationOptions": {
                        "Configured": false
                    },
                    "MetadataOptions": {
                        "State": "applied",
                        "HttpTokens": "optional",
                        "HttpPutResponseHopLimit": 1,
                        "HttpEndpoint": "enabled"
                    }
                }
            ],
            "OwnerId": "906459588991",
            "ReservationId": "r-0aab6b0d49a4f8ef4"
        }
    ]
}

ssh -i "GirishKeyPairNew.pem" ec2-user@52.207.105.248


# Delete your ec2
aws ec2 terminate-instances --instance-ids i-0d7ea3bef84d80ac7 --region us-east-1

# Delete your security group
aws ec2 delete-security-group --group-id sg-086fddbcbcf989c68

# Delete your subnets
aws ec2 delete-subnet --subnet-id subnet-00c8f6662b5bbf0d0

# Delete your custom route table
aws ec2 delete-route-table --route-table-id rtb-0d488e482c2f42666

# Detach your Internet gateway from your VPC
aws ec2 detach-internet-gateway --internet-gateway-id igw-0f1a90ae375542231 --vpc-id vpc-09a48abc6d6cce1cf

# Delete your Internet gateway
aws ec2 delete-internet-gateway --internet-gateway-id igw-0f1a90ae375542231

# Delete your VPC
aws ec2 delete-vpc --vpc-id vpc-09a48abc6d6cce1cf