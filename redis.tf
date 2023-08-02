# Provisions Elastic Cache Cluster : Redis
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.ENV}-redis"
  engine               = "redis"
  node_type            = var.REDIS_INSTANCE_TYPE   
  num_cache_nodes      = var.REDIS_INSTANCE_COUNT
  parameter_group_name = aws_elasticache_parameter_group.redis_pg.name
  engine_version       = var.REDIS_ENGINE_VERSION
  port                 = var.REDIS_PORT_NUMBER
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.allows_redis.id]
}

# Creates Parameter Group needed for Elastic Cache
resource "aws_elasticache_parameter_group" "redis_pg" {
  name   = "roboshop-${var.ENV}-redis-pg"
  family = "redis6.x"
}


# creates subnet group 
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "roboshop-redis-${var.ENV}-subnetgroup"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-redis-${var.ENV}-subnetgroup"
  }
}