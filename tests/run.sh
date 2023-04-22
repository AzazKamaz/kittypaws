#!/bin/sh
set -e

output=$(paws tests/sut/test_config.json)

if echo "$output" | grep -q "Running"; then
  echo "Success: Plugin is running."
else
  echo "Error: Plugin is not running."
  exit 1
fi
