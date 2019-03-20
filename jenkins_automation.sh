HOME_DIR=$(pwd)

AWS_KEY=$1
if [ "$AWS_KEY" = "" ]; then
    echo "Variable AWS_KEY not set" 1>&2
    exit 1
fi

AWS_SECRET=$2
if [ "$AWS_SECRET" = "" ]; then
    echo "Variable AWS_SECRET not set" 1>&2
    exit 1
fi

REGION=$3
if [ "$REGION" = "" ]; then
    echo "Variable REGION not set" 1>&2
    exit 1
fi

USERNAME=$4
if [ "$USERNAME" = "" ]; then
    echo "Variable USERNAME not set" 1>&2
    exit 1
fi

PASSWORD=$5
if [ "$PASSWORD" = "" ]; then
    echo "Variable PASSWORD not set" 1>&2
    exit 1
fi

BACKEND_BUCKET=$6
if [ "$BACKEND_BUCKET" = "" ]; then
    BACKEND_BUCKET=labacicdterraform
fi

KEY_NAME=$7
if [ "$KEY_NAME" = "" ]; then
    KEY_NAME=work_us_east
fi

CLUSTER_NAME=$8
if [ "$CLUSTER_NAME" = "" ]; then
    CLUSTER_NAME=labacicd
fi

echo "Exporting AWS keys"
export AWS_ACCESS_KEY_ID="$AWS_KEY"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET"

echo "Installation Packer"

apt-get update -y && apt-get install -y unzip

if [ "$?" = "0" ]; then
    echo "Unzip installed"
else
    echo "Unzip installation failed" 1>&2
    exit 1
fi

if ! [ -e /usr/local/bin/packer ]; then
    curl -L "https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_linux_amd64.zip" >> /usr/local/bin/packer.zip

    if [ "$?" = "0" ]; then
        echo "Packer added"
    else
        echo "Packer download failed" 1>&2
        exit 1
    fi

    unzip /usr/local/bin/packer.zip -d /usr/local/bin

    if [ "$?" = "0" ]; then
        echo "Packer installed"
        rm -rf /usr/local/bin/packer.zip
    else
        echo "Packer installation failed" 1>&2
        exit 1
    fi

fi

echo "Installation Terraform"
if ! [ -e /usr/local/bin/terraform ]; then
    curl -L "https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip" >> /usr/local/bin/terraform.zip

    if [ "$?" = "0" ]; then
        echo "Terraform added"
    else
        echo "Terraform download failed" 1>&2
        exit 1
    fi

    unzip /usr/local/bin/terraform.zip -d /usr/local/bin

    if [ "$?" = "0" ]; then
        echo "Terraform installed"
        rm -rf /usr/local/bin/terraform.zip
    else
        echo "Terraform installation failed" 1>&2
        exit 1
    fi
fi
echo "Creating AMI"
cd $HOME_DIR/packer
AMI_ID=$(packer build -var "aws_access_key=$AWS_KEY" -var "aws_secret_key=$AWS_SECRET" -var "region=$REGION" -var "jenkins_admin_username=$USERNAME" -var "jenkins_admin_password=$PASSWORD" jenkins_ami.json | egrep 'ami-.*' -o | tail -n 1)
if echo $AMI_ID | grep 'ami-.*'; then
    echo "Packer built"
else
    echo "Packer failed" 1>&2
    exit 1
fi

cd $HOME_DIR/terraform/jenkins
terraform init -backend-config="bucket=${BACKEND_BUCKET}"
if [ "$?" = "0" ]; then
    echo "Terraform successfully initialized"
else
    echo "Failed to initialize Terraform" 1>&2
    exit 1
fi

terraform apply -var "ami_id=${AMI_ID}" -var "cluster_name=${CLUSTER_NAME}" -var "key_name=${KEY_NAME}"  -var "bucket=${BACKEND_BUCKET}" -auto-approve
if [ "$?" = "0" ]; then
    echo "Terraform successfully applied"
else
    echo "Failed to apply Terraform" 1>&2
    exit 1
fi
