variable "instances" {
    type     = map
    default = {
        mongodb  = "t3.small"
        redis    = "t3.micro"
        mysql    = "t3.medium"
        rabbitmq = "t3.micro"
        catalogue= "t3.micro"
        user     = "t3.micro"
        cart     = "t3.micro"
        shipping = "t3.medium"
        payment  = "t3.micro"
        dispatch = "t3.micro"
        web      = "t3.micro"
        }
}
variable "allow_all" {
    type = string
    default = "sg-09c7c70bd56f0d58b"
}
variable "zone_id" {
    default ="Z07608533HHBQHW47XU3F"
}
variable "domain_name" {
    default = "lingaiah.online"
}