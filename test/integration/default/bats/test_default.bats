#!/usr/bin/env bats

@test "primary avahi name (avahi.test-kitchen.local) responds to ping" {
  run ping -c 1 -q avahi.test-kitchen.local
  [ "$status" -eq 0 ]
}

@test "avahi alias (alias.test-kitchen.local) is published" {
  run avahi-list-aliases
  echo "$output" | grep "^alias.test-kitchen.local$"
}

@test "avahi alias (alias.test-kitchen.local) responds to ping" {
  run ping -c 1 -q alias.test-kitchen.local
  [ "$status" -eq 0 ]
}
