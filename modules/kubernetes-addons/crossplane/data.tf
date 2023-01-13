data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "ListAllBuckets"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["s3:ListAllMyBuckets"]
  }

  statement {
    sid       = "AllowBucketActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:::*"]

    actions = [

      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:ListBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetAnalyticsConfiguration",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:GetBucketPolicy",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetIntelligentTieringConfiguration",
      "s3:GetInventoryConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetMetricsConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:GetAccessPoint",
      "s3:GetAccountPublicAccessBlock",
      "s3:PutAccelerateConfiguration",
      "s3:PutAnalyticsConfiguration",
      "s3:PutBucketAcl",
      "s3:PutBucketCORS",
      "s3:PutBucketLogging",
      "s3:PutBucketNotification",
      "s3:PutBucketObjectLockConfiguration",
      "s3:PutBucketOwnershipControls",
      "s3:PutBucketPolicy",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketRequestPayment",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutBucketWebsite",
      "s3:PutEncryptionConfiguration",
      "s3:PutIntelligentTieringConfiguration",
      "s3:PutInventoryConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutMetricsConfiguration",
      "s3:PutReplicationConfiguration",
      "s3:PutAccessPointPublicAccessBlock",
      "s3:PutAccountPublicAccessBlock",
      "s3:PutStorageLensConfiguration"
    ]
  }

  statement {
    sid       = "AllowObjectsActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:::*/*"]

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectAttributes",
      "s3:GetObjectLegalHold",
      "s3:GetObjectRetention",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionAttributes",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectLegalHold",
      "s3:PutObjectRetention",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging"
    ]
  }

  statement {
    sid       = "AllowLambdaAccessPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3-object-lambda:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:accesspoint/*"]

    actions = [

      "s3:GetAccessPointConfigurationForObjectLambda",
      "s3:GetAccessPointForObjectLambda",
      "s3:GetAccessPointPolicyForObjectLambda",
      "s3:GetAccessPointPolicyStatusForObjectLambda",
      "s3:PutAccessPointConfigurationForObjectLambda",
      "s3:PutAccessPointPolicyForObjectLambda"
    ]
  }

  statement {
    sid       = "AllowAccessPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:accesspoint/*"]

    actions = [

      "s3:GetAccessPointPolicy",
      "s3:GetAccessPointPolicyStatus",
      "s3:PutAccessPointPolicy"
    ]
  }

  statement {
    sid       = "AllowJobPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:job/*"]

    actions = [

      "s3:GetJobTagging",
      "s3:PutJobTagging"
    ]
  }

  statement {
    sid       = "AllowMultiRegionAccessPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3::${var.addon_context.aws_caller_identity_account_id}:accesspoint/*"]

    actions = [

      "s3:GetMultiRegionAccessPoint",
      "s3:GetMultiRegionAccessPointPolicy",
      "s3:GetMultiRegionAccessPointPolicyStatus",
      "s3:GetMultiRegionAccessPointRoutes",
      "s3:PutMultiRegionAccessPointPolicy"
    ]
  }

  statement {
    sid       = "AllowStorageLensActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:storage-lens/*"]

    actions = [

      "s3:GetStorageLensConfiguration",
      "s3:GetStorageLensConfigurationTagging",
      "s3:GetStorageLensDashboard",
      "s3:PutStorageLensConfigurationTagging"
    ]
  }
}
