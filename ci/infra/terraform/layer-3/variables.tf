/**
 * Copyright 2020 Google LLC
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

variable "project_id" {
  type = string
  default = "pleasedontfail"
}
variable "region" {
  description = "Location for load balancer and Cloud Run resources"
  default     = "gcp-europe-west1"
}

variable "ssl" {
  description = "Run load balancer on HTTPS and provision managed certificate with provided `domain`."
  type        = bool
  default     = true
}

# variable "domain" {
#   description = "Domain name to run the load balancer on. Used if `ssl` is `true`."
#   type        = string
#   #default     = "notme.whoatemyfrubes.stevengonsalvez.com"
#   #default = null
# }

variable "lb-name" {
  description = "Name for load balancer and associated resources"
  default     = "run-lb"
}

variable "REGION" {
  description = "Region for Cloud Run resources"
  default     = "europe-west1"
}
