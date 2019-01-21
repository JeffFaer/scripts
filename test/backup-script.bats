#!/usr/bin/env bats

# @param? test_case the test case name, or $BATS_TEST_DESCRIPTION
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
  mkdir "${dest_dir}"

  (
    cd "${tmp_dir}"
    run backup-script --date "${date}" --destination-root "${dest_dir}" "${paths_to_backup[@]}"
    [[ $status -eq 0 ]]
  )

  run diff -x log -x packages.txt "${test_case_dir}/dest" "${dest_dir}"/*/
  echo "$output"
  [[ $status -eq 0 ]]
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
