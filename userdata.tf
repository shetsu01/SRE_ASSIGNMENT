
data "template_file" "init" {
  template = file("script.tpl")
  vars = {
    DB_connection_string   = module.db.db_instance_address
    DB_name                = local.db_name
    DB_user                = local.DB_user
    DB_pass                = local.DB_pass
    DB_host                = module.db.db_instance_address
  }
}
