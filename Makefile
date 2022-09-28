deploy-aws:
	sam build && sam deploy

deploy-react:
	aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app

build-react:
	cd react-app/ && npm run build

build-aws: 
	sam build

list-stacks:
	aws cloudformation list-stacks

nuke-stack:
	aws cloudformation delete-stack --stack-name sam-app

nuke-react:
	aws s3 rm s3://wpt.bap.tn.react-app --recursive && aws s3 rm s3://wpt.bap.tn.logs --recursive && aws s3 rb s3://wpt.bap.tn.react-app --force && aws s3 rb s3://wpt.bap.tn.logs --force