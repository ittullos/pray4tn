# DEPLOY=================================================================
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

# STACK==================================================================
list-stacks:
	aws cloudformation list-stacks

nuke-stack:
	aws cloudformation delete-stack --stack-name wpt-bap-tn

# REACT==================================================================
nuke-react:
	aws s3 rm s3://wpt.bap.tn.react-app --recursive && aws s3 rm s3://wpt.bap.tn.logs --recursive && aws s3 rb s3://wpt.bap.tn.react-app --force && aws s3 rb s3://wpt.bap.tn.logs --force

empty-react:
	aws s3 rm s3://wpt.bap.tn.react-app --recursive && aws s3 rm s3://wpt.bap.tn.logs --recursive

run-react:
	cd react-app && npm start

# SINATRA=================================================================
run-dev:
	RACK_ENV=dev rackup

# SEED====================================================================
seed-dev:
	RACK_ENV=dev rake db:seed

seed-test:
	RACK_ENV=test rake db:seed

seed-prod:
	RACK_ENV=prod rake db:seed


# MIGRATE=================================================================
migrate-dev:
	RACK_ENV=dev rake db:migrate

migrate-test:
	RACK_ENV=test rake db:migrate

migrate-prod:
	RACK_ENV=prod rake db:migrate

# TEST=================================================================
test-app:
	RACK_ENV=test rspec ./spec/app_spec.rb

test-checkpoints:
	RACK_ENV=test rspec ./spec/checkpoint_spec.rb

test-routes:
	RACK_ENV=test rspec ./spec/route_spec.rb

# test-stats:
# 	RACK_ENV=test rspec ./spec/stats_spec.rb

test-user-residents:
	RACK_ENV=test rspec ./spec/user_resident_spec.rb

test-users:
	RACK_ENV=test rspec ./spec/user_spec.rb

test-verses:
	RACK_ENV=test rspec ./spec/verse_spec.rb

# MOVE_DB=================================================================
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

move-devotionals-2-1:
	ruby db/move_ddb/2-1/move_devotionals.rb

# SCAN_DB=================================================================
scan-checkpoints:
	aws dynamodb scan --table-name wpt.bap.tn.checkpoint --endpoint-url http://localhost:8000

scan-commitments:
	aws dynamodb scan --table-name wpt.bap.tn.commitment --endpoint-url http://localhost:8000

scan-devotionals:
	aws dynamodb scan --table-name wpt.bap.tn.devotional --endpoint-url http://localhost:8000

scan-journeys:
	aws dynamodb scan --table-name wpt.bap.tn.journey --endpoint-url http://localhost:8000

scan-routes:
	aws dynamodb scan --table-name wpt.bap.tn.route --endpoint-url http://localhost:8000

scan-user-residents:
	aws dynamodb scan --table-name wpt.bap.tn.resident --endpoint-url http://localhost:8000

scan-users:
	aws dynamodb scan --table-name wpt.bap.tn.user --endpoint-url http://localhost:8000

scan-verses:
	aws dynamodb scan --table-name wpt.bap.tn.verse --endpoint-url http://localhost:8000

# DATABASE=================================================================
run-local-db:
	java -Djava.library.path=~/Documents/database/dynamodb_local_latest/DynamoDBLocal_lib -jar ~/Documents/database/dynamodb_local_latest/DynamoDBLocal.jar -sharedDb

list-tables:
	aws dynamodb list-tables --endpoint-url http://localhost:8000


  # aws dynamodb delete-table --table-name UserResident --endpoint-url http://localhost:8000