resource "aws_iam_role" "webserver_role" {
    name = "webserver.iam.role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "webserver_iam_instance_profile" {
    name = "webserver.iam.profile"
    role = "${aws_iam_role.webserver_role.name}"
}

#########################
# EC2 Permissions	    #
#########################

resource "aws_iam_policy" "webserver_ec2_access" {
    name = "webserver.iam.policy.EC2Permissions"
    path = "/"
    description = "Policy to permit necessary EC2 permissions for webserver"
    policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowEC2DescribeTags",
      "Effect": "Allow",
      "Action": [
         "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "webserver_ec2_role_attach" {
    name = "webserver.iam.attachment"
    roles = ["${aws_iam_role.webserver_role.name}"]
    policy_arn = "${aws_iam_policy.webserver_ec2_access.arn}"
}

#########################
# S3 Bucket Permissions #
#########################
resource "aws_iam_role_policy" "ssm" {
  depends_on = [aws_iam_role.webserver_role]
  name       = "ssm"
  role       = aws_iam_role.webserver_role.id
  policy     = <<EOF
{"Version": "2012-10-17",
  "Statement": [
  {
  "Effect": "Allow",
  "Action": [
  "ssm:DescribeAssociation",
  "ssm:GetDeployablePatchSnapshotForInstance",
  "ssm:GetDocument",
  "ssm:DescribeDocument",
  "ssm:GetManifest",
  "ssm:GetParameters",
  "ssm:GetParameter",
  "ssm:ListAssociations",
  "ssm:ListInstanceAssociations",
  "ssm:PutInventory",
  "ssm:PutComplianceItems",
  "ssm:PutConfigurePackageResult",
  "ssm:UpdateAssociationStatus",
  "ssm:UpdateInstanceAssociationStatus",
  "ssm:UpdateInstanceInformation"
  ],
  "Resource": "*"
  },
  {
  "Effect": "Allow",
  "Action": [
  "ssmmessages:CreateControlChannel",
  "ssmmessages:CreateDataChannel",
  "ssmmessages:OpenControlChannel",
  "ssmmessages:OpenDataChannel"
  ],
  "Resource": "*"
  },
  {
  "Effect": "Allow",
  "Action": [
  "ec2messages:AcknowledgeMessage",
  "ec2messages:DeleteMessage",
  "ec2messages:FailMessage",
  "ec2messages:GetEndpoint",
  "ec2messages:GetMessages",
  "ec2messages:SendReply"
  ],
  "Resource": "*"
  },
  {
  "Effect": "Allow",
  "Action": [
  "cloudwatch:PutMetricData"
  ],
  "Resource": "*"
  },
  {
  "Effect": "Allow",
  "Action": [
  "ec2:DescribeInstanceStatus"
  ],
  "Resource": "*"
  },
  {
  "Effect": "Allow",
  "Action": [
  "ds:CreateComputer",
  "ds:DescribeDirectories"
  ],
  "Resource": "*"
  },
  {
  "Effect": "Allow",
  "Action": [
  "logs:CreateLogGroup",
  "logs:CreateLogStream",
  "logs:DescribeLogGroups",
  "logs:DescribeLogStreams",
  "logs:PutLogEvents"
  ],
  "Resource": "*"
  },
  {
  "Effect": "Allow",
  "Action": [
  "s3:GetBucketLocation",
  "s3:PutObject",
  "s3:GetObject",
  "s3:GetEncryptionConfiguration",
  "s3:AbortMultipartUpload",
  "s3:ListMultipartUploadParts",
  "s3:ListBucket",
  "s3:ListBucketMultipartUploads"
  ],
  "Resource": "*"
  }
  ]
  }
EOF

}

resource "aws_iam_role_policy" "ssm_instance" {
  depends_on = [aws_iam_role.webserver_role]
  name       = "ssm-instance"
  role       = aws_iam_role.webserver_role.id
  policy     = <<EOF
{"Version": "2012-10-17",
  "Statement": [
  {
  "Effect": "Allow",
  "Action": [
  "ssm:PutParameter"
  ],
  "Resource": [
  "arn:aws:ssm:us-west-2:578774312042:parameter/EC2Rescue/Passwords/i-0a86f03a3eda5a263"
  ]
  },
  {
  "Effect": "Allow",
  "Action": [
  "kms:Encrypt"
  ],
  "Resource": [
  "arn:aws:kms:us-west-2:578774312042:key/naveenrg"
  ]
  }
  ]
  }
EOF

}

resource "aws_iam_role_policy" "password_kms_key_policy" {
  name   = "password_kms_key_policy"
  role   = aws_iam_role.webserver_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": [
        "arn:aws:kms:${var.aws_region}:${var.account_id}:key/${var.password_kms_key}"
      ]
    }
  ]
}

EOF

}
resource "aws_iam_role_policy" "s3policy" {
  depends_on = [aws_iam_role.webserver_role]
  name       = "ucweb=s3policy"
  role       = aws_iam_role.webserver_role.id
  policy     = <<EOF
{"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"s3:*",
"s3:ListAllMyBuckets"
],
"Resource": [
"arn:aws:s3:::*"
]
}
]
}
EOF

}
