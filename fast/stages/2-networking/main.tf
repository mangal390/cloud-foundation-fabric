/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description Networking folder and hierarchical policy.

locals {
  # combine all regions from variables and subnets
  regions = values(var.regions)
}

module "folder" {
  source        = "../../../modules/folder"
  parent        = "organizations/${var.organization.id}"
  name          = "Networking"
  folder_create = var.folder_ids.networking == null
  id            = var.folder_ids.networking
  firewall_policy_factory = {
    cidr_file   = "${var.factories_config.data_dir}/cidrs.yaml"
    policy_name = var.factories_config.firewall_policy_name
    rules_file  = "${var.factories_config.data_dir}/hierarchical-policy-rules.yaml"
  }
  firewall_policy_association = {
    factory-policy = var.factories_config.firewall_policy_name
  }
}

module "net-project" {
  source          = "../../../modules/project"
  billing_account = var.billing_account.id
  name            = "prod-net-core-0"
  parent          = var.folder_ids.networking
  prefix          = var.prefix
  services = [
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
  ]
  shared_vpc_host_config = {
    enabled = true
  }
}
