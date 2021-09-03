output "zipslr-vpc" {
  value = module.vpc.vpc_id
}

output "tags" {
  value = merge(
    var.additional_tags,
    {
      Name      =  "${var.project}-${var.env}"
    }
  )
}
