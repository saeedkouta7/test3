 terraform {
   backend "s3" {
	bucket 			= "ivolve-test-121"
	key 			= "terraform.tfstate"			
	region 			= "us-east-1"
	dynamodb_table  	= "ivolve-lock"
	encrypt 		= true
  }
}

