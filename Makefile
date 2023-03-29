deploy-build-aws:
	sam build && sam deploy

deploy-build-aws-2:
	sam build -t template2.yaml && sam deploy --config-file samconfig2.toml

deploy-aws:
	sam deploy

deploy-aws-2:
	sam deploy --config-file samconfig2.toml

deploy-react:
	aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app

deploy-react-2:
	aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app.2

build-react:
	cd react-app/ && npm run build

refresh-react:
	cd react-app/ && npm run build && cd .. && aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app && aws cloudfront create-invalidation --distribution-id E18AQ3ZZWHCBWT --paths "/*" --no-cli-pager

refresh-react-2:
	cd react-app/ && npm run build && cd .. && aws s3 sync ./react-app/build s3://wpt.bap.tn.react-app.2 && aws cloudfront create-invalidation --distribution-id ETIZ36L5JBOK6 --paths "/*" --no-cli-pager

build-aws: 
	sam build

build-aws-2:
	sam build -t template2.yaml

list-stacks:
	aws cloudformation list-stacks

nuke-stack:
	aws cloudformation delete-stack --stack-name wpt-bap-tn

nuke-react:
	aws s3 rm s3://wpt.bap.tn.react-app --recursive && aws s3 rm s3://wpt.bap.tn.logs --recursive && aws s3 rb s3://wpt.bap.tn.react-app --force && aws s3 rb s3://wpt.bap.tn.logs --force

empty-react:
	aws s3 rm s3://wpt.bap.tn.react-app --recursive && aws s3 rm s3://wpt.bap.tn.logs --recursive

run-react:
	cd react-app && npm start

run-dev:
	RACK_ENV=dev rackup

seed-dev:
	RACK_ENV=dev rake db:seed

seed-test:
	RACK_ENV=test rake db:seed

seed-prod:
	RACK_ENV=prod rake db:seed

migrate-dev:
	RACK_ENV=dev rake db:migrate

migrate-test:
	RACK_ENV=test rake db:migrate

migrate-prod:
	RACK_ENV=prod rake db:migrate

test-app:
	rspec ./spec/app_spec.rb

test-checkpoint:
	rspec ./spec/checkpoint_spec.rb

test-user:
	rspec ./spec/user_spec.rb

test-route:
	rspec ./spec/route_spec.rb

mysql-dev:
	mysql --user=root -p

mysql-prod:
	mysql -h wpt-bap-tn-prod.cnklfpyep1np.us-east-1.rds.amazonaws.com -P 3306 -u admin -p

move-users-1-2:
	ruby db/move_ddb/1-2/move_users.rb

move-checkpoints-1-2:
	ruby db/move_ddb/1-2/move_checkpoints.rb

move-routes-1-2:
	ruby db/move_ddb/1-2/move_routes.rb

move-verses-1-2:
	ruby db/move_ddb/1-2/move_verses.rb

move-users-2-1:
	ruby db/move_ddb/2-1/move_users.rb

move-checkpoints-2-1:
	ruby db/move_ddb/2-1/move_checkpoints.rb

move-routes-2-1:
	ruby db/move_ddb/2-1/move_routes.rb

move-verses-2-1:
	ruby db/move_ddb/2-1/move_verses.rb