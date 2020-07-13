APPNAME=loggen

# build compiles the code into an executable on local machine
build:
	go build -o ./bin/$(APPNAME)

# run executes the built executable locally.
# Can take in arguments to the executable via ARGS. E.g. make run ARGS="-debug"
run:
	./bin/$(APPNAME) $(ARGS)

# builddocker builds a docker image by first compiling the code for linux
# and then copying the binary into the alpine-based docker image (ref. Dockerfile)
builddocker:
	GOOS=linux GOARCH=amd64 go build -o ./bin/main
	docker build -t $(APPNAME):latest .

# the following modes change the docker context
# "server" is a pre-configured context to connect to a Docker engine running in a server via SSH
deploymode:
	docker context use server

localmode:
	docker context use default


# runlocal runs the built docker image locally (mounts $PWD)
runlocal:
	docker run --name $(APPNAME) --rm -d -v $(PWD)/logs:/app/logs $(APPNAME):latest $(ARGS)

# runserver runs the built docker image on server (used when in deploy mode) (mounts remote directories)
runserver:
	docker run --name $(APPNAME) --rm -d -v /home/ubuntu/docker/$(APPNAME)/logs:/app/logs $(APPNAME):latest $(ARGS)

# stopdocker stops (either locally or remotely) running container
stopdocker:
	docker stop $(APPNAME)

# readloags reads the logs from (either locally or remotely) running container
readlogs:
	docker logs -f --tail 1 $(APPNAME)

# restartdeploy stops the running container on server, builds the docker and runs the new one
restartdeploy: stopdocker builddocker runserver

# restartlocal stops the running container on local machine, builds the docker and runs the new one
restartlocal: stopdocker builddocker runlocal