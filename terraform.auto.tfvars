oci_tenancy_ocid          = "ocid1.tenancy.oc1..aaaaaaaazvfohepms6hmneatm46rnxiaxyaf67fls7hhjfl5lsx5d2w2elgq"
oci_region                = "eu-frankfurt-1"
oci_drp_region            = "eu-stockholm-1"
oci_compartment_parent_id = "ocid1.tenancy.oc1..aaaaaaaazvfohepms6hmneatm46rnxiaxyaf67fls7hhjfl5lsx5d2w2elgq"

home_mongo_image_ocid = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaareak7ogvbyd4idsvsslsmxh44bt7ufd4vxlosyrtniwqwras2kla"

bastion_allowlist_ips = [
  "68.67.62.190/32" # Gardaworld Montreal VPN
]


# mgmt

dev_mgmt_access_ip_list = [
  "68.67.62.190/32",   # Gardaworld Montreal VPN
  "52.174.122.247/32", # Sesami Cloud VPN
  "213.251.33.249/32"  # Sesami On-Demand VPN
]

demo_mgmt_access_ip_list = [
  "68.67.62.190/32",   # Gardaworld Montreal VPN
  "52.174.122.247/32", # Sesami Cloud VPN
  "213.251.33.249/32"  # Sesami On-Demand VPN
]

preprod_mgmt_access_ip_list = [
  "68.67.62.190/32",   # Gardaworld Montreal VPN
  "52.174.122.247/32", # Sesami Cloud VPN
  "213.251.33.249/32"  # Sesami On-Demand VPN
]

# mgmt_access_ip_list = [
#   "68.67.62.190/32", # Gardaworld Montreal VPN
# ]

# mgmt_argocd_access_ip_list = [
#   "68.67.62.190/32" # Gardaworld Montreal VPN
# ]


# kafka

dev_kafka_access_ip_list = [
  "68.67.62.190/32",   # Gardaworld Montreal VPN
  "52.174.122.247/32", # Sesami Cloud VPN
  "213.251.33.249/32"  # Sesami On-Demand VPN
]

qa_kafka_access_ip_list = [
  "68.67.62.190/32",   # Gardaworld Montreal VPN
  "52.174.122.247/32", # Sesami Cloud VPN
  "213.251.33.249/32"  # Sesami On-Demand VPN
]

demo_kafka_access_ip_list = [
  "68.67.62.190/32" # Gardaworld Montreal VPN
]

# uat_kafka_access_ip_list = [
#   "68.67.62.190/32",   # Gardaworld Montreal VPN
#   "38.2.177.217/32"    # cco.uat.sesami.io
# ]

preprod_kafka_access_ip_list = [
  "68.67.62.190/32" # Gardaworld Montreal VPN
]

prod_kafka_access_ip_list = [
  "68.67.62.190/32",  # Gardaworld Montreal VPN
  "130.162.219.68/32" # cco.sesami.io
]


# web

dev_web_access_ip_list = [
  "173.245.48.0/20", # Cloudflare
  "103.21.244.0/22",
  "103.22.200.0/22",
  "103.31.4.0/22",
  "141.101.64.0/18",
  "108.162.192.0/18",
  "190.93.240.0/20",
  "188.114.96.0/20",
  "197.234.240.0/22",
  "198.41.128.0/17",
  "162.158.0.0/15",
  "104.16.0.0/13",
  "104.24.0.0/14",
  "172.64.0.0/13",
  "131.0.72.0/22",

  "0.0.0.0/0" # TODO: That should not exists
]

qa_web_access_ip_list = [
  "173.245.48.0/20", # Cloudflare
  "103.21.244.0/22",
  "103.22.200.0/22",
  "103.31.4.0/22",
  "141.101.64.0/18",
  "108.162.192.0/18",
  "190.93.240.0/20",
  "188.114.96.0/20",
  "197.234.240.0/22",
  "198.41.128.0/17",
  "162.158.0.0/15",
  "104.16.0.0/13",
  "104.24.0.0/14",
  "172.64.0.0/13",
  "131.0.72.0/22",

  "0.0.0.0/0" # TODO: That should not exists
]

demo_web_access_ip_list = [
  "173.245.48.0/20", # Cloudflare
  "103.21.244.0/22",
  "103.22.200.0/22",
  "103.31.4.0/22",
  "141.101.64.0/18",
  "108.162.192.0/18",
  "190.93.240.0/20",
  "188.114.96.0/20",
  "197.234.240.0/22",
  "198.41.128.0/17",
  "162.158.0.0/15",
  "104.16.0.0/13",
  "104.24.0.0/14",
  "172.64.0.0/13",
  "131.0.72.0/22",

  "0.0.0.0/0" # TODO: That should not exists
]

# uat_web_access_ip_list = [
#   "173.245.48.0/20",   # Cloudflare
#   "103.21.244.0/22",
#   "103.22.200.0/22",
#   "103.31.4.0/22",
#   "141.101.64.0/18",
#   "108.162.192.0/18",
#   "190.93.240.0/20",
#   "188.114.96.0/20",
#   "197.234.240.0/22",
#   "198.41.128.0/17",
#   "162.158.0.0/15",
#   "104.16.0.0/13",
#   "104.24.0.0/14",
#   "172.64.0.0/13",
#   "131.0.72.0/22",

#   "0.0.0.0/0" # TODO: That should not exists
# ]

preprod_web_access_ip_list = [
  "173.245.48.0/20", # Cloudflare
  "103.21.244.0/22",
  "103.22.200.0/22",
  "103.31.4.0/22",
  "141.101.64.0/18",
  "108.162.192.0/18",
  "190.93.240.0/20",
  "188.114.96.0/20",
  "197.234.240.0/22",
  "198.41.128.0/17",
  "162.158.0.0/15",
  "104.16.0.0/13",
  "104.24.0.0/14",
  "172.64.0.0/13",
  "131.0.72.0/22",

  "0.0.0.0/0" # TODO: That should not exists
]

prod_web_access_ip_list = [
  "173.245.48.0/20", # Cloudflare
  "103.21.244.0/22",
  "103.22.200.0/22",
  "103.31.4.0/22",
  "141.101.64.0/18",
  "108.162.192.0/18",
  "190.93.240.0/20",
  "188.114.96.0/20",
  "197.234.240.0/22",
  "198.41.128.0/17",
  "162.158.0.0/15",
  "104.16.0.0/13",
  "104.24.0.0/14",
  "172.64.0.0/13",
  "131.0.72.0/22",

  "0.0.0.0/0" # TODO: That should not exists
]


# smartsafe

dev_smartsafe_access_ip_list = [
  "68.67.62.190/32",   # Gardaworld Montreal VPN
  "52.174.122.247/32", # Sesami Cloud VPN
  "213.251.33.249/32", # Sesami On-Demand VPN

  "0.0.0.0/0" # TODO: That should not exists
]

qa_smartsafe_access_ip_list = [
  "68.67.62.190/32",   # Gardaworld Montreal VPN
  "52.174.122.247/32", # Sesami Cloud VPN
  "213.251.33.249/32", # Sesami On-Demand VPN

  "0.0.0.0/0" # TODO: That should not exists
]

demo_smartsafe_access_ip_list = [
  "0.0.0.0/0" # TODO: That should not exists
]

# uat_smartsafe_access_ip_list = [
#   "0.0.0.0/0" # TODO: That should not exists
# ]

preprod_smartsafe_access_ip_list = [
  "0.0.0.0/0" # TODO: That should not exists
]

prod_smartsafe_access_ip_list = [
  "0.0.0.0/0" # TODO: That should not exists
]
