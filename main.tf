module "dev_clusterAKS" {
    source       = "./aks"
    env_name     = "dev"
    cluster_name = "learnk8scluster"
    instance_type= "standard_d2_v2"
    helm_name = "moodle"
    username = "moodleUsername"
    password = "moodlePassword"
}

module "dev_virtualmachine" {
    source       = "./vm"
    env_name     = "dev"
}

module "prod_clusterAKS" {
    source       = "./aks"
    env_name     = "prod"
    cluster_name = "learnk8scluster"
    instance_type= "standard_d2_v2"
    helm_name = "wordpress"
    username = "wordpressUsername"
    password = "wordpressPassword"
}

module "prod_virtualmachine" {
    source       = "./vm"
    env_name     = "prod"
}