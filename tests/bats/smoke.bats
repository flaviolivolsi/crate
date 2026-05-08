#!/usr/bin/env bats
# Smoke tests for crate. Don't require LLM API keys or mpd running.

setup() {
    export CRATE_TEST_ROOT="$(mktemp -d)"
    export CRATE_CONFIG="$CRATE_TEST_ROOT/crate.toml"
    cat > "$CRATE_CONFIG" <<EOF
[paths]
root = "$CRATE_TEST_ROOT/audio"
EOF
    CRATE_BIN="$BATS_TEST_DIRNAME/../../bin/crate"
    export PATH="$BATS_TEST_DIRNAME/../../bin:$PATH"
}

teardown() {
    rm -rf "$CRATE_TEST_ROOT"
}

@test "crate --help works" {
    run crate --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"personal audio crates"* ]]
}

@test "crate list on empty root" {
    run crate list
    [ "$status" -eq 0 ]
    [[ "$output" == *"no crates yet"* ]]
}

@test "crate doctor exits with status when deps missing" {
    # doctor exits 1 if any check fails — ok for smoke
    run crate doctor
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
    [[ "$output" == *"yt-dlp"* ]]
}

@test "crate new requires description or stdin" {
    run bash -c "echo '' | crate new testcrate"
    [ "$status" -ne 0 ]
}

@test "crate new with description creates folder + meta" {
    run crate new testcrate --description "test crate prose"
    [ "$status" -eq 0 ]
    [ -d "$CRATE_TEST_ROOT/audio/testcrate" ]
    [ -f "$CRATE_TEST_ROOT/audio/testcrate/.crate.json" ]
    [ -d "$CRATE_TEST_ROOT/audio/testcrate/.trash" ]
    grep -q "test crate prose" "$CRATE_TEST_ROOT/audio/testcrate/.crate.json"
}

@test "crate list shows created crate" {
    crate new testcrate --description "test"
    run crate list
    [ "$status" -eq 0 ]
    [[ "$output" == *"testcrate"* ]]
}

@test "crate use sets active" {
    crate new a --description "test a"
    crate new b --description "test b"
    run crate use b
    [ "$status" -eq 0 ]
    run crate list
    [[ "$output" == *"* b"* ]]
}

@test "crate use rejects unknown crate" {
    run crate use nonexistent
    [ "$status" -ne 0 ]
}
