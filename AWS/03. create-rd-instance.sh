aws rds create-db-subnet-group \
--db-subnet-group-name girish-db-group-name \
--db-subnet-group-description girish-db-group-name description \
--subnet-ids subnet-016fafedc73e110f9

# Create rd database
aws rds create-db-instance \
    --allocated-storage 20 --db-instance-class db.t2.micro \
    --db-instance-identifier test-instance \
    --engine mysql \
    --enable-cloudwatch-logs-exports '["audit","error","general","slowquery"]' \
    --master-username root \
    --master-user-password root2020

{
    "DBInstance": {
        "DBInstanceIdentifier": "test-instance",
        "DBInstanceClass": "db.t2.micro",
        "Engine": "mysql",
        "DBInstanceStatus": "creating",
        "MasterUsername": "root",
        "AllocatedStorage": 20,
        "PreferredBackupWindow": "05:14-05:44",
        "BackupRetentionPeriod": 1,
        "DBSecurityGroups": [],
        "VpcSecurityGroups": [
            {
                "VpcSecurityGroupId": "sg-ef4acdca",
                "Status": "active"
            }
        ],
        "DBParameterGroups": [
            {
                "DBParameterGroupName": "default.mysql5.7",
                "ParameterApplyStatus": "in-sync"
            }
        ],
        "DBSubnetGroup": {
            "DBSubnetGroupName": "default",
            "DBSubnetGroupDescription": "default",
            "VpcId": "vpc-07d5ce7d",
            "SubnetGroupStatus": "Complete",
            "Subnets": [
                {
                    "SubnetIdentifier": "subnet-8e1ad5e8",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-1c"
                    },
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-f90113c7",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-1e"
                    },
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-a22aabac",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-1f"
                    },
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-9cc856d1",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-1a"
                    },
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-5d8c4702",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-1b"
                    },
                    "SubnetStatus": "Active"
                },
                {
                    "SubnetIdentifier": "subnet-3ea97c1f",
                    "SubnetAvailabilityZone": {
                        "Name": "us-east-1d"
                    },
                    "SubnetStatus": "Active"
                }
            ]
        },
        "PreferredMaintenanceWindow": "sat:06:21-sat:06:51",
        "PendingModifiedValues": {
            "MasterUserPassword": "****",
            "PendingCloudwatchLogsExports": {
                "LogTypesToEnable": [
                    "audit",
                    "error",
                    "general",
                    "slowquery"
                ]
            }
        },
        "MultiAZ": false,
        "EngineVersion": "5.7.22",
        "AutoMinorVersionUpgrade": true,
        "ReadReplicaDBInstanceIdentifiers": [],
        "LicenseModel": "general-public-license",
        "OptionGroupMemberships": [
            {
                "OptionGroupName": "default:mysql-5-7",
                "Status": "in-sync"
            }
        ],
        "PubliclyAccessible": true,
        "StorageType": "gp2",
        "DbInstancePort": 0,
        "StorageEncrypted": false,
        "DbiResourceId": "db-TLNWPVYUXE746NO3NZ3L6QP2H4",
        "CACertificateIdentifier": "rds-ca-2019",
        "DomainMemberships": [],
        "CopyTagsToSnapshot": false,
        "MonitoringInterval": 0,
        "DBInstanceArn": "arn:aws:rds:us-east-1:906459588991:db:test-instance",
        "IAMDatabaseAuthenticationEnabled": false,
        "PerformanceInsightsEnabled": false,
        "DeletionProtection": false,
        "AssociatedRoles": []
    }
}

# Describe rds instance
aws rds  describe-db-instances \
  --db-instance-identifier test-instance \
  --query 'DBInstances[].{DBInstanceIdentifier: DBInstanceIdentifier, Address: Endpoint.Address, Port: Endpoint.Port}'

[
    {
        "DBInstanceIdentifier": "test-instance",
        "Address": "test-instance.cx2lccje66v7.us-east-1.rds.amazonaws.com",
        "Port": 3306
    }
]

# Connect to databasee
mysql -h test-instance.cx2lccje66v7.us-east-1.rds.amazonaws.com -P 3306 -u root -p

# Delete the database
aws rds delete-db-instance \
  --db-instance-identifier test-instance \
  --skip-final-snapshot