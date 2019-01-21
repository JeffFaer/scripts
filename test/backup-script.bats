#!/usr/bin/env bats

# @param? test_case the test case name, or $BATS_TEST_DESCRIPTION
#
# Sets GOLDEN_FILE_TEST_DIR to the directory used to run the test.
run_golden_file_test() {
  local test_case=${1:-$BATS_TEST_DESCRIPTION}
  local test_case_dir="${BATS_TEST_DIRNAME}/backup-script/${test_case}"

  local IFS=$'\n'
  local paths_to_backup=( $(cat "${test_case_dir}/paths_to_backup") )
  unset IFS

  [[ ${#paths_to_backup[@]} -gt 0 ]]

  local date=$(cat "${test_case_dir}/date")

  [[ -n ${date} ]]

  local tmp_dir=$(mktemp -d -p "${BATS_TMPDIR}" "${test_case}.XXXXX")
  GOLDEN_FILE_TEST_DIR=$tmp_dir

  # Copy source files to tmp_dir
  local path
  for path in "${paths_to_backup[@]}"; do
      local src_path="${test_case_dir}/${path}"
      local src_dirname=$(dirname "${path}")

      mkdir -p "${tmp_dir}/${src_dirname}"
      cp -r "${src_path}" "${tmp_dir}/${src_dirname}"
  done

  # Make dir to backup to.
  local dest_dir="${tmp_dir}/dest"
  if [[ -d "${test_case_dir}/initial-dest" ]]; then
      cp -r "${test_case_dir}/initial-dest" "${dest_dir}"
  else
      mkdir "${dest_dir}"
  fi

  (
    cd "${tmp_dir}"
    run backup-script --date "${date}" --destination-root "${dest_dir}" "${paths_to_backup[@]}"
    [[ $status -eq 0 ]]
  )

  run diff -r -x log -x packages.txt "${test_case_dir}/dest" "${dest_dir}"
  echo "$output"
  [[ $status -eq 0 ]]
}

assert_hardlinked() {
    local first="${GOLDEN_FILE_TEST_DIR}/dest/$1"
    local second="${GOLDEN_FILE_TEST_DIR}/dest/$2"

    [[ "$(stat --format '%i' "$first")" == "$(stat --format '%i' "$second")" ]]
}

assert_not_hardlinked() {
    local file="${GOLDEN_FILE_TEST_DIR}/dest/$1"
    [[ $(stat --format '%h' "$file") -eq 1 ]]
}

@test "no-previous-backup" {
  run_golden_file_test
}

@test "no-previous-backup-multiple-srcs" {
  run_golden_file_test
}

@test "no-previous-backup-relative-srcs" {
  run_golden_file_test
}

@test "no-previous-backup-excluded-files" {
  run_golden_file_test
}

@test "previous-backup-creates-hardlinks" {
  run_golden_file_test

  assert_hardlinked '2019.01.01/src1/hardlinked' '2019.01.05/src1/hardlinked'
  assert_hardlinked '2019.01.01/src2/hardlinked' '2019.01.05/src2/hardlinked'
  assert_not_hardlinked '2019.01.05/src1/newfile'
  assert_not_hardlinked '2019.01.05/src2/newfile'
}
