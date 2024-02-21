variable "wrkspc_name" {
  type = string
  description = "Workspace name"
}

variable "wrkspc_rg_name" {
  type = string
  description = "Workspace resource group"
}

variable "wrkspc_description" {
  type = string
  description = "Workspace description"
}

variable "wrkspc_friendly_name" {
  type = string
  description = "Workspace friendly name" 
}

variable "deploy_location" {
  type        = string
  description = "location"
}

variable "tags_name" {
  type        = map(any)
  description = "Tags"
}
