#!/usr/bin/env bash

IMG="alpine-go-builder"
USERNAME="golang"
GROUPNAME="golang"
USERID=5000
GROUPID=5000
TAG=""
LATEST=F
PREFIX=""

main() {
	while getopts ":hlu:g:U:G:t:p:" opt; do
		case ${opt} in
			h )
				usage
				exit 2
				;;
			l )
				LATEST=T
				;;
			u )
				USERNAME=$OPTARG
				;;
			g )
				GROUPNAME=$OPTARG
				;;
			U )
				USERID=$OPTARG
				;;
			G )
				GROUPID=$OPTARG
				;;
			t )
				TAG=$OPTARG
				;;
			p )
				PREFIX=$OPTARG
				;;
			\? )
				echo "Invalid option: -$OPTARG" 1>&2
				echo
				usage
				exit 1
				;;
			: )
				echo "Invalid option: -$OPTARG requires an argument" 1>&2
				echo
				usage
				exit 1
				;;
		esac
	done
	shift $((OPTIND -1))

	run
}

usage() {
	echo "Usage: $0 -t TAG [OPTIONS]"
	echo "      Build the $IMG image."
	echo "  -u USERNAME"
	echo "      The username for the user inside the container."
	echo "      (default: golang)"
	echo "  -g GROUPNAME"
	echo "      The group name for the user inside the container."
	echo "      (default: golang)"
	echo "  -U USERID"
	echo "      The user ID for the user inside the container."
	echo "      (default: 5000)"
	echo "  -G GROUPID"
	echo "      The group ID for the user inside the container."
	echo "      (default: 5000)"
	echo "  -t"
	echo "      The release tag."
	echo "      (required)"
	echo "  -l"
	echo "      Tag this release as the latest build."
	echo "      (default: F)"
	echo "  -p PREFIX"
	echo "      The prefix for the image name. (i.e. PREFIX/IMAGENAME)"
}

run() {
	if [[ -z "$TAG" ]]; then
		echo "You must provide a tag for this build."
		usage
		exit 1
	fi
	if [[ ! -z "$PREFIX" ]]; then
		PREFIX="${PREFIX}/"
	fi

	build
}

build() {
	docker build -t "${PREFIX}${IMG}:${TAG}" \
		--build-arg "USER=${USERNAME}" \
		--build-arg "GROUP=${GROUPNAME}" \
		--build-arg "UID=${USERID}" \
		--build-arg "GID=${GROUPID}" .
	if [[ $LATEST == "T" ]]; then
		docker tag "${PREFIX}${IMG}:${TAG}" "${PREFIX}${IMG}:latest"
	fi
}

main $@
