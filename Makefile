deploy-aws:
	sam build && sam deploy

deploy-react:
	aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app

build-react:
	cd react-app/ && yarn run build

build-aws: 
	sam build