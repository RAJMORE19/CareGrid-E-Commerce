resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-redis"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.project_name}-${var.environment}-redis"

  description = "CareGrid application cache"

  engine    = "redis"
  node_type = var.redis_node_type
  port      = 6379

  num_cache_clusters = 1

  subnet_group_name = aws_elasticache_subnet_group.main.name

  security_group_ids = [
    aws_security_group.redis.id
  ]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  automatic_failover_enabled = false
  multi_az_enabled           = false

  apply_immediately = true
}
