#!/bin/bash

killall -9 ruby # for hosting service

~/init.d/mongrel restart production
