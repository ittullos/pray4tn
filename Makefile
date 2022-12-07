deploy-aws:
	sam build --use-container && sam deploy

deploy-react:
	aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app

build-react:
	cd react-app/ && npm run build

refresh-react:
	cd react-app/ && npm run build && cd .. && aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app && aws cloudfront create-invalidation --distribution-id E738Q3ALC03PW --paths "/*" --no-cli-pager

build-aws: 
	sam build

list-stacks:
	aws cloudformation list-stacks

nuke-stack:
	aws cloudformation delete-stack --stack-name wpt-bap-tn

nuke-react:
	aws s3 rm s3://wpt.bap.tn.react-app --recursive && aws s3 rm s3://wpt.bap.tn.logs --recursive && aws s3 rb s3://wpt.bap.tn.react-app --force && aws s3 rb s3://wpt.bap.tn.logs --force

empty-react:
	aws s3 rm s3://wpt.bap.tn.react-app --recursive && aws s3 rm s3://wpt.bap.tn.logs --recursive

run-dev:
	RACK_ENV=dev rackup

seed-dev:
	RACK_ENV=dev rake db:seed

migrate-dev:
	RACK_ENV=dev rake db:migrate

migrate-test:
	RACK_ENV=test rake db:migrate

migrate-prod:
	RACK_ENV=prod rake db:migrate

test-app:
	rspec ./spec/app_spec.rb

