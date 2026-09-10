variable "name" {
  description = "Name/tag for this instance"
  type        = string
}

variable "ami" {
  description = "AMI ID to use for this instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 key pair name to use for SSH access"
  type        = string
}

variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

variable "iam_instance_profile" {
  description = "IAM instance profile name to attach to the instance"
  type        = string
  default     = null
}
