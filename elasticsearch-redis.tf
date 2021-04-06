module "elasticache_redis" {
  source = "git::ssh://git@github.com:rgnaveen/terraform-elasticcache-redis.git"
  elasticache_az           = "Multi-AZ"
  elasticache_cluster_name = "webstack"
  elasticache_subnet       = "subnet-075c1ed1f69f2c9ea"
  global_vpc_id            = "vpc-03cfd3eac40e54efb"
  global_vpc_subnet_cidr   = "172.31.16.0/20"
  elasticache_tag_environment   = "dev"
}
