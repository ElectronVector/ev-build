# ev-build

This is a simple tool for using Docker to create build and test environments, while hiding the Docker details from users. You use it by modifying the **Dockerfile** to set up your build environment, and then putting the Dockerfile and the **ev** scripts (ev and ev.bat) in with your source code. Script are provided for use with Windows or Bash.

## How it works

The **ev** scripts are used to run commands inside of a container -- as defined by the **Dockerfile.** When using an **ev** script it will use the Dockerfile to build an image if it doesn't exist. Once the image is created it will run the provided command on a new container created from the image.

Each time the container is run, the files in your local folder are shared into the **/app** folder in the container. This allows you to access the files from the host as well as to generate output files that show up on the host.

## Usage

Put `ev` in front of your commands and they will run in the container:

```
> ev pwd
/app
```

```
> ev ls
Dockerfile
README.md
ev
ev.bat
```

Note that because the files are shared with the host, you see your host files when you run an `ls` in the container.

The ev.bat script will be run on Windows, but you can also run with the Bash script:

```
$ ./ev ls
Dockerfile
README.md
ev
ev.bat
```

## Creating your environment

To create the specific environment you need for your application, you need to modify the **Dockerfile** to install your dependencies. This is done by modifying the `RUN` statements to install new tools. The example Dockerfile included in this repository installs GCC and Ceedling (and Ruby), but you won't necessarily need those.

Change these lines in the Docker file, or add new ones:

```dockerfile
RUN apt-get update && apt-get install -y ruby gcc
RUN gem install ceedling
```

## Forcing a rebuild

You can force ev to rebuild the image by passing `--build` before any arguments:

```
$ ./ev --build pwd
Sending build context to Docker daemon  22.02kB
Step 1/4 : FROM ubuntu:18.04
 ---> 3556258649b2
Step 2/4 : WORKDIR /app
 ---> Using cache
 ---> fbe45d2689fc
Step 3/4 : RUN apt-get update && apt-get install -y ruby gcc
 ---> Using cache
 ---> 8c7d69c71b47
Step 4/4 : RUN gem install ceedling
 ---> Using cache
 ---> 04da7d58d7e4
Successfully built 04da7d58d7e4
Successfully tagged c_dev_ev-build:latest
/app
```

## Open a terminal

Use the `--term` argument to open a terminal session into a running container:

```
c:\dev\ev-build>ev --term
root@04fd76e5f447:/app#
```