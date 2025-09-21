provider "local" {}

resource "local_file" "sample"{
    filename = "hello.txt"
    content  = "Hello, World! welcome to terraform tool"
}
# move the directory  where this file is present and run below commands
# terraform init
# terraform plan
# terraform apply