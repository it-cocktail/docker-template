#!/bin/sh

test -t 1 && export COMPOSE_INTERACTIVE_NO_CLI=0 || export COMPOSE_INTERACTIVE_NO_CLI=1
