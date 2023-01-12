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
    ]
  }

  statement {
    sid       = "AllowBucketActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:::*"]

    actions = [

      "GetAccelerateConfiguration",
      "GetAnalyticsConfiguration",
      "GetBucketAcl",
      "GetBucketCORS",
      "GetBucketLocation",
      "GetBucketLogging",
      "GetBucketNotification",
      "GetBucketObjectLockConfiguration",
      "GetBucketOwnershipControls",
      "GetBucketPolicy",
      "GetBucketPolicyStatus",
      "GetBucketPublicAccessBlock",
      "GetBucketRequestPayment",
      "GetBucketTagging",
      "GetBucketVersioning",
      "GetBucketWebsite",
      "GetEncryptionConfiguration",
      "GetIntelligentTieringConfiguration",
      "GetInventoryConfiguration",
      "GetLifecycleConfiguration",
      "GetMetricsConfiguration",
      "GetReplicationConfiguration",
      "GetAccessPoint",
      "GetAccountPublicAccessBlock",
      "PutAccelerateConfiguration",
      "PutAnalyticsConfiguration",
      "PutBucketAcl",
      "PutBucketCORS",
      "PutBucketLogging",
      "PutBucketNotification",
      "PutBucketObjectLockConfiguration",
      "PutBucketOwnershipControls",
      "PutBucketPolicy",
      "PutBucketPublicAccessBlock",
      "PutBucketRequestPayment",
      "PutBucketTagging",
      "PutBucketVersioning",
      "PutBucketWebsite",
      "PutEncryptionConfiguration",
      "PutIntelligentTieringConfiguration",
      "PutInventoryConfiguration",
      "PutLifecycleConfiguration",
      "PutMetricsConfiguration",
      "PutReplicationConfiguration",
      "PutAccessPointPublicAccessBlock",
      "PutAccountPublicAccessBlock",
      "PutStorageLensConfiguration"
    ]
  }

  statement {
    sid       = "AllowObjectsActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:::*/*"]

    actions = [
      "GetObject",
      "GetObjectAcl",
      "GetObjectAttributes",
      "GetObjectLegalHold",
      "GetObjectRetention",
      "GetObjectTagging",
      "GetObjectTorrent",
      "GetObjectVersion",
      "GetObjectVersionAcl",
      "GetObjectVersionAttributes",
      "GetObjectVersionForReplication",
      "GetObjectVersionTagging",
      "GetObjectVersionTorrent",
      "PutObject",
      "PutObjectAcl",
      "PutObjectLegalHold",
      "PutObjectRetention",
      "PutObjectTagging",
      "PutObjectVersionAcl",
      "PutObjectVersionTagging"
    ]
  }

  statement {
    sid       = "AllowLambdaAccessPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3-object-lambda:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:accesspoint/*"]

    actions = [

      "GetAccessPointConfigurationForObjectLambda",
      "GetAccessPointForObjectLambda",
      "GetAccessPointPolicyForObjectLambda",
      "GetAccessPointPolicyStatusForObjectLambda",
      "PutAccessPointConfigurationForObjectLambda",
      "PutAccessPointPolicyForObjectLambda"
    ]
  }

  statement {
    sid       = "AllowAccessPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:accesspoint/*"]

    actions = [

      "GetAccessPointPolicy",
      "GetAccessPointPolicyStatus",
      "PutAccessPointPolicy"
    ]
  }

  statement {
    sid       = "AllowJobPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:job/${JobId}"]

    actions = [

      "GetJobTagging",
      "PutJobTagging"
    ]
  }

  statement {
    sid       = "AllowMultiRegionAccessPointActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3::${var.addon_context.aws_caller_identity_account_id}:accesspoint/${AccessPointAlias}"]

    actions = [

      "GetMultiRegionAccessPoint",
      "GetMultiRegionAccessPointPolicy",
      "GetMultiRegionAccessPointPolicyStatus",
      "GetMultiRegionAccessPointRoutes",
      "PutMultiRegionAccessPointPolicy"
    ]
  }

  statement {
    sid       = "AllowStorageLensActions"
    effect    = "Allow"
    resources = ["arn:${var.addon_context.aws_partition_id}:s3:${var.addon_context.aws_region_name}:${var.addon_context.aws_caller_identity_account_id}:storage-lens/${ConfigId}"]

    actions = [

      "GetStorageLensConfiguration",
      "GetStorageLensConfigurationTagging",
      "GetStorageLensDashboard",
      "PutStorageLensConfigurationTagging"
    ]
  }
}
